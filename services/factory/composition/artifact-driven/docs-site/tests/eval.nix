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
      folder ? "azure-pipelines",
      enable ? false,
      title ? "Documentation",
      url ? "https://example.github.io",
      baseUrl ? "/repo/",
      target ? "github-pages",
      apiTokenSecret ? "DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN",
      deployTool ? "official-task",
      notificationUses ? [ ],
      notificationGoogleChatSecret ? "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK",
      notificationSlackSecret ? "DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK",
      notificationTelegramTokenSecret ? "DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN",
      notificationTelegramChatId ? "",
      staticDirectories ? [ ],
      featureOrder ? [ ],
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
          ci-cd.provider = {
            use = ciProvider;
            azure-pipelines.folder = folder;
          };
        };
        composition.artifact-driven.docs-site = {
          inherit
            enable
            title
            url
            target
            ;
          base-url = baseUrl;
          azure-static-web-app = {
            api-token-secret = apiTokenSecret;
            deploy-tool = deployTool;
          };
          static-directories = staticDirectories;
          sidebar.feature-order = featureOrder;
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
  extensionStaticDirectories = [
    "static"
    "generated-static"
  ];
  extensionWatchPaths = [ "services/manual/docs/**" ];
  extensionBeforeNodeSetup = [
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
  extensionBeforeSiteBuild = [
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
  extensionAfterSiteBuild = [
    {
      name = "Check the first output";
      run = "test -f build/manual/manual.pdf";
    }
    {
      name = "Check the second output";
      run = "test -d build";
    }
  ];
  extensions = evalModule {
    enable = true;
    staticDirectories = extensionStaticDirectories;
    workflowWatchPaths = extensionWatchPaths;
    beforeNodeSetup = extensionBeforeNodeSetup;
    beforeSiteBuild = extensionBeforeSiteBuild;
    afterSiteBuild = extensionAfterSiteBuild;
  };
  selectedFeatureOrder = evalModule {
    enable = true;
    featureOrder = [
      "feat-second"
      "feat-first"
    ];
  };
  emptyFeatureName = evalModule {
    enable = true;
    featureOrder = [ "" ];
  };
  duplicateFeatureName = evalModule {
    enable = true;
    featureOrder = [
      "feat-first"
      "feat-first"
    ];
  };
  azure = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
  };
  azureMultiProvider = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    notificationUses = [
      "google-chat"
      "slack"
      "telegram"
    ];
    notificationTelegramChatId = "-100123";
  };
  azureExtensions = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    staticDirectories = extensionStaticDirectories;
    workflowWatchPaths = extensionWatchPaths;
    beforeNodeSetup = extensionBeforeNodeSetup;
    beforeSiteBuild = extensionBeforeSiteBuild;
    afterSiteBuild = extensionAfterSiteBuild;
  };
  azureCustomFolder = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    folder = "ci/azure";
  };
  githubCustomFolder = evalModule {
    enable = true;
    ciProvider = "github-actions";
    folder = "ci/azure";
  };
  badCiProvider = evalModule {
    enable = true;
    ciProvider = "gitlab";
  };
  azureEmptyPath = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    staticDirectories = [ "" ];
  };
  azureStepWithUsesAndRun = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    beforeNodeSetup = [
      {
        uses = "actions/example@v1";
        run = "echo invalid";
      }
    ];
  };
  githubAzure = evalModule {
    enable = true;
    target = "azure-static-web-app";
  };
  azureSwa = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    target = "azure-static-web-app";
  };
  githubAzureCustomSecret = evalModule {
    enable = true;
    target = "azure-static-web-app";
    apiTokenSecret = "CUSTOM_SWA_TOKEN";
  };
  azureSwaCustomSecret = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    target = "azure-static-web-app";
    apiTokenSecret = "CUSTOM_SWA_TOKEN";
  };
  githubAzureMulti = evalModule {
    enable = true;
    target = "azure-static-web-app";
    notificationUses = [
      "google-chat"
      "slack"
      "telegram"
    ];
    notificationTelegramChatId = "-100123";
  };
  azureSwaMulti = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    target = "azure-static-web-app";
    notificationUses = [
      "google-chat"
      "slack"
      "telegram"
    ];
    notificationTelegramChatId = "-100123";
  };
  githubAzureExtensions = evalModule {
    enable = true;
    target = "azure-static-web-app";
    staticDirectories = extensionStaticDirectories;
    workflowWatchPaths = extensionWatchPaths;
    beforeNodeSetup = extensionBeforeNodeSetup;
    beforeSiteBuild = extensionBeforeSiteBuild;
    afterSiteBuild = extensionAfterSiteBuild;
  };
  azureSwaExtensions = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    target = "azure-static-web-app";
    staticDirectories = extensionStaticDirectories;
    workflowWatchPaths = extensionWatchPaths;
    beforeNodeSetup = extensionBeforeNodeSetup;
    beforeSiteBuild = extensionBeforeSiteBuild;
    afterSiteBuild = extensionAfterSiteBuild;
  };
  githubAzureOfficial = evalModule {
    enable = true;
    target = "azure-static-web-app";
    deployTool = "official-task";
  };
  azureSwaOfficial = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    target = "azure-static-web-app";
    deployTool = "official-task";
  };
  githubSwaCli = evalModule {
    enable = true;
    target = "azure-static-web-app";
    deployTool = "swa-cli";
  };
  azureSwaCli = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    target = "azure-static-web-app";
    deployTool = "swa-cli";
  };
  githubSwaCliFull = evalModule {
    enable = true;
    target = "azure-static-web-app";
    deployTool = "swa-cli";
    beforeSiteBuild = extensionBeforeSiteBuild;
    afterSiteBuild = extensionAfterSiteBuild;
    notificationUses = [
      "google-chat"
      "slack"
      "telegram"
    ];
    notificationTelegramChatId = "-100123";
  };
  azureSwaCliFull = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    target = "azure-static-web-app";
    deployTool = "swa-cli";
    beforeSiteBuild = extensionBeforeSiteBuild;
    afterSiteBuild = extensionAfterSiteBuild;
    notificationUses = [
      "google-chat"
      "slack"
      "telegram"
    ];
    notificationTelegramChatId = "-100123";
  };
  githubPagesSwaCli = evalModule {
    enable = true;
    target = "github-pages";
    deployTool = "swa-cli";
  };
  azurePagesSwaCli = evalModule {
    enable = true;
    ciProvider = "azure-pipelines";
    target = "github-pages";
    deployTool = "swa-cli";
  };
  invalidDeployTool = evalModule {
    enable = true;
    target = "azure-static-web-app";
    deployTool = "not-a-tool";
  };
  invalidTarget = evalModule {
    enable = true;
    target = "not-a-target";
  };
  invalidTokenSecret = evalModule {
    enable = true;
    target = "azure-static-web-app";
    apiTokenSecret = "invalid-secret";
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
      featureOrder = [ ];
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
      featureOrder = [ ];
    };
  selectedFeatureOrderJson =
    (builtins.fromJSON selectedFeatureOrder.files."${site}/site.json".text).featureOrder == [
      "feat-second"
      "feat-first"
    ];
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
  configComparatorMatches =
    let
      text = textOf "${site}/docusaurus.config.js";
    in
    builtins.all (pattern: matches pattern text) [
      "site[.]featureOrder [?][?] [[]]"
      "FEATURE_ORDER"
      "'requirements', 'specifications', 'decisions', 'tasks'"
      "change-initial"
      "'index' [|][|] name === 'readme'"
      "major"
      "minor"
      "patch"
      "codePointAt"
    ];
  configHasNoLocaleCompare = !matches "localeCompare" (textOf "${site}/docusaurus.config.js");
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
  featureOrderOptionsMatch =
    let
      options = (moduleFor { }).options.factory.composition.artifact-driven.docs-site;
    in
    options.sidebar.feature-order.default == [ ]
    &&
      options.sidebar.feature-order.testType == {
        kind = "list";
        element = "str";
      };
  featureOrderAssertionsRejected =
    !assertionsPass emptyFeatureName && !assertionsPass duplicateFeatureName;
  featureOrderAssertionMessages =
    builtins.elem "factory.composition.artifact-driven.docs-site.sidebar.feature-order must not contain an empty string" (
      failedMessages emptyFeatureName
    )
    && builtins.elem "factory.composition.artifact-driven.docs-site.sidebar.feature-order must not contain a duplicate name" (
      failedMessages duplicateFeatureName
    );
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
  extensionWatchPathIndentation =
    let
      text = extensions.files.".github/workflows/docs-site.yml".text;
    in
    matches "\n      - \"services/manual/docs/[*][*]\"\n" text
    && !matches "\n            - \"services/manual/docs/[*][*]\"\n" text;
  optionalCommandFieldsOmitted =
    let
      text = extensions.files.".github/workflows/docs-site.yml".text;
    in
    !matches "uses: null" text && !matches "run: null" text && !matches "working-directory: null" text;
  githubWorkflowFile = ".github/workflows/docs-site.yml";
  azurePipelineFile = "azure-pipelines/docs-site.yml";
  perProviderEmission =
    builtins.hasAttr githubWorkflowFile on.files
    && !(builtins.hasAttr azurePipelineFile on.files)
    && builtins.hasAttr githubWorkflowFile extensions.files
    && !(builtins.hasAttr azurePipelineFile extensions.files)
    && builtins.hasAttr azurePipelineFile azure.files
    && !(builtins.hasAttr githubWorkflowFile azure.files)
    && builtins.hasAttr azurePipelineFile azureExtensions.files
    && !(builtins.hasAttr githubWorkflowFile azureExtensions.files)
    && azure.files.${azurePipelineFile} ? text
    && !(azure.files.${azurePipelineFile} ? source);
  azureCustomFolderFile = "ci/azure/docs-site.yml";
  azureDefaultFolderEmitted = builtins.hasAttr azurePipelineFile azure.files;
  azureDefaultTriggerHasDefaultPath =
    matches "trigger:.*azure-pipelines/docs-site[.]yml.*pr: none"
      azure.files.${azurePipelineFile}.text;
  azureCustomFolderEmitted = builtins.hasAttr azureCustomFolderFile azureCustomFolder.files;
  azureCustomTriggerHasCustomPath =
    matches "trigger:.*ci/azure/docs-site[.]yml.*pr: none"
      azureCustomFolder.files.${azureCustomFolderFile}.text;
  azureCustomFolderOmitsDefaultFile = !(builtins.hasAttr azurePipelineFile azureCustomFolder.files);
  azureCustomFolderHasNoStaleDefaultTrigger =
    !matches "azure-pipelines/docs-site[.]yml" azureCustomFolder.files.${azureCustomFolderFile}.text;
  azureFolderNormalizedBytes =
    builtins.replaceStrings [ "azure-pipelines/docs-site.yml" ] [ "FOLDER/docs-site.yml" ]
      azure.files.${azurePipelineFile}.text
    == builtins.replaceStrings [ "ci/azure/docs-site.yml" ] [ "FOLDER/docs-site.yml" ]
      azureCustomFolder.files.${azureCustomFolderFile}.text;
  githubCustomFolderUnchanged =
    githubCustomFolder.files.${githubWorkflowFile}.text == on.files.${githubWorkflowFile}.text
    && githubCustomFolder.files."${site}/site.json".text == on.files."${site}/site.json".text
    && !(builtins.hasAttr azurePipelineFile githubCustomFolder.files)
    && !(builtins.hasAttr azureCustomFolderFile githubCustomFolder.files);
  githubEmitsNoAzureFile =
    !(builtins.hasAttr azurePipelineFile on.files)
    && !(builtins.hasAttr azurePipelineFile githubCustomFolder.files)
    && !(builtins.hasAttr azureCustomFolderFile on.files)
    && !(builtins.hasAttr azureCustomFolderFile githubCustomFolder.files);
  azureTriggerOrder =
    let
      text = azureExtensions.files.${azurePipelineFile}.text;
    in
    builtins.all (pattern: matches pattern text) [
      "trigger:.*branches:.*include:.*- main"
      "docs/[*][*].*apps/documentation/[*][*].*azure-pipelines/docs-site[.]yml.*services/manual/docs/[*][*]"
      "pr: none"
    ];
  azureStepOrder =
    let
      text = azureExtensions.files.${azurePipelineFile}.text;
    in
    builtins.all (pattern: matches pattern text) [
      "checkout: self.*Build the manual PDF.*NodeTool@0"
      "NodeTool@0.*versionSpec.*22.*npm ci.*Copy the manual PDF"
      "Copy the manual PDF.*npm run build.*Check the first output.*Check the second output.*Publish to GitHub Pages"
    ];
  azureExtensionValues =
    let
      text = azureExtensions.files.${azurePipelineFile}.text;
    in
    builtins.all (pattern: matches pattern text) [
      "xu-cheng/latex-action@v4"
      "root_file.*manual[.]tex"
      "working_directory.*services/manual/docs"
      "latexmk_use_xelatex: true"
      "RETRY_COUNT: 3"
      "SCALE: 1[.]5"
      "TEXINPUTS"
      "mkdir -p static/manual"
      "PDF_SOURCE"
      "workingDirectory.*apps/documentation"
    ];
  azureSharedBytes =
    azure.files."${site}/site.json".text == on.files."${site}/site.json".text
    && azureExtensions.files."${site}/site.json".text == extensions.files."${site}/site.json".text
    &&
      azureMultiProvider.files.${notificationFile}.source
      == multiProvider.files.${notificationFile}.source
    && azureMultiProvider.files.${notificationFile}.copyMode == "copy";
  azureEmptyExtensions =
    let
      text = azure.files.${azurePipelineFile}.text;
    in
    !matches "Build the manual PDF" text
    && !matches "services/manual/docs" text
    && matches "npm ci" text
    && matches "DOCS_SITE_GITHUB_TOKEN: [$][(]DOCS_SITE_GITHUB_TOKEN[)]" text;
  azureNotificationsMatch =
    let
      text = azureMultiProvider.files.${azurePipelineFile}.text;
    in
    builtins.all (pattern: matches pattern text) [
      "[.]github/docs-site/notify[.]py"
      "DOCS_SITE_NOTIFICATION_USES:.*google-chat.*slack.*telegram"
      "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK: [$][(]DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK[)]"
      "DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK: [$][(]DOCS_SITE_NOTIFICATION_SLACK_WEBHOOK[)]"
      "DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN: [$][(]DOCS_SITE_NOTIFICATION_TELEGRAM_TOKEN[)]"
      "DOCS_SITE_NOTIFICATION_TELEGRAM_CHAT_ID: \"-100123\""
      "DOCS_SITE_DEPLOYMENT_URL"
      "DOCS_SITE_REPOSITORY: [$][(]Build[.]Repository[.]Name[)]"
      "DOCS_SITE_REF_NAME: [$][(]Build[.]SourceBranchName[)]"
      "DOCS_SITE_COMMIT_SHA: [$][(]Build[.]SourceVersion[)]"
      "DOCS_SITE_RUN_URL"
    ];
  azureAssertionsPass =
    assertionsPass azure && assertionsPass azureMultiProvider && assertionsPass azureExtensions;
  azureInvalidRejected = builtins.all (cfg: !assertionsPass cfg) [
    badCiProvider
    azureEmptyPath
    azureStepWithUsesAndRun
  ];
  failedMessages =
    cfg: map (a: a.message) (builtins.filter (a: !a.assertion) (cfg.assertions or [ ]));
  targetOptionsMatch =
    let
      options = (moduleFor { }).options.factory.composition.artifact-driven.docs-site;
    in
    options.target.default == "github-pages"
    && options.azure-static-web-app.api-token-secret.default == "DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN";
  githubDefaultHasNoSwa =
    let
      text = on.files.".github/workflows/docs-site.yml".text;
    in
    !matches "static-web-apps-deploy" text && !matches "AzureStaticWebApp" text;
  azureDefaultHasNoSwa =
    let
      text = azure.files.${azurePipelineFile}.text;
    in
    !matches "static-web-apps-deploy" text && !matches "AzureStaticWebApp" text;
  githubAzureMatches =
    let
      text = githubAzure.files.".github/workflows/docs-site.yml".text;
    in
    builtins.all (pattern: matches pattern text) [
      "Azure/static-web-apps-deploy@v1"
      "app_location: apps/documentation/build"
      "output_location: build"
      "skip_app_build: true"
      "secrets[.]DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"
      "npm run build.*Deploy to Azure Static Web Apps"
    ];
  githubAzureCustomSecretMatches =
    matches "secrets[.]CUSTOM_SWA_TOKEN"
      githubAzureCustomSecret.files.".github/workflows/docs-site.yml".text;
  githubAzureExcludesPages =
    let
      text = githubAzure.files.".github/workflows/docs-site.yml".text;
    in
    !matches "upload-pages-artifact" text
    && !matches "deploy-pages" text
    && !matches "pages: write" text
    && !matches "github-pages" text;
  githubAzureExtensionsMatch =
    let
      text = githubAzureExtensions.files.".github/workflows/docs-site.yml".text;
    in
    builtins.all (pattern: matches pattern text) [
      "actions/checkout@v4.*Build the manual PDF.*xu-cheng/latex-action@v4.*actions/setup-node@v4"
      "npm ci.*Copy the manual PDF.*npm run build"
      "npm run build.*Check the first output.*Check the second output.*Deploy to Azure Static Web Apps"
      "Azure/static-web-apps-deploy@v1"
    ];
  githubAzureSiteJsonIdentical =
    githubAzure.files."${site}/site.json".text == on.files."${site}/site.json".text
    &&
      githubAzureExtensions.files."${site}/site.json".text == extensions.files."${site}/site.json".text;
  githubAzureNotificationsMatch =
    let
      text = githubAzureMulti.files.".github/workflows/docs-site.yml".text;
    in
    builtins.all (pattern: matches pattern text) [
      "[.]github/docs-site/notify[.]py"
      "DOCS_SITE_NOTIFICATION_USES:.*google-chat.*slack.*telegram"
      "DOCS_SITE_DEPLOYMENT_URL: \"https://example[.]github[.]io/repo/\""
    ]
    && !matches "steps[.]deployment[.]outputs[.]page_url" text
    &&
      githubAzureMulti.files.${notificationFile}.source == multiProvider.files.${notificationFile}.source;
  azureSwaMatches =
    let
      text = azureSwa.files.${azurePipelineFile}.text;
    in
    builtins.all (pattern: matches pattern text) [
      "AzureStaticWebApp@0"
      "app_location: apps/documentation/build"
      "output_location: build"
      "skip_app_build: true"
      "azure_static_web_apps_api_token: [$][(]DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN[)]"
      "npm run build.*Deploy to Azure Static Web Apps"
    ];
  azureSwaCustomSecretMatches =
    matches "[$][(]CUSTOM_SWA_TOKEN[)]"
      azureSwaCustomSecret.files.${azurePipelineFile}.text;
  azureSwaExcludesGhPages =
    let
      text = azureSwa.files.${azurePipelineFile}.text;
    in
    !matches "gh-pages" text && !matches "DOCS_SITE_GITHUB_TOKEN" text;
  azureSwaExtensionsMatch =
    let
      text = azureSwaExtensions.files.${azurePipelineFile}.text;
    in
    builtins.all (pattern: matches pattern text) [
      "checkout: self.*Build the manual PDF.*NodeTool@0"
      "Copy the manual PDF.*npm run build.*Check the first output.*Check the second output.*Deploy to Azure Static Web Apps"
      "AzureStaticWebApp@0"
    ];
  azureSwaSiteJsonIdentical =
    azureSwa.files."${site}/site.json".text == azure.files."${site}/site.json".text
    &&
      azureSwaExtensions.files."${site}/site.json".text == azureExtensions.files."${site}/site.json".text;
  azureSwaNotificationsMatch =
    let
      text = azureSwaMulti.files.${azurePipelineFile}.text;
    in
    builtins.all (pattern: matches pattern text) [
      "[.]github/docs-site/notify[.]py"
      "DOCS_SITE_NOTIFICATION_USES:.*google-chat.*slack.*telegram"
      "DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK: [$][(]DOCS_SITE_NOTIFICATION_GOOGLE_CHAT_WEBHOOK[)]"
      "DOCS_SITE_DEPLOYMENT_URL: 'https://example[.]github[.]io/repo/'"
    ]
    &&
      azureSwaMulti.files.${notificationFile}.source
      == azureMultiProvider.files.${notificationFile}.source;
  targetAssertionsPass =
    assertionsPass githubAzure
    && assertionsPass azureSwa
    && assertionsPass githubAzureMulti
    && assertionsPass azureSwaMulti
    && assertionsPass githubAzureExtensions
    && assertionsPass azureSwaExtensions;
  invalidTargetRejected =
    !assertionsPass invalidTarget
    && builtins.all (
      message:
      builtins.match ".*github-pages.*" message != null
      && builtins.match ".*azure-static-web-app.*" message != null
    ) (failedMessages invalidTarget);
  invalidTokenSecretRejected = !assertionsPass invalidTokenSecret;
  deployToolOptionsMatch =
    let
      options = (moduleFor { }).options.factory.composition.artifact-driven.docs-site;
    in
    options.azure-static-web-app.deploy-tool.testType == "enum"
    &&
      options.azure-static-web-app.deploy-tool.values == [
        "official-task"
        "swa-cli"
      ]
    && options.azure-static-web-app.deploy-tool.default == "official-task"
    &&
      builtins.attrNames options.azure-static-web-app == [
        "api-token-secret"
        "deploy-tool"
      ];
  githubDeployShapeMatches =
    let
      officialText = githubAzureOfficial.files.".github/workflows/docs-site.yml".text;
      cliText = githubSwaCli.files.".github/workflows/docs-site.yml".text;
    in
    matches "Azure/static-web-apps-deploy@v1" officialText
    && !matches "static-web-apps-cli" officialText
    && !matches "swa deploy" officialText
    && matches "@azure/static-web-apps-cli@2[.]0[.]10" cliText
    && matches "swa deploy [.]/build" cliText
    && !matches "Azure/static-web-apps-deploy@v1" cliText
    && !matches "AzureStaticWebApp" cliText;
  azureDeployShapeMatches =
    let
      officialText = azureSwaOfficial.files.${azurePipelineFile}.text;
      cliText = azureSwaCli.files.${azurePipelineFile}.text;
    in
    matches "AzureStaticWebApp@0" officialText
    && !matches "@azure/static-web-apps-cli" officialText
    && !matches "swa deploy" officialText
    && matches "@azure/static-web-apps-cli@2[.]0[.]10" cliText
    && matches "swa deploy [.]/build" cliText
    && !matches "AzureStaticWebApp@0" cliText
    && !matches "Azure/static-web-apps-deploy" cliText;
  defaultDeployShapeMatches =
    let
      githubText = githubAzure.files.".github/workflows/docs-site.yml".text;
      azureText = azureSwa.files.${azurePipelineFile}.text;
    in
    matches "Azure/static-web-apps-deploy@v1" githubText
    && matches "AzureStaticWebApp@0" azureText
    && !matches "static-web-apps-cli" githubText
    && !matches "static-web-apps-cli" azureText;
  swaCliPinMatches =
    let
      githubText = githubSwaCli.files.".github/workflows/docs-site.yml".text;
      azureText = azureSwaCli.files.${azurePipelineFile}.text;
      install = "npm install --global @azure/static-web-apps-cli@2[.]0[.]10";
      deploy = "swa deploy [.]/build --deployment-token.*SWA_CLI_DEPLOYMENT_TOKEN.*--env production";
    in
    matches install githubText
    && matches install azureText
    && matches deploy githubText
    && matches deploy azureText;
  deployToolTokenParity =
    let
      githubText = githubSwaCli.files.".github/workflows/docs-site.yml".text;
      azureText = azureSwaCli.files.${azurePipelineFile}.text;
    in
    matches "SWA_CLI_DEPLOYMENT_TOKEN: .*secrets[.]DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN" githubText
    && matches "SWA_CLI_DEPLOYMENT_TOKEN: .*[$][(]DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN[)]" azureText;
  githubNpmCacheMatches =
    let
      text = githubSwaCli.files.".github/workflows/docs-site.yml".text;
    in
    matches "cache: npm" text
    && matches "cache-dependency-path: apps/documentation/package-lock.json" text;
  azureNpmCacheMatches =
    let
      text = azureSwaCli.files.${azurePipelineFile}.text;
    in
    builtins.all (pattern: matches pattern text) [
      "variables:.*npm_config_cache: [$][(]Pipeline[.]Workspace[)]/[.]npm"
      "Cache@2.*displayName: Cache npm.*key:.*\"npm\" [|] \"[$][(]Agent[.]OS[)]\" [|] \"swa-cli-2[.]0[.]10\" [|] apps/documentation/package-lock[.]json"
      "restoreKeys: [|].*\"npm\" [|] \"[$][(]Agent[.]OS[)]\" [|] \"swa-cli-2[.]0[.]10\".*\"npm\" [|] \"[$][(]Agent[.]OS[)]\""
      "path: [$][(]npm_config_cache[)]"
      "NodeTool@0.*Cache@2.*npm ci"
    ];
  githubSwaCliOrderMatches =
    let
      text = githubSwaCliFull.files.".github/workflows/docs-site.yml".text;
    in
    matches "npm run build.*Check the first output.*Check the second output.*Install the Static Web Apps CLI.*Deploy to Azure Static Web Apps.*Check out the notification code.*Notify the team about the deployment" text;
  azureSwaCliOrderMatches =
    let
      text = azureSwaCliFull.files.${azurePipelineFile}.text;
    in
    matches "npm run build.*Check the first output.*Check the second output.*Install the Static Web Apps CLI.*Deploy to Azure Static Web Apps.*Notify the team about the deployment" text;
  notificationParityMatches =
    let
      githubOfficial =
        builtins.match ".*(Check out the notification code.*)"
          githubAzureMulti.files.".github/workflows/docs-site.yml".text;
      githubCli =
        builtins.match ".*(Check out the notification code.*)"
          githubSwaCliFull.files.".github/workflows/docs-site.yml".text;
      azureOfficial =
        builtins.match ".*(Notify the team about the deployment.*)"
          azureSwaMulti.files.${azurePipelineFile}.text;
      azureCli =
        builtins.match ".*(Notify the team about the deployment.*)"
          azureSwaCliFull.files.${azurePipelineFile}.text;
    in
    githubOfficial == githubCli && azureOfficial == azureCli;
  pagesExcludeSwaCli =
    let
      noSwa =
        text:
        !matches "static-web-apps-deploy" text
        && !matches "static-web-apps-cli" text
        && !matches "AzureStaticWebApp" text
        && !matches "swa deploy" text
        && !matches "SWA_CLI_DEPLOYMENT_TOKEN" text
        && !matches "npm_config_cache" text;
      githubText = githubPagesSwaCli.files.".github/workflows/docs-site.yml".text;
      azureText = azurePagesSwaCli.files.${azurePipelineFile}.text;
    in
    noSwa githubText
    && noSwa azureText
    && matches "actions/upload-pages-artifact@v3" githubText
    && matches "gh-pages" azureText;
  deployToolAssertionsPass =
    assertionsPass githubAzureOfficial
    && assertionsPass azureSwaOfficial
    && assertionsPass githubSwaCli
    && assertionsPass azureSwaCli;
  invalidDeployToolRejected = !assertionsPass invalidDeployTool;
  invalidDeployToolMessage = builtins.elem "factory.composition.artifact-driven.docs-site.azure-static-web-app.deploy-tool must be \"official-task\" or \"swa-cli\"" (
    failedMessages invalidDeployTool
  );
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
      "Azure Pipelines"
      "azure-pipelines/docs-site[.]yml"
      "DOCS_SITE_GITHUB_TOKEN"
      "azure-static-web-app"
      "DOCS_SITE_AZURE_STATIC_WEB_APP_TOKEN"
      "Create one Static Web App resource"
      "Copy the deployment token"
      "Mark the Azure variable as secret"
      "cannot create the resource and cannot read the token"
      "azure-static-web-app[.]deploy-tool"
      "official-task"
      "swa-cli"
      "@azure/static-web-apps-cli@2[.]0[.]10"
      "swa deploy [.]/build"
      "--env production"
      "npm_config_cache"
      "Cache@2"
      "swa-cli-2[.]0[.]10"
      "cannot set or change the CLI version"
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
assert selectedFeatureOrderJson;
assert packageJsonPinned;
assert lockfilePinned;
assert configMatches;
assert configComparatorMatches;
assert configHasNoLocaleCompare;
assert featureOrderOptionsMatch;
assert featureOrderAssertionsRejected;
assert featureOrderAssertionMessages;
assert workflowMatches;
assert defaultWorkflowUnchanged;
assert extensionOptionsMatch;
assert extensionWorkflowMatches;
assert extensionWatchPathIndentation;
assert optionalCommandFieldsOmitted;
assert perProviderEmission;
assert azureDefaultFolderEmitted;
assert azureDefaultTriggerHasDefaultPath;
assert azureCustomFolderEmitted;
assert azureCustomTriggerHasCustomPath;
assert azureCustomFolderOmitsDefaultFile;
assert azureCustomFolderHasNoStaleDefaultTrigger;
assert azureFolderNormalizedBytes;
assert githubCustomFolderUnchanged;
assert githubEmitsNoAzureFile;
assert azureTriggerOrder;
assert azureStepOrder;
assert azureExtensionValues;
assert azureSharedBytes;
assert azureEmptyExtensions;
assert azureNotificationsMatch;
assert azureAssertionsPass;
assert azureInvalidRejected;
assert targetOptionsMatch;
assert githubDefaultHasNoSwa;
assert azureDefaultHasNoSwa;
assert githubAzureMatches;
assert githubAzureCustomSecretMatches;
assert githubAzureExcludesPages;
assert githubAzureExtensionsMatch;
assert githubAzureSiteJsonIdentical;
assert githubAzureNotificationsMatch;
assert azureSwaMatches;
assert azureSwaCustomSecretMatches;
assert azureSwaExcludesGhPages;
assert azureSwaExtensionsMatch;
assert azureSwaSiteJsonIdentical;
assert azureSwaNotificationsMatch;
assert targetAssertionsPass;
assert invalidTargetRejected;
assert invalidTokenSecretRejected;
assert deployToolOptionsMatch;
assert githubDeployShapeMatches;
assert azureDeployShapeMatches;
assert defaultDeployShapeMatches;
assert swaCliPinMatches;
assert deployToolTokenParity;
assert githubNpmCacheMatches;
assert azureNpmCacheMatches;
assert githubSwaCliOrderMatches;
assert azureSwaCliOrderMatches;
assert notificationParityMatches;
assert pagesExcludeSwaCli;
assert deployToolAssertionsPass;
assert invalidDeployToolRejected;
assert invalidDeployToolMessage;
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
    selectedFeatureOrderJson
    packageJsonPinned
    lockfilePinned
    configMatches
    configComparatorMatches
    configHasNoLocaleCompare
    featureOrderOptionsMatch
    featureOrderAssertionsRejected
    featureOrderAssertionMessages
    workflowMatches
    defaultWorkflowUnchanged
    extensionOptionsMatch
    extensionWorkflowMatches
    extensionWatchPathIndentation
    optionalCommandFieldsOmitted
    perProviderEmission
    azureDefaultFolderEmitted
    azureDefaultTriggerHasDefaultPath
    azureCustomFolderEmitted
    azureCustomTriggerHasCustomPath
    azureCustomFolderOmitsDefaultFile
    azureCustomFolderHasNoStaleDefaultTrigger
    azureFolderNormalizedBytes
    githubCustomFolderUnchanged
    githubEmitsNoAzureFile
    azureTriggerOrder
    azureStepOrder
    azureExtensionValues
    azureSharedBytes
    azureEmptyExtensions
    azureNotificationsMatch
    azureAssertionsPass
    azureInvalidRejected
    targetOptionsMatch
    githubDefaultHasNoSwa
    azureDefaultHasNoSwa
    githubAzureMatches
    githubAzureCustomSecretMatches
    githubAzureExcludesPages
    githubAzureExtensionsMatch
    githubAzureSiteJsonIdentical
    githubAzureNotificationsMatch
    azureSwaMatches
    azureSwaCustomSecretMatches
    azureSwaExcludesGhPages
    azureSwaExtensionsMatch
    azureSwaSiteJsonIdentical
    azureSwaNotificationsMatch
    targetAssertionsPass
    invalidTargetRejected
    invalidTokenSecretRejected
    deployToolOptionsMatch
    githubDeployShapeMatches
    azureDeployShapeMatches
    defaultDeployShapeMatches
    swaCliPinMatches
    deployToolTokenParity
    githubNpmCacheMatches
    azureNpmCacheMatches
    githubSwaCliOrderMatches
    azureSwaCliOrderMatches
    notificationParityMatches
    pagesExcludeSwaCli
    deployToolAssertionsPass
    invalidDeployToolRejected
    invalidDeployToolMessage
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
