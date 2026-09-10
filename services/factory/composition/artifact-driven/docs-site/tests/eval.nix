let
  optionUtils = {
    mkBoolOpt = inputs: inputs // { testType = "bool"; };
    mkEnumOpt = inputs: inputs // { testType = "enum"; };
    mkStrOpt = inputs: inputs // { testType = "str"; };
    mkListOpt =
      inputs:
      inputs
      // {
        testType = {
          kind = "list";
          element = inputs.ofType or null;
        };
      };
    mkAttrsOpt =
      inputs:
      inputs
      // {
        testType = {
          kind = "attrs";
          element = inputs.ofType or null;
        };
      };
  };

  lib = {
    types = {
      str = "str";
      bool = "bool";
      int = "int";
      float = "float";
      oneOf = members: {
        kind = "oneOf";
        inherit members;
      };
      enum = values: {
        kind = "enum";
        inherit values;
      };
      submodule = module: {
        kind = "submodule";
        inherit module;
      };
    };
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
    optional = condition: value: if condition then [ value ] else [ ];
    optionalAttrs = condition: attrs: if condition then attrs else { };
    concatStringsSep = builtins.concatStringsSep;
    concatMapStrings = f: values: builtins.concatStringsSep "" (map f values);
    mapAttrsToList = f: attrs: map (name: f name attrs.${name}) (builtins.attrNames attrs);
    unique =
      list:
      builtins.foldl' (
        items: item: if builtins.elem item items then items else items ++ [ item ]
      ) [ ] list;
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
      notificationUses ? [ ],
      notificationGoogleChatSecret ? "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK",
      notificationSlackSecret ? "DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK",
      notificationTelegramTokenSecret ? "DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN",
      notificationTelegramChatId ? "",
      staticDirectories ? [ ],
      workflowWatchPaths ? [ ],
      beforeNodeSetup ? [ ],
      beforeSiteBuild ? [ ],
      afterSiteBuild ? [ ],
    }:
    let
      normalizeStep =
        step:
        {
          name = null;
          uses = null;
          run = null;
          working-directory = null;
          "with" = { };
          env = { };
        }
        // step;
    in
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
          static-directories = staticDirectories;
          workflow = {
            watch-paths = workflowWatchPaths;
            build = {
              before-node-setup = map normalizeStep beforeNodeSetup;
              before-site-build = map normalizeStep beforeSiteBuild;
              after-site-build = map normalizeStep afterSiteBuild;
            };
          };
          notification = {
            uses = notificationUses;
            google-chat.webhook-secret = notificationGoogleChatSecret;
            slack.webhook-secret = notificationSlackSecret;
            telegram = {
              token-secret = notificationTelegramTokenSecret;
              chat-id = notificationTelegramChatId;
            };
          };
        };
      };
      namespace = "factory";
    };

  evalModule = args: (moduleFor args).config;

  on = evalModule { enable = true; };
  googleChat = evalModule {
    enable = true;
    notificationUses = [ "google-chat" ];
  };
  slack = evalModule {
    enable = true;
    notificationUses = [ "slack" ];
    notificationSlackSecret = "TEAM_SLACK_WEBHOOK";
  };
  multiProvider = evalModule {
    enable = true;
    notificationUses = [
      "google-chat"
      "slack"
      "telegram"
    ];
    notificationTelegramChatId = "-100123";
  };
  extensions = evalModule {
    enable = true;
    staticDirectories = [
      "static"
      "generated-static"
    ];
    workflowWatchPaths = [ "services/manual/docs/**" ];
    beforeNodeSetup = [
      {
        name = "Build the manual PDF";
        uses = "xu-cheng/latex-action@v4";
        "with" = {
          root_file = "manual.tex";
          working_directory = "services/manual/docs";
          latexmk_use_xelatex = true;
        };
        env = {
          TEXINPUTS = ".:./styles//:";
          RETRY_COUNT = 3;
          SCALE = 1.5;
        };
      }
    ];
    beforeSiteBuild = [
      {
        name = "Copy the manual PDF";
        run = ''
          mkdir -p static/manual
          cp "$PDF_SOURCE" static/manual/manual.pdf
        '';
        env.PDF_SOURCE = "../../services/manual/docs/manual.pdf";
        working-directory = "apps/documentation";
      }
    ];
    afterSiteBuild = [
      {
        name = "Check the first output";
        run = "test -f build/manual/manual.pdf";
      }
      {
        name = "Check the second output";
        run = "test -d build";
      }
    ];
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
    notificationUses = [ "slack" ];
    notificationSlackSecret = "invalid-secret";
  };
  emptyExtensionPath = evalModule {
    enable = true;
    staticDirectories = [ "" ];
  };
  stepWithUsesAndRun = evalModule {
    enable = true;
    beforeNodeSetup = [
      {
        uses = "actions/example@v1";
        run = "echo invalid";
      }
    ];
  };
  stepWithoutUsesOrRun = evalModule {
    enable = true;
    beforeNodeSetup = [ { name = "Invalid"; } ];
  };
  runStepWithInputs = evalModule {
    enable = true;
    beforeSiteBuild = [
      {
        run = "echo invalid";
        "with".value = "invalid";
      }
    ];
  };
  actionStepWithWorkingDirectory = evalModule {
    enable = true;
    beforeNodeSetup = [
      {
        uses = "actions/example@v1";
        working-directory = "apps/documentation";
      }
    ];
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
      staticDirectories = [ ];
    };
  extensionSiteJsonRoundTrip =
    builtins.fromJSON extensions.files."${site}/site.json".text == {
      title = "Documentation";
      url = "https://example.github.io";
      baseUrl = "/repo/";
      staticDirectories = [
        "static"
        "generated-static"
      ];
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
      "staticDirectories: site\\.staticDirectories"
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
  defaultWorkflowUnchanged =
    on.files.".github/workflows/docs-site.yml".text
    == builtins.readFile ../../../../../../.github/workflows/docs-site.yml;
  extensionOptionsMatch =
    let
      options = (moduleFor { }).options.factory.composition.artifact-driven.docs-site;
      stepType = options.workflow.build.before-node-setup.testType.element;
      stepOptions = stepType.module.options;
    in
    options.static-directories.default == [ ]
    &&
      options.static-directories.testType == {
        kind = "list";
        element = "str";
      }
    && options.workflow.watch-paths.default == [ ]
    && options.workflow.build.before-node-setup.default == [ ]
    && options.workflow.build.before-site-build.default == [ ]
    && options.workflow.build.after-site-build.default == [ ]
    && stepType.kind == "submodule"
    && stepOptions.name.testType == "str"
    && stepOptions.name.default == null
    && stepOptions.name.nullable
    && stepOptions.uses.testType == "str"
    && stepOptions.uses.default == null
    && stepOptions.uses.nullable
    &&
      stepOptions."with".testType == {
        kind = "attrs";
        element = {
          kind = "oneOf";
          members = [
            "str"
            "bool"
            "int"
            "float"
          ];
        };
      }
    && stepOptions."with".default == { }
    && stepOptions.run.testType == "str"
    && stepOptions.run.default == null
    && stepOptions.run.nullable
    &&
      stepOptions.env.testType == {
        kind = "attrs";
        element = {
          kind = "oneOf";
          members = [
            "str"
            "bool"
            "int"
            "float"
          ];
        };
      }
    && stepOptions.env.default == { }
    && stepOptions.working-directory.testType == "str"
    && stepOptions.working-directory.default == null
    && stepOptions.working-directory.nullable;
  extensionWorkflowMatches =
    let
      text = extensions.files.".github/workflows/docs-site.yml".text;
    in
    builtins.all (pattern: matches pattern text) [
      "[.]github/workflows/docs-site[.]yml.*services/manual/docs/[*][*]"
      "actions/checkout@v4.*Build the manual PDF.*xu-cheng/latex-action@v4.*latexmk_use_xelatex: true.*root_file.*manual[.]tex.*working_directory.*services/manual/docs.*RETRY_COUNT: 3.*SCALE: 1[.]5.*TEXINPUTS.*actions/setup-node@v4"
      "npm ci.*Copy the manual PDF.*mkdir -p static/manual.*PDF_SOURCE.*working-directory.*apps/documentation.*npm run build"
      "npm run build.*Check the first output.*Check the second output.*actions/upload-pages-artifact@v3"
    ];
  optionalCommandFieldsOmitted =
    let
      text = extensions.files.".github/workflows/docs-site.yml".text;
    in
    !matches "uses: null" text && !matches "run: null" text && !matches "working-directory: null" text;
  notificationFile = ".github/docs-site/notify.py";
  notificationOptionsMatch =
    let
      module = moduleFor { };
      options = module.options.factory.composition.artifact-driven.docs-site.notification;
    in
    options.uses.default == [ ]
    && options.google-chat.webhook-secret.default == "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK"
    && options.telegram.token-secret.default == "DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN";
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
      multiText = multiProvider.files.".github/workflows/docs-site.yml".text;
    in
    !matches "Notify the team about the deployment" disabled
    && matches "actions/deploy-pages@v4.*Check out the notification code.*[.]github/docs-site/notify[.]py" google
    && matches "id-token: write.*contents: read" google
    && matches "persist-credentials: false" google
    && matches "DOCS_SITE_NOTIFICATION_USES:.*google-chat" google
    && matches "secrets[.]DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK" google
    && matches "DOCS_SITE_DEPLOYMENT_URL:.*steps[.]deployment[.]outputs[.]page_url" google
    && matches "DOCS_SITE_REPOSITORY:.*github[.]repository" google
    && matches "DOCS_SITE_REF_NAME:.*github[.]ref_name" google
    && matches "DOCS_SITE_COMMIT_SHA:.*github[.]sha" google
    && matches "DOCS_SITE_RUN_URL:.*github[.]server_url.*github[.]run_id" google
    && matches "DOCS_SITE_NOTIFICATION_USES:.*slack" slackText
    && matches "secrets[.]TEAM_SLACK_WEBHOOK" slackText
    && matches "DOCS_SITE_NOTIFICATION_USES:.*google-chat.*slack.*telegram" multiText
    && matches "DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN.*DOCS_SITE_NOTIFICATION_TELEGRAM_CHAT_ID: \"-100123\"" multiText
    && !matches "Notify the team about the deployment.*Notify the team about the deployment" multiText;
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
      "static-directories"
      "workflow.build.before-node-setup"
      "xu-cheng/latex-action@v4"
      "latexmk_use_xelatex = true"
      "docusaurus.config.local.js"
      "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK"
      "Google Chat incoming webhooks"
      "Slack incoming webhooks"
    ];
  onAssertionsPass = assertionsPass on;
  notificationAssertionsPass = assertionsPass googleChat && assertionsPass slack;
  invalidNotificationSecretRejected = !assertionsPass invalidNotificationSecret;
  invalidExtensionsRejected = builtins.all (cfg: !assertionsPass cfg) [
    emptyExtensionPath
    stepWithUsesAndRun
    stepWithoutUsesOrRun
    runStepWithInputs
    actionStepWithWorkingDirectory
  ];
  offEmitsNothing = (off.files or { }) == { } && (off.assertions or [ ]) == [ ];
  invalidSetupsRejected = builtins.all (cfg: !assertionsPass cfg) invalidSetups;
in
assert filesPresent;
assert sourcesExist;
assert copyModes;
assert siteJsonRoundTrip;
assert extensionSiteJsonRoundTrip;
assert packageJsonPinned;
assert lockfilePinned;
assert configMatches;
assert workflowMatches;
assert defaultWorkflowUnchanged;
assert extensionOptionsMatch;
assert extensionWorkflowMatches;
assert optionalCommandFieldsOmitted;
assert notificationOptionsMatch;
assert notificationFilesMatch;
assert notificationWorkflowsMatch;
assert gitignoreMatches;
assert wikiPageMatches;
assert onAssertionsPass;
assert notificationAssertionsPass;
assert invalidNotificationSecretRejected;
assert invalidExtensionsRejected;
assert offEmitsNothing;
assert invalidSetupsRejected;
{
  inherit
    filesPresent
    sourcesExist
    copyModes
    siteJsonRoundTrip
    extensionSiteJsonRoundTrip
    packageJsonPinned
    lockfilePinned
    configMatches
    workflowMatches
    defaultWorkflowUnchanged
    extensionOptionsMatch
    extensionWorkflowMatches
    optionalCommandFieldsOmitted
    notificationOptionsMatch
    notificationFilesMatch
    notificationWorkflowsMatch
    gitignoreMatches
    wikiPageMatches
    onAssertionsPass
    notificationAssertionsPass
    invalidNotificationSecretRejected
    invalidExtensionsRejected
    offEmitsNothing
    invalidSetupsRejected
    ;
}
