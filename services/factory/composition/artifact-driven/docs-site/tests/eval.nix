let
  optionUtils = {
    mkBoolOpt = inputs: inputs;
    mkEnumOpt = inputs: inputs;
    mkStrOpt = inputs: inputs;
  };

  lib = {
    mkMerge = builtins.foldl' (
      acc: block:
      acc
      // block
      // {
        files = (acc.files or { }) // (block.files or { });
        assertions = (acc.assertions or [ ]) ++ (block.assertions or [ ]);
      }
    ) { };
    mkIf = condition: value: if condition then value else { };
    mkForce = value: value;
    optionalString = condition: string: if condition then string else "";
    optionalAttrs = condition: attrs: if condition then attrs else { };
  };

  moduleFor =
    {
      architecture ? "multiple",
      documentation ? "artifact-driven",
      ciProvider ? "github-actions",
      enable ? false,
      title ? "Documentation",
      url ? "https://example.github.io",
      baseUrl ? "/repo/",
      notificationProvider ? "unset",
      notificationSecret ? "DOCS_SITE_NOTIFICATION_WEBHOOK",
    }:
    import ../default.nix {
      inherit lib;
      config.factory = {
        _utils = optionUtils;
        domain = {
          documentation.use = documentation;
          repo-arch.use = architecture;
          ci-cd.provider.use = ciProvider;
        };
        composition.artifact-driven.docs-site = {
          inherit enable title url;
          base-url = baseUrl;
          notification = {
            provider = notificationProvider;
            webhook-secret = notificationSecret;
          };
        };
      };
      namespace = "factory";
    };

  evalModule = args: (moduleFor args).config;

  on = evalModule { enable = true; };
  googleChat = evalModule {
    enable = true;
    notificationProvider = "google-chat";
  };
  slack = evalModule {
    enable = true;
    notificationProvider = "slack";
    notificationSecret = "TEAM_WEBHOOK";
  };
  off = evalModule { };
  single = evalModule {
    enable = true;
    architecture = "single";
  };
  noCi = evalModule {
    enable = true;
    ciProvider = "unset";
  };
  noModel = evalModule {
    enable = true;
    documentation = "unset";
  };
  emptyUrl = evalModule {
    enable = true;
    url = "";
  };
  badBaseUrl = evalModule {
    enable = true;
    baseUrl = "repo";
  };
  invalidNotificationSecret = evalModule {
    enable = true;
    notificationProvider = "slack";
    notificationSecret = "invalid-secret";
  };
  invalidSetups = [
    single
    noCi
    noModel
    emptyUrl
    badBaseUrl
  ];

  site = "apps/documentation";
  copyFiles = [
    "${site}/package.json"
    "${site}/package-lock.json"
    "${site}/docusaurus.config.js"
    "${site}/sidebars.js"
    "${site}/site.json"
    "${site}/.gitignore"
    ".github/workflows/docs-site.yml"
    "docs/wiki/documentation/artifact-driven/docs-site.md"
  ];
  seedFiles = [
    "${site}/src/css/custom.css"
    "${site}/README.md"
  ];
  allFiles = copyFiles ++ seedFiles;
  sourced = builtins.filter (
    name: name != "${site}/site.json" && name != ".github/workflows/docs-site.yml"
  ) allFiles;
  fileOf = name: on.files.${name};
  textOf =
    name:
    let
      file = fileOf name;
    in
    if file ? text then file.text else builtins.readFile file.source;
  matches = pattern: text: builtins.match ".*${pattern}.*" text != null;
  assertionsPass = cfg: builtins.all (a: a.assertion) (cfg.assertions or [ ]);
  pkg = builtins.fromJSON (textOf "${site}/package.json");
  lock = builtins.fromJSON (textOf "${site}/package-lock.json");

  filesPresent = builtins.all (name: builtins.hasAttr name on.files) allFiles;
  sourcesExist = builtins.all (
    name: (fileOf name).source == ../_assets + "/${name}" && builtins.pathExists (fileOf name).source
  ) sourced;
  copyModes =
    builtins.all (name: (fileOf name).copyMode == "copy") copyFiles
    && builtins.all (name: (fileOf name).copyMode == "seed") seedFiles;
  siteJsonRoundTrip =
    builtins.fromJSON (fileOf "${site}/site.json").text == {
      title = "Documentation";
      url = "https://example.github.io";
      baseUrl = "/repo/";
    };
  packageJsonPinned =
    pkg.private == true
    && pkg.scripts.build == "docusaurus build"
    && pkg.dependencies."@docusaurus/core" == pkg.dependencies."@docusaurus/preset-classic"
    && builtins.match "3\\.9\\.[0-9]+" pkg.dependencies."@docusaurus/core" != null
    && !(builtins.hasAttr "type" pkg);
  lockfilePinned = lock.lockfileVersion >= 2;
  configMatches =
    let
      text = textOf "${site}/docusaurus.config.js";
    in
    builtins.all (pattern: matches pattern text) [
      "trailingSlash: true"
      "site\\.json"
      "'\\.\\./\\.\\./docs'"
      "routeBasePath: '/'"
      "format: 'detect'"
      "\\*\\*/templates/\\*\\*"
      "numberPrefixParser: false"
    ];
  workflowMatches =
    let
      text = textOf ".github/workflows/docs-site.yml";
    in
    builtins.all (pattern: matches pattern text) [
      "actions/upload-pages-artifact@v3"
      "actions/deploy-pages@v4"
      "working-directory: apps/documentation"
      "npm ci"
      "pages: write"
      "id-token: write"
    ];
  notificationFile = ".github/docs-site/notify.py";
  notificationOptionsMatch =
    let
      module = moduleFor { };
      options = module.options.factory.composition.artifact-driven.docs-site.notification;
    in
    options.provider.default == "unset"
    &&
      options.provider.values == [
        "unset"
        "google-chat"
        "slack"
      ]
    && options.webhook-secret.default == "DOCS_SITE_NOTIFICATION_WEBHOOK";
  notificationFilesMatch =
    !(builtins.hasAttr notificationFile on.files)
    && builtins.hasAttr notificationFile googleChat.files
    && googleChat.files.${notificationFile}.source == ../_assets/.github/docs-site/notify.py
    && googleChat.files.${notificationFile}.copyMode == "copy"
    && builtins.hasAttr notificationFile slack.files;
  notificationWorkflowsMatch =
    let
      disabled = on.files.".github/workflows/docs-site.yml".text;
      google = googleChat.files.".github/workflows/docs-site.yml".text;
      slackText = slack.files.".github/workflows/docs-site.yml".text;
    in
    !matches "Notify the team about the deployment" disabled
    && matches "actions/deploy-pages@v4.*Check out the notification code.*[.]github/docs-site/notify[.]py" google
    && matches "id-token: write.*contents: read" google
    && matches "persist-credentials: false" google
    && matches "DOCS_SITE_NOTIFICATION_PROVIDER: google-chat" google
    && matches "secrets[.]DOCS_SITE_NOTIFICATION_WEBHOOK" google
    && matches "DOCS_SITE_DEPLOYMENT_URL:.*steps[.]deployment[.]outputs[.]page_url" google
    && matches "DOCS_SITE_REPOSITORY:.*github[.]repository" google
    && matches "DOCS_SITE_REF_NAME:.*github[.]ref_name" google
    && matches "DOCS_SITE_COMMIT_SHA:.*github[.]sha" google
    && matches "DOCS_SITE_RUN_URL:.*github[.]server_url.*github[.]run_id" google
    && matches "DOCS_SITE_NOTIFICATION_PROVIDER: slack" slackText
    && matches "secrets[.]TEAM_WEBHOOK" slackText;
  gitignoreMatches =
    let
      text = textOf "${site}/.gitignore";
    in
    builtins.all (pattern: matches pattern text) [
      "node_modules/"
      "build/"
      "\\.docusaurus/"
    ];
  wikiPageMatches =
    let
      text = textOf "docs/wiki/documentation/artifact-driven/docs-site.md";
    in
    builtins.all (pattern: matches pattern text) [
      "npm run start"
      "GitHub Actions"
      "docs-site.notification"
      "DOCS_SITE_NOTIFICATION_WEBHOOK"
      "Google Chat incoming webhooks"
      "Slack incoming webhooks"
    ];
  onAssertionsPass = assertionsPass on;
  notificationAssertionsPass = assertionsPass googleChat && assertionsPass slack;
  invalidNotificationSecretRejected = !assertionsPass invalidNotificationSecret;
  offEmitsNothing = (off.files or { }) == { } && (off.assertions or [ ]) == [ ];
  invalidSetupsRejected = builtins.all (cfg: !assertionsPass cfg) invalidSetups;
in
assert filesPresent;
assert sourcesExist;
assert copyModes;
assert siteJsonRoundTrip;
assert packageJsonPinned;
assert lockfilePinned;
assert configMatches;
assert workflowMatches;
assert notificationOptionsMatch;
assert notificationFilesMatch;
assert notificationWorkflowsMatch;
assert gitignoreMatches;
assert wikiPageMatches;
assert onAssertionsPass;
assert notificationAssertionsPass;
assert invalidNotificationSecretRejected;
assert offEmitsNothing;
assert invalidSetupsRejected;
{
  inherit
    filesPresent
    sourcesExist
    copyModes
    siteJsonRoundTrip
    packageJsonPinned
    lockfilePinned
    configMatches
    workflowMatches
    notificationOptionsMatch
    notificationFilesMatch
    notificationWorkflowsMatch
    gitignoreMatches
    wikiPageMatches
    onAssertionsPass
    notificationAssertionsPass
    invalidNotificationSecretRejected
    offEmitsNothing
    invalidSetupsRejected
    ;
}
