let
  optionUtils = {
    mkBoolOpt = inputs: inputs;
    mkStrOpt = inputs: inputs;
    mkIntOpt = inputs: inputs;
    mkEnumOpt = inputs: inputs;
    mkListOpt = inputs: inputs;
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
    optional = condition: value: if condition then [ value ] else [ ];
    optionalAttrs = condition: attrs: if condition then attrs else { };
    concatStringsSep = builtins.concatStringsSep;
    concatMapStringsSep =
      separator: f: values:
      builtins.concatStringsSep separator (map f values);
    mapAttrsToList = f: attrs: map (name: f name attrs.${name}) (builtins.attrNames attrs);
    unique =
      list:
      builtins.foldl' (
        items: item: if builtins.elem item items then items else items ++ [ item ]
      ) [ ] list;
    foldl' = builtins.foldl';
    nameValuePair = name: value: { inherit name value; };
    mapAttrs' = f: set: builtins.listToAttrs (map (name: f name set.${name}) (builtins.attrNames set));
    filterAttrs =
      predicate: set:
      builtins.listToAttrs (
        builtins.concatMap (
          name:
          if predicate name set.${name} then
            [
              {
                inherit name;
                value = set.${name};
              }
            ]
          else
            [ ]
        ) (builtins.attrNames set)
      );
  };

  defaultStatuses = {
    feature-summary = "Accepted";
    master-requirement = "Accepted";
    requirement = "Accepted";
    master-specification = "Accepted";
    specification = "Accepted";
    decision = "Accepted";
    implementation-plan = "Accepted";
    task = "Ready";
    change-summary = "Accepted";
    withdrawn = "Withdrawn";
  };

  moduleFor =
    {
      architecture ? "multiple",
      method ? "ddd",
      documentation ? "artifact-driven",
      ciProvider ? "unset",
      projectProvider ? "unset",
      enable ? false,
      statuses ? defaultStatuses,
      githubOwner ? "example",
      githubProjectNumber ? 7,
      githubSecret ? "PROJECTS_TOKEN",
      trelloBoard ? "board",
      trelloImplementationBoard ? "",
      trelloApiKeySecret ? "TRELLO_API_KEY",
      trelloTokenSecret ? "TRELLO_TOKEN",
      notificationUses ? [ ],
      notificationGoogleChatSecret ? "ARTIFACT_NOTIFICATION_GOOGLE_CHAT_WEBHOOK",
      notificationSlackSecret ? "ARTIFACT_NOTIFICATION_SLACK_WEBHOOK",
      notificationTelegramTokenSecret ? "ARTIFACT_NOTIFICATION_TELEGRAM_TOKEN",
      notificationTelegramChatId ? "",
    }:
    import ../default.nix {
      inherit lib;
      config.factory = {
        _utils = optionUtils;
        domain = {
          documentation.use = documentation;
          repo-arch.use = architecture;
          design.use = method;
          ci-cd.provider.use = ciProvider;
          project-management.provider = {
            use = projectProvider;
            github-projects = {
              ownership = "personal";
              owner = githubOwner;
              project-number = githubProjectNumber;
              token-secret = githubSecret;
            };
            trello = {
              board-id = trelloBoard;
              implementation-board-id = trelloImplementationBoard;
              api-key-secret = trelloApiKeySecret;
              token-secret = trelloTokenSecret;
            };
          };
        };
        composition.artifact-driven.project-issues = {
          inherit enable;
          artifact-status = statuses;
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

  configs = {
    multipleOn = evalModule { };
    multipleOff = evalModule { method = "unset"; };
    singleOn = evalModule { architecture = "single"; };
    singleOff = evalModule {
      architecture = "single";
      method = "unset";
    };
  };
  noArchOn = evalModule { architecture = "unset"; };
  documentationOff = evalModule { documentation = "unset"; };
  githubOn = evalModule {
    ciProvider = "github-actions";
    projectProvider = "github-projects";
    enable = true;
  };
  trelloOn = evalModule {
    ciProvider = "github-actions";
    projectProvider = "trello";
    enable = true;
  };
  trelloSplit = evalModule {
    ciProvider = "github-actions";
    projectProvider = "trello";
    enable = true;
    trelloImplementationBoard = "implementation-board";
  };
  googleChatOn = evalModule {
    ciProvider = "github-actions";
    projectProvider = "github-projects";
    enable = true;
    notificationUses = [ "google-chat" ];
  };
  slackOn = evalModule {
    ciProvider = "github-actions";
    projectProvider = "trello";
    enable = true;
    notificationUses = [ "slack" ];
    notificationSlackSecret = "TEAM_SLACK_WEBHOOK";
  };
  multiProviderOn = evalModule {
    ciProvider = "github-actions";
    projectProvider = "github-projects";
    enable = true;
    notificationUses = [
      "google-chat"
      "slack"
      "telegram"
    ];
    notificationTelegramChatId = "-100123";
  };
  adapterOnly = evalModule {
    projectProvider = "github-projects";
    githubOwner = "";
    githubProjectNumber = 0;
  };
  azureGithubOn = evalModule {
    ciProvider = "azure-pipelines";
    projectProvider = "github-projects";
    enable = true;
  };
  azureTrelloOn = evalModule {
    ciProvider = "azure-pipelines";
    projectProvider = "trello";
    enable = true;
  };
  azureTrelloSplit = evalModule {
    ciProvider = "azure-pipelines";
    projectProvider = "trello";
    enable = true;
    trelloImplementationBoard = "implementation-board";
  };
  azureMultiProviderOn = evalModule {
    ciProvider = "azure-pipelines";
    projectProvider = "github-projects";
    enable = true;
    notificationUses = [
      "google-chat"
      "slack"
      "telegram"
    ];
    notificationTelegramChatId = "-100123";
  };
  azureTrelloNotifyOn = evalModule {
    ciProvider = "azure-pipelines";
    projectProvider = "trello";
    enable = true;
    notificationUses = [ "slack" ];
    notificationSlackSecret = "TEAM_SLACK_WEBHOOK";
  };
  azureDisabled = evalModule {
    ciProvider = "azure-pipelines";
    projectProvider = "github-projects";
    githubOwner = "";
    githubProjectNumber = 0;
  };

  invalidSetups = [
    (evalModule {
      documentation = "unset";
      ciProvider = "github-actions";
      projectProvider = "github-projects";
      enable = true;
    })
    (evalModule {
      ciProvider = "unset";
      projectProvider = "github-projects";
      enable = true;
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "unset";
      enable = true;
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "github-projects";
      enable = true;
      githubOwner = "";
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "github-projects";
      enable = true;
      githubProjectNumber = 0;
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "github-projects";
      enable = true;
      githubSecret = "invalid-secret";
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "trello";
      enable = true;
      trelloBoard = "";
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "trello";
      enable = true;
      trelloApiKeySecret = "invalid-secret";
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "trello";
      enable = true;
      trelloTokenSecret = "invalid-secret";
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "trello";
      enable = true;
      trelloImplementationBoard = "board";
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "github-projects";
      enable = true;
      statuses = defaultStatuses // {
        task = "";
      };
    })
    (evalModule {
      ciProvider = "github-actions";
      projectProvider = "github-projects";
      enable = true;
      notificationUses = [ "slack" ];
      notificationSlackSecret = "invalid-secret";
    })
    (evalModule {
      ciProvider = "jenkins";
      projectProvider = "github-projects";
      enable = true;
    })
    (evalModule {
      ciProvider = "azure-pipelines";
      projectProvider = "github-projects";
      enable = true;
      githubSecret = "invalid-secret";
    })
    (evalModule {
      ciProvider = "azure-pipelines";
      projectProvider = "trello";
      enable = true;
      trelloTokenSecret = "invalid-secret";
    })
    (evalModule {
      ciProvider = "azure-pipelines";
      projectProvider = "github-projects";
      enable = true;
      notificationUses = [ "telegram" ];
    })
  ];

  roles = [
    "requirement-expert"
    "solution-expert"
    "artifact-master"
  ];
  expertRoles = [
    "requirement-expert"
    "solution-expert"
  ];
  base = role: builtins.readFile (../_assets/agent/role + "/${role}/ROLE.md");
  chapter = arch: role: builtins.readFile (../_assets + "/${arch}/ddd/agent/role/${role}/ROLE.md");
  instruction = cfg: role: cfg.factory.domain.agent.role.builder.${role}.instruction;

  guidance = [
    "AGENTS.md"
    "docs/README.md"
    "docs/wiki/README.md"
  ];
  page = "docs/wiki/design/ddd/artifact-driven.md";
  sourceOf = cfg: name: cfg.files.${name}.source;

  expected = {
    multipleOn = {
      "AGENTS.md" = ../_assets/multiple/ddd/AGENTS.md;
      "docs/README.md" = ../_assets/ddd/docs/README.md;
      "docs/wiki/README.md" = ../_assets/multiple/ddd/docs/wiki/README.md;
    };
    multipleOff = {
      "AGENTS.md" = ../_assets/multiple/AGENTS.md;
      "docs/README.md" = ../_assets/docs/README.md;
      "docs/wiki/README.md" = ../_assets/multiple/docs/wiki/README.md;
    };
    singleOn = {
      "AGENTS.md" = ../_assets/single/ddd/AGENTS.md;
      "docs/README.md" = ../_assets/ddd/docs/README.md;
      "docs/wiki/README.md" = ../_assets/single/ddd/docs/wiki/README.md;
    };
    singleOff = {
      "AGENTS.md" = ../_assets/single/AGENTS.md;
      "docs/README.md" = ../_assets/docs/README.md;
      "docs/wiki/README.md" = ../_assets/single/docs/wiki/README.md;
    };
  };
  keys = builtins.attrNames configs;

  sourcesMatch = builtins.all (
    key: builtins.all (name: sourceOf configs.${key} name == expected.${key}.${name}) guidance
  ) keys;
  sourcesExist = builtins.all (
    key: builtins.all (name: builtins.pathExists (sourceOf configs.${key} name)) guidance
  ) keys;

  chapterAppended =
    builtins.all
      (
        arch:
        builtins.all (
          role: instruction configs."${arch}On" role == base role + "\n" + chapter arch role
        ) roles
      )
      [
        "multiple"
        "single"
      ];
  chapterOmitted = builtins.all (cfg: builtins.all (role: instruction cfg role == base role) roles) [
    configs.multipleOff
    configs.singleOff
    noArchOn
  ];
  chapterHasHeading =
    builtins.all
      (
        arch:
        builtins.all (role: builtins.match "## Domain-Driven Design\n.*" (chapter arch role) != null) roles
      )
      [
        "multiple"
        "single"
      ];

  pageOn =
    builtins.all
      (
        arch:
        let
          cfg = configs."${arch}On";
        in
        cfg.files.${page}.copyMode == "copy"
        && cfg.files.${page}.source == ../_assets + "/${arch}/ddd/${page}"
        && builtins.pathExists cfg.files.${page}.source
      )
      [
        "multiple"
        "single"
      ];
  pageOff = builtins.all (cfg: !(builtins.hasAttr page cfg.files)) [
    configs.multipleOff
    configs.singleOff
    noArchOn
  ];
  noArchOmitsGuidance = noArchOn.files == { };

  projectIssueFiles = [
    ".github/workflows/accepted-artifact-issues.yml"
    ".github/artifact-issues/sync.py"
    ".github/artifact-issues/config.json"
    "docs/wiki/documentation/artifact-driven/project-issues.md"
    "docs/wiki/documentation/artifact-driven/project-issue-credentials.md"
  ];
  hasProjectIssueFiles = cfg: builtins.all (name: builtins.hasAttr name cfg.files) projectIssueFiles;
  assertionsPass = cfg: builtins.all (assertion: assertion.assertion) (cfg.assertions or [ ]);

  githubProjectIssuesOn = hasProjectIssueFiles githubOn && assertionsPass githubOn;
  trelloProjectIssuesOn = hasProjectIssueFiles trelloOn && assertionsPass trelloOn;
  adapterSelectionPassive = !hasProjectIssueFiles adapterOnly && assertionsPass adapterOnly;
  invalidSetupsRejected = builtins.all (cfg: !assertionsPass cfg) invalidSetups;

  githubConfig = builtins.fromJSON githubOn.files.".github/artifact-issues/config.json".text;
  trelloConfig = builtins.fromJSON trelloOn.files.".github/artifact-issues/config.json".text;
  trelloSplitConfig = builtins.fromJSON trelloSplit.files.".github/artifact-issues/config.json".text;
  providerConfigMatches =
    githubConfig.provider == "github-projects"
    && githubConfig.githubProjects.owner == "example"
    && githubConfig.githubProjects.projectNumber == 7
    && githubConfig.statuses.task == "Ready"
    && trelloConfig.provider == "trello"
    && trelloConfig.trello.boardId == "board"
    && trelloConfig.trello.implementationBoardId == ""
    && trelloSplitConfig.trello.implementationBoardId == "implementation-board"
    && trelloConfig.statuses.withdrawn == "Withdrawn";
  workflowsUseSelectedSecrets =
    builtins.match ".*PROJECT_TOKEN:.*PROJECTS_TOKEN.*"
      githubOn.files.".github/workflows/accepted-artifact-issues.yml".text != null
    &&
      builtins.match ".*TRELLO_API_KEY:.*TRELLO_API_KEY.*"
        trelloOn.files.".github/workflows/accepted-artifact-issues.yml".text != null;
  workflowsCanWritePullRequestComments =
    builtins.all
      (
        cfg:
        builtins.match ".*pull-requests: write.*"
          cfg.files.".github/workflows/accepted-artifact-issues.yml".text != null
      )
      [
        githubOn
        trelloOn
      ];
  notificationFile = ".github/artifact-issues/notify.py";
  notificationFilesMatch =
    !(builtins.hasAttr notificationFile githubOn.files)
    && builtins.hasAttr notificationFile googleChatOn.files
    && googleChatOn.files.${notificationFile}.source == ../_assets/project-issues/notify.py
    && builtins.hasAttr notificationFile slackOn.files;
  googleChatWorkflow = googleChatOn.files.".github/workflows/accepted-artifact-issues.yml".text;
  slackWorkflow = slackOn.files.".github/workflows/accepted-artifact-issues.yml".text;
  multiProviderWorkflow = multiProviderOn.files.".github/workflows/accepted-artifact-issues.yml".text;
  notificationWorkflowsMatch =
    builtins.match ".*ARTIFACT_ISSUES_RESULT:.*runner.temp.*/accepted-artifacts.json.*" googleChatWorkflow
    != null
    && builtins.match ".*ARTIFACT_NOTIFICATION_USES:.*google-chat.*" googleChatWorkflow != null
    &&
      builtins.match ".*ARTIFACT_NOTIFICATION_GOOGLE_CHAT_WEBHOOK:.*ARTIFACT_NOTIFICATION_GOOGLE_CHAT_WEBHOOK.*" googleChatWorkflow
      != null
    && builtins.match ".*ARTIFACT_NOTIFICATION_USES:.*slack.*" slackWorkflow != null
    &&
      builtins.match ".*ARTIFACT_NOTIFICATION_SLACK_WEBHOOK:.*TEAM_SLACK_WEBHOOK.*" slackWorkflow != null
    && builtins.match ".*if: github.event_name == 'pull_request_target'.*" slackWorkflow != null
    &&
      builtins.match ".*ARTIFACT_NOTIFICATION_USES.*"
        githubOn.files.".github/workflows/accepted-artifact-issues.yml".text == null;
  multiProviderWorkflowMatches =
    builtins.match ".*ARTIFACT_NOTIFICATION_USES:.*google-chat.*slack.*telegram.*" multiProviderWorkflow
    != null
    &&
      builtins.match ".*ARTIFACT_NOTIFICATION_GOOGLE_CHAT_WEBHOOK.*ARTIFACT_NOTIFICATION_SLACK_WEBHOOK.*ARTIFACT_NOTIFICATION_TELEGRAM_TOKEN.*ARTIFACT_NOTIFICATION_TELEGRAM_CHAT_ID: \"-100123\".*" multiProviderWorkflow
      != null
    &&
      builtins.match ".*Notify the team about accepted artifacts.*Notify the team about accepted artifacts.*" multiProviderWorkflow
      == null;
  notificationWorkflowIndentation =
    builtins.match ".*\n          ARTIFACT_ISSUES_RESULT:.*\n\n      - name: Notify the team about accepted artifacts\n        if: github.event_name == 'pull_request_target'\n        run: python3.*\n        env:\n          ARTIFACT_ISSUES_RESULT:.*\n          ARTIFACT_NOTIFICATION_USES:.*" slackWorkflow
    != null;
  credentialGuide =
    githubOn.files."docs/wiki/documentation/artifact-driven/project-issue-credentials.md";
  credentialGuideMatches =
    credentialGuide.copyMode == "copy"
    && credentialGuide.source == ../_assets/project-issues/project-issue-credentials.md
    && builtins.pathExists credentialGuide.source
    &&
      builtins.match ".*`repo` and `project` scopes.*" (builtins.readFile credentialGuide.source) != null
    &&
      builtins.match ".*`read` and `write` scopes.*" (builtins.readFile credentialGuide.source) != null;
  notificationGuidesMatch =
    builtins.match ".*notification.uses.*google-chat.*slack.*telegram.*" (
      builtins.readFile githubOn.files."docs/wiki/documentation/artifact-driven/project-issues.md".source
    ) != null
    &&
      builtins.match ".*Google Chat incoming webhook guide.*Slack incoming webhook guide.*" (
        builtins.readFile credentialGuide.source
      ) != null;

  githubWorkflowFile = ".github/workflows/accepted-artifact-issues.yml";
  azurePipelineFile = "azure-pipelines/accepted-artifact-issues.yml";
  azureEmitsOnlyPipeline =
    cfg:
    builtins.hasAttr azurePipelineFile cfg.files && !(builtins.hasAttr githubWorkflowFile cfg.files);
  azureGithubOnOk = azureEmitsOnlyPipeline azureGithubOn && assertionsPass azureGithubOn;
  azureTrelloOnOk = azureEmitsOnlyPipeline azureTrelloOn && assertionsPass azureTrelloOn;
  azureTrelloSplitOk = azureEmitsOnlyPipeline azureTrelloSplit && assertionsPass azureTrelloSplit;
  azureDisabledOk =
    !(builtins.hasAttr azurePipelineFile azureDisabled.files)
    && !(builtins.hasAttr githubWorkflowFile azureDisabled.files)
    && !hasProjectIssueFiles azureDisabled
    && assertionsPass azureDisabled;
  azureSharedIdentical =
    azureGithubOn.files.".github/artifact-issues/sync.py".source
    == githubOn.files.".github/artifact-issues/sync.py".source
    &&
      azureGithubOn.files.".github/artifact-issues/config.json".text
      == githubOn.files.".github/artifact-issues/config.json".text
    &&
      azureTrelloOn.files.".github/artifact-issues/config.json".text
      == trelloOn.files.".github/artifact-issues/config.json".text
    &&
      azureTrelloSplit.files.".github/artifact-issues/config.json".text
      == trelloSplit.files.".github/artifact-issues/config.json".text
    &&
      azureMultiProviderOn.files.${notificationFile}.source
      == multiProviderOn.files.${notificationFile}.source;
  azureGithubSecretsMapped =
    builtins.match ".*PROJECT_TOKEN:.*\\$\\(PROJECTS_TOKEN\\).*"
      azureGithubOn.files.${azurePipelineFile}.text != null
    &&
      builtins.match ".*GITHUB_TOKEN:.*\\$\\(GITHUB_TOKEN\\).*"
        azureGithubOn.files.${azurePipelineFile}.text != null;
  azureTrelloSecretsMapped =
    builtins.match ".*TRELLO_API_KEY:.*\\$\\(TRELLO_API_KEY\\).*"
      azureTrelloOn.files.${azurePipelineFile}.text != null
    &&
      builtins.match ".*TRELLO_TOKEN:.*\\$\\(TRELLO_TOKEN\\).*"
        azureTrelloOn.files.${azurePipelineFile}.text != null
    &&
      builtins.match ".*ARTIFACT_NOTIFICATION_SLACK_WEBHOOK:.*\\$\\(TEAM_SLACK_WEBHOOK\\).*"
        azureTrelloNotifyOn.files.${azurePipelineFile}.text != null;
  azurePipelineTrigger =
    let
      pipeline = azureGithubOn.files.${azurePipelineFile}.text;
    in
    builtins.match ".*trigger:.*" pipeline != null
    && builtins.match ".*pr: none.*" pipeline != null
    && builtins.match ".*checkout: self.*" pipeline != null
    && builtins.match ".*persistCredentials: false.*" pipeline != null;
  azureMultiProviderMatches =
    let
      pipeline = azureMultiProviderOn.files.${azurePipelineFile}.text;
    in
    builtins.match ".*ARTIFACT_NOTIFICATION_USES:.*google-chat.*slack.*telegram.*" pipeline != null
    &&
      builtins.match ".*ARTIFACT_NOTIFICATION_GOOGLE_CHAT_WEBHOOK.*ARTIFACT_NOTIFICATION_SLACK_WEBHOOK.*ARTIFACT_NOTIFICATION_TELEGRAM_TOKEN.*ARTIFACT_NOTIFICATION_TELEGRAM_CHAT_ID: \"-100123\".*" pipeline
      != null
    && builtins.match ".*condition: and.*succeeded.*ArtifactIssuesNotify.*true.*" pipeline != null;
  azureGuidesMatch =
    builtins.match ".*azure-pipelines/accepted-artifact-issues.yml.*" (
      builtins.readFile githubOn.files."docs/wiki/documentation/artifact-driven/project-issues.md".source
    ) != null
    &&
      builtins.match ".*Mark each mapped variable as secret.*" (builtins.readFile credentialGuide.source)
      != null
    &&
      builtins.match ".*one to one onto an Azure secret variable.*" (
        builtins.readFile credentialGuide.source
      ) != null;

  skillPath = ../_assets/agent/skill/by-role/solution-expert/expert-role;
  skillFiles = [
    "SKILL.md"
    "references/role-template.md"
    "references/role-builder.md"
  ];
  skillText = file: builtins.readFile (skillPath + "/${file}");
  forbidden = [
    ".*services/factory.*"
    ".*libs/nix.*"
    ".*nix-instantiate.*"
  ];

  skillShipped = builtins.all (cfg: cfg.factory.domain.agent.skill.general.expert-role == skillPath) [
    configs.multipleOn
    configs.multipleOff
    configs.singleOn
    configs.singleOff
    noArchOn
  ];
  skillFilesExist = builtins.all (file: builtins.pathExists (skillPath + "/${file}")) skillFiles;
  skillOmitted =
    !(builtins.hasAttr "expert-role" (documentationOff.factory.domain.agent.skill.general or { }));
  skillIsGeneric = builtins.all (
    file: builtins.all (pattern: builtins.match pattern (skillText file) == null) forbidden
  ) skillFiles;
  skillFrontmatter = builtins.match "---\nname: expert-role\n.*" (skillText "SKILL.md") != null;
  solutionExpertNamesSkill =
    builtins.match ".*expert-role.*" (base "solution-expert") != null
    && builtins.match ".*expert-role.*" (base "requirement-expert") == null;

  dddReviewPath = ../_assets/agent/skill/ddd-review;
  dddReviewText = builtins.readFile (dddReviewPath + "/SKILL.md");
  dddReviewShipped =
    builtins.all (cfg: cfg.factory.domain.agent.skill.general.ddd-review == dddReviewPath)
      [
        configs.multipleOn
        configs.singleOn
      ];
  dddReviewOmitted =
    builtins.all (cfg: !(builtins.hasAttr "ddd-review" (cfg.factory.domain.agent.skill.general or { })))
      [
        configs.multipleOff
        configs.singleOff
        noArchOn
        documentationOff
      ];
  dddReviewFileExists = builtins.pathExists (dddReviewPath + "/SKILL.md");
  dddReviewFrontmatter =
    builtins.match "---\nname: ddd-review\ndescription: Review DDD artifacts, bounded context canvases, aggregate invariants, and artifact links.*\n---\n.*" dddReviewText
    != null;
  dddReviewContent = builtins.all (pattern: builtins.match pattern dddReviewText != null) [
    ".*## When to use.*"
    ".*## Read first.*"
    ".*## Procedure.*"
    ".*## Checks.*"
    ".*## Report.*"
    ".*## Rules.*"
    ".*services/.*src/.*"
    ".*requirement expert.*phase 1.*"
    ".*solution expert.*phases 2, 3, and 5.*"
    ".*Do not change.*"
  ];
  # The roles, the guidance, and the skills describe the change and version model.
  agentsSources = [
    ../_assets/multiple/AGENTS.md
    ../_assets/multiple/ddd/AGENTS.md
    ../_assets/single/AGENTS.md
    ../_assets/single/ddd/AGENTS.md
  ];
  dddPageSources = [
    ../_assets/multiple/ddd/docs/wiki/design/ddd/artifact-driven.md
    ../_assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md
  ];
  matchesAll = patterns: text: builtins.all (pattern: builtins.match pattern text != null) patterns;

  rolesNameVersions = builtins.all (
    role:
    matchesAll [
      ".*versions/<current>.*"
      ".*changes/change-<name>.*"
    ] (base role)
  ) roles;
  solutionExpertHasPhaseFive =
    builtins.match ".*## Procedure: phase 5, version.*" (base "solution-expert") != null;
  requirementExpertHasNoLegacyProcedure =
    builtins.match ".*## Change to a feature whose code exists.*" (base "requirement-expert") == null;
  roleTemplateHasNoRootTasks =
    builtins.match ".*feat-<name>/tasks/.*" (skillText "references/role-template.md") == null;
  agentsNameVersions = builtins.all (
    source:
    matchesAll [
      ".*versions/.*"
      ".*changes/change-<name>.*"
    ] (builtins.readFile source)
  ) agentsSources;
  agentsNameMaster = builtins.all (
    source:
    builtins.match ".*artifact-master.*Plan-Pn then Build-Pn.*" (builtins.readFile source) != null
  ) agentsSources;
  dddPageHasVersionRow = builtins.all (
    source:
    builtins.match ".*\\| 5 Version \\| Solution expert \\|.*" (builtins.readFile source) != null
  ) dddPageSources;
  dddReviewNamesPhaseFive =
    builtins.match ".*solution expert.*phases 2, 3, and 5.*" dddReviewText != null;
  descriptions =
    builtins.match ".*phases 2, 3, and 5.*" configs.multipleOn.factory.domain.agent.role.builder.solution-expert.description
    != null;
  coordinatorModeAll =
    builtins.all
      (cfg: cfg.factory.domain.agent.role.builder.artifact-master.harness.opencode.mode == "all")
      [
        configs.multipleOn
        configs.singleOn
      ];
  expertsStaySubagent =
    builtins.all
      (
        cfg:
        builtins.all (
          role: cfg.factory.domain.agent.role.builder.${role}.harness.opencode.mode == "subagent"
        ) expertRoles
      )
      [
        configs.multipleOn
        configs.singleOn
      ];

  masterSkillPath = ../_assets/agent/skill/by-role/artifact-master/artifact-master;
  masterSkillText = builtins.readFile (masterSkillPath + "/SKILL.md");
  masterSkillShipped =
    builtins.all (cfg: cfg.factory.domain.agent.skill.general.artifact-master == masterSkillPath)
      [
        configs.multipleOn
        configs.multipleOff
        configs.singleOn
        configs.singleOff
        noArchOn
      ];
  masterSkillFileExists = builtins.pathExists (masterSkillPath + "/SKILL.md");
  masterSkillOmitted =
    !(builtins.hasAttr "artifact-master" (documentationOff.factory.domain.agent.skill.general or { }));
  masterSkillIsGeneric = builtins.all (
    pattern: builtins.match pattern masterSkillText == null
  ) forbidden;
  masterSkillFrontmatter = builtins.match "---\nname: artifact-master\n.*" masterSkillText != null;
  masterRoleText = base "artifact-master";
  masterRoleCoordinates = matchesAll [
    ".*coordinate-plan.*chat only.*"
    ".*Do not put the coordinate-plan in `tasks/`.*"
    ".*Plan-P1 reads the business need or the change reason.*"
    ".*Plan-P2, Plan-P3, and Plan-P5 read only the committed output of the prior phase.*"
    ".*A plan is read-only.*"
    ".*explicit user approval.*"
    ".*Route phase 1 to the requirement expert.*"
    ".*Route phases 2, 3, and 5 to the solution expert.*"
    ".*Route each phase 4 component task to its implementation expert.*"
    ".*ask the solution expert to help.*select an owner.*"
    ".*Do not write requirements, specifications, decisions, tasks, code, tests, or versions.*"
    ".*Each build ends with one commit for that phase.*"
    ".*Phase 4 has no Plan-P4.*"
  ] masterRoleText;
  masterRolePlanMessage = matchesAll [
    ".*\\*\\*Phase:\\*\\*.*"
    ".*\\*\\*Purpose:\\*\\*.*"
    ".*\\*\\*Input:\\*\\*.*"
    ".*\\*\\*Scope:\\*\\*.*"
    ".*\\*\\*Expected files:\\*\\*.*"
    ".*\\*\\*Owner:\\*\\*.*"
    ".*\\*\\*Acceptance checks:\\*\\*.*"
    ".*\\*\\*User choices or actions:\\*\\*.*"
    ".*\\*\\*Approval request:\\*\\*.*"
    ".*Mark an unknown required field as an open item.*"
  ] masterRoleText;
  masterRoleMessages = matchesAll [
    ".*Phase 3 approval is the Phase 4 gate.*"
    ".*Do not request a second phase approval.*"
    ".*Send a progress message only when there is new material information.*"
    ".*Do not send a routine progress message when there is no new material information.*"
    ".*\\*\\*Written files:\\*\\*.*"
    ".*\\*\\*Checks:\\*\\*.*"
    ".*\\*\\*Commit:\\*\\*.*"
    ".*\\*\\*Key decisions:\\*\\*.*"
    ".*\\*\\*Open items:\\*\\*.*"
    ".*\\*\\*Next input:\\*\\*.*"
    ".*\\*\\*Next user action:\\*\\*.*"
    ".*The handoff is the last message of the phase build.*"
    ".*Include only information.*"
  ] masterRoleText;
  roleRender =
    uses:
    let
      agent = configs.multipleOn.factory.domain.agent;
      rendered = import ../../../domain/agent/role/default.nix {
        inherit lib;
        config.factory = {
          _utils = optionUtils;
          domain.agent = agent // {
            harness = (agent.harness or { }) // {
              inherit uses;
            };
            role = (agent.role or { }) // {
              builder = builtins.mapAttrs (
                name: role:
                let
                  roleHarness = role.harness or { };
                in
                role
                // {
                  enable = true;
                  inherit name;
                  harness = roleHarness // {
                    claude = roleHarness.claude or { };
                    codex = roleHarness.codex or { };
                    opencode = roleHarness.opencode or { };
                  };
                }
              ) agent.role.builder;
            };
          };
        };
        namespace = "factory";
      };
    in
    rendered.config.files;
  opencodeRole = (roleRender [ "opencode" ]).".opencode/agents/artifact-master.md".text;
  claudeRole = (roleRender [ "claude" ]).".claude/agents/artifact-master.md".text;
  codexRole =
    (roleRender [ "codex" ]).".codex/agents/artifact-master.toml".toml.developer_instructions;
  renderedMasterRolesMatch =
    builtins.all
      (
        text:
        matchesAll [
          ".*## Phase control.*"
          ".*Plan-P1 reads the business need or the change reason.*"
          ".*Phase 4 has no Plan-P4.*"
          ".*## Plan-Pn message.*"
          ".*## Phase 4 start message.*"
          ".*Phase 3 approval is the Phase 4 gate.*"
          ".*## Build-Pn handoff.*"
        ] text
      )
      [
        opencodeRole
        claudeRole
        codexRole
      ];
  unselectedMasterRoleOmitted = roleRender [ ] == { };
  masterSkillPaths = matchesAll [
    ".*\\.opencode/agents/artifact-master\\.md.*"
    ".*\\.claude/agents/artifact-master\\.md.*"
    ".*\\.codex/agents/artifact-master\\.toml.*"
    ".*Load the rendered `artifact-master` role before you coordinate a change.*"
  ] masterSkillText;
  masterSkillDoesNotCopyRole =
    builtins.match ".*## Plan-Pn message.*" masterSkillText == null
    && builtins.match ".*## Build-Pn handoff.*" masterSkillText == null
    && builtins.match ".*\\*\\*Written files:\\*\\*.*" masterSkillText == null;

  moexPage = "docs/wiki/documentation/mixture-of-experts/README.md";
  moexCanonical = ../../../../../docs/wiki/documentation/mixture-of-experts/README.md;
  moexCanonicalText = builtins.readFile moexCanonical;
  moexMirrors = [
    ../_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md
    ../_assets/single/docs/wiki/documentation/mixture-of-experts/README.md
  ];
  moexExpectedSources = {
    multipleOn = ../_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md;
    multipleOff = ../_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md;
    singleOn = ../_assets/single/docs/wiki/documentation/mixture-of-experts/README.md;
    singleOff = ../_assets/single/docs/wiki/documentation/mixture-of-experts/README.md;
  };
  moexIndexSources = [
    ../../../../../docs/wiki/README.md
    ../_assets/multiple/docs/wiki/README.md
    ../_assets/multiple/ddd/docs/wiki/README.md
    ../_assets/single/docs/wiki/README.md
    ../_assets/single/ddd/docs/wiki/README.md
  ];
  moexDelivery = builtins.all (
    key:
    configs.${key}.files.${moexPage}.copyMode == "copy"
    && configs.${key}.files.${moexPage}.source == moexExpectedSources.${key}
    && builtins.pathExists configs.${key}.files.${moexPage}.source
  ) keys;
  moexDisabled =
    !(builtins.hasAttr moexPage (noArchOn.files or { }))
    && !(builtins.hasAttr moexPage (documentationOff.files or { }));
  moexMirrorsMatch = builtins.all (mirror: builtins.readFile mirror == moexCanonicalText) moexMirrors;
  moexIndexesLink = builtins.all (
    source:
    builtins.match ".*- [[]Mixture of Experts[]][(]documentation/mixture-of-experts/README[.]md[)][.].*" (
      builtins.readFile source
    ) != null
  ) moexIndexSources;
  moexSections = matchesAll [
    ".*# Mixture of experts.*"
    ".*## Roles and ownership.*"
    ".*## Phase routing.*"
    ".*## Plan-Pn then Build-Pn.*"
    ".*## Two kinds of plan.*"
    ".*## Harness rendering.*"
    ".*## Skill load.*"
    ".*## Related documentation.*"
  ] moexCanonicalText;
  moexTerms = matchesAll [
    ".*Artifact master \\| The role that coordinates one artifact-driven change and routes each phase\\..*"
    ".*Content expert \\| A role that owns the content of one or more phases\\..*"
    ".*Harness \\| A coding agent product that reads the role files and skills of a project\\..*"
    ".*Role \\| An agent persona with one instruction body and one harness declaration\\..*"
    ".*Skill \\| A folder of instructions that a harness loads on request\\..*"
    ".*Canonical role body \\| The shared source of the artifact-master coordination contract\\..*"
    ".*Rendered role \\| The canonical role body in the file format of one harness\\..*"
  ] moexCanonicalText;
  moexRoleRows = matchesAll [
    ".*\\| Artifact master \\| Coordination only\\. It writes no phase content\\. \\|.*"
    ".*\\| Requirement expert \\| Requirements in phase 1\\. \\|.*"
    ".*\\| Solution expert \\| Specifications, decisions, tasks, and versions in phases 2, 3, and 5\\. \\|.*"
    ".*\\| Implementation expert \\| Code and tests for one component in phase 4\\. \\|.*"
  ] moexCanonicalText;
  moexPhaseRows = matchesAll [
    ".*\\| P1 Requirements \\| Requirement expert \\|.*"
    ".*\\| P2 Specifications \\| Solution expert \\|.*"
    ".*\\| P3 Plan \\| Solution expert \\|.*"
    ".*\\| P4 Implementation \\| Implementation expert for each component \\|.*"
    ".*\\| P5 Version \\| Solution expert \\|.*"
  ] moexCanonicalText;
  moexHarnesses = matchesAll [
    ".*OpenCode.*"
    ".*Claude.*"
    ".*Codex.*"
  ] moexCanonicalText;
  moexSelfContained =
    builtins.match ".*\\{\\{.*" moexCanonicalText == null
    && builtins.match ".*include::.*" moexCanonicalText == null;

  compositionModule = moduleFor { };
  providerModule = import ../../../domain/project-management/provider/default.nix {
    config.factory._utils = optionUtils;
    namespace = "factory";
  };
  compositionOwnsPolicy =
    compositionModule.options.factory.composition.artifact-driven.project-issues.enable.default == false
    &&
      compositionModule.options.factory.composition.artifact-driven.project-issues.artifact-status.task.default
      == "Ready"
    &&
      compositionModule.options.factory.composition.artifact-driven.project-issues.notification.uses.default
      == [ ]
    &&
      compositionModule.options.factory.composition.artifact-driven.project-issues.notification.telegram.token-secret.default
      == "ARTIFACT_NOTIFICATION_TELEGRAM_TOKEN";
  providerDoesNotOwnPolicy =
    !(builtins.hasAttr "artifact-status" providerModule.options.factory.domain.project-management);
in
assert sourcesMatch;
assert sourcesExist;
assert chapterAppended;
assert chapterOmitted;
assert chapterHasHeading;
assert pageOn;
assert pageOff;
assert noArchOmitsGuidance;
assert githubProjectIssuesOn;
assert trelloProjectIssuesOn;
assert adapterSelectionPassive;
assert invalidSetupsRejected;
assert providerConfigMatches;
assert workflowsUseSelectedSecrets;
assert workflowsCanWritePullRequestComments;
assert notificationFilesMatch;
assert notificationWorkflowsMatch;
assert multiProviderWorkflowMatches;
assert notificationWorkflowIndentation;
assert credentialGuideMatches;
assert notificationGuidesMatch;
assert azureGithubOnOk;
assert azureTrelloOnOk;
assert azureTrelloSplitOk;
assert azureDisabledOk;
assert azureSharedIdentical;
assert azureGithubSecretsMapped;
assert azureTrelloSecretsMapped;
assert azurePipelineTrigger;
assert azureMultiProviderMatches;
assert azureGuidesMatch;
assert compositionOwnsPolicy;
assert providerDoesNotOwnPolicy;
assert skillShipped;
assert skillFilesExist;
assert skillOmitted;
assert skillIsGeneric;
assert skillFrontmatter;
assert solutionExpertNamesSkill;
assert dddReviewShipped;
assert dddReviewOmitted;
assert dddReviewFileExists;
assert dddReviewFrontmatter;
assert dddReviewContent;
assert rolesNameVersions;
assert solutionExpertHasPhaseFive;
assert requirementExpertHasNoLegacyProcedure;
assert roleTemplateHasNoRootTasks;
assert agentsNameVersions;
assert agentsNameMaster;
assert dddPageHasVersionRow;
assert dddReviewNamesPhaseFive;
assert descriptions;
assert coordinatorModeAll;
assert expertsStaySubagent;
assert masterSkillShipped;
assert masterSkillFileExists;
assert masterSkillOmitted;
assert masterSkillIsGeneric;
assert masterSkillFrontmatter;
assert masterRoleCoordinates;
assert masterRolePlanMessage;
assert masterRoleMessages;
assert renderedMasterRolesMatch;
assert unselectedMasterRoleOmitted;
assert masterSkillPaths;
assert masterSkillDoesNotCopyRole;
assert moexDelivery;
assert moexDisabled;
assert moexMirrorsMatch;
assert moexIndexesLink;
assert moexSections;
assert moexTerms;
assert moexRoleRows;
assert moexPhaseRows;
assert moexHarnesses;
assert moexSelfContained;
{
  inherit
    sourcesMatch
    sourcesExist
    chapterAppended
    chapterOmitted
    chapterHasHeading
    pageOn
    pageOff
    noArchOmitsGuidance
    githubProjectIssuesOn
    trelloProjectIssuesOn
    adapterSelectionPassive
    invalidSetupsRejected
    providerConfigMatches
    workflowsUseSelectedSecrets
    workflowsCanWritePullRequestComments
    notificationFilesMatch
    notificationWorkflowsMatch
    multiProviderWorkflowMatches
    notificationWorkflowIndentation
    credentialGuideMatches
    notificationGuidesMatch
    azureGithubOnOk
    azureTrelloOnOk
    azureTrelloSplitOk
    azureDisabledOk
    azureSharedIdentical
    azureGithubSecretsMapped
    azureTrelloSecretsMapped
    azurePipelineTrigger
    azureMultiProviderMatches
    azureGuidesMatch
    compositionOwnsPolicy
    providerDoesNotOwnPolicy
    skillShipped
    skillFilesExist
    skillOmitted
    skillIsGeneric
    skillFrontmatter
    solutionExpertNamesSkill
    dddReviewShipped
    dddReviewOmitted
    dddReviewFileExists
    dddReviewFrontmatter
    dddReviewContent
    rolesNameVersions
    solutionExpertHasPhaseFive
    requirementExpertHasNoLegacyProcedure
    roleTemplateHasNoRootTasks
    agentsNameVersions
    agentsNameMaster
    dddPageHasVersionRow
    dddReviewNamesPhaseFive
    descriptions
    coordinatorModeAll
    expertsStaySubagent
    masterSkillShipped
    masterSkillFileExists
    masterSkillOmitted
    masterSkillIsGeneric
    masterSkillFrontmatter
    masterRoleCoordinates
    masterRolePlanMessage
    masterRoleMessages
    renderedMasterRolesMatch
    unselectedMasterRoleOmitted
    masterSkillPaths
    masterSkillDoesNotCopyRole
    moexDelivery
    moexDisabled
    moexMirrorsMatch
    moexIndexesLink
    moexSections
    moexTerms
    moexRoleRows
    moexPhaseRows
    moexHarnesses
    moexSelfContained
    ;
}
