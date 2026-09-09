let
  optionUtils = {
    mkBoolOpt = inputs: inputs;
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
        };
      };
      namespace = "factory";
    };

  evalModule = args: (moduleFor args).config;

  on = evalModule { enable = true; };
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
  sourced = builtins.filter (name: name != "${site}/site.json") allFiles;
  fileOf = name: on.files.${name};
  textOf = name: builtins.readFile (fileOf name).source;
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
  siteJsonRoundTrip = builtins.fromJSON (fileOf "${site}/site.json").text == {
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
    ];
  onAssertionsPass = assertionsPass on;
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
assert gitignoreMatches;
assert wikiPageMatches;
assert onAssertionsPass;
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
    gitignoreMatches
    wikiPageMatches
    onAssertionsPass
    offEmitsNothing
    invalidSetupsRejected
    ;
}
