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
  ];

  roles = [
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
  dddPageHasVersionRow = builtins.all (
    source:
    builtins.match ".*\\| 5 Version \\| Solution expert \\|.*" (builtins.readFile source) != null
  ) dddPageSources;
  dddReviewNamesPhaseFive =
    builtins.match ".*solution expert.*phases 2, 3, and 5.*" dddReviewText != null;
  descriptions =
    builtins.match ".*phases 2, 3, and 5.*" configs.multipleOn.factory.domain.agent.role.builder.solution-expert.description
    != null;

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
assert dddPageHasVersionRow;
assert dddReviewNamesPhaseFive;
assert descriptions;
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
    dddPageHasVersionRow
    dddReviewNamesPhaseFive
    descriptions
    ;
}
