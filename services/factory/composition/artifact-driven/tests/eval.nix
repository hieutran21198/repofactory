let
  optionUtils = {
    mkBoolOpt = inputs: inputs;
    mkStrOpt = inputs: inputs;
    mkIntOpt = inputs: inputs;
    mkEnumOpt = inputs: inputs;
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
      trelloApiKeySecret ? "TRELLO_API_KEY",
      trelloTokenSecret ? "TRELLO_TOKEN",
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
              api-key-secret = trelloApiKeySecret;
              token-secret = trelloTokenSecret;
            };
          };
        };
        composition.artifact-driven.project-issues = {
          inherit enable;
          artifact-status = statuses;
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
      projectProvider = "github-projects";
      enable = true;
      statuses = defaultStatuses // {
        task = "";
      };
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
  providerConfigMatches =
    githubConfig.provider == "github-projects"
    && githubConfig.githubProjects.owner == "example"
    && githubConfig.githubProjects.projectNumber == 7
    && githubConfig.statuses.task == "Ready"
    && trelloConfig.provider == "trello"
    && trelloConfig.trello.boardId == "board"
    && trelloConfig.statuses.withdrawn == "Withdrawn";
  workflowsUseSelectedSecrets =
    builtins.match ".*PROJECT_TOKEN:.*PROJECTS_TOKEN.*"
      githubOn.files.".github/workflows/accepted-artifact-issues.yml".text != null
    &&
      builtins.match ".*TRELLO_API_KEY:.*TRELLO_API_KEY.*"
        trelloOn.files.".github/workflows/accepted-artifact-issues.yml".text != null;
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

  compositionModule = moduleFor { };
  providerModule = import ../../../domain/project-management/provider/default.nix {
    config.factory._utils = optionUtils;
    namespace = "factory";
  };
  compositionOwnsPolicy =
    compositionModule.options.factory.composition.artifact-driven.project-issues.enable.default == false
    &&
      compositionModule.options.factory.composition.artifact-driven.project-issues.artifact-status.task.default
      == "Ready";
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
assert credentialGuideMatches;
assert compositionOwnsPolicy;
assert providerDoesNotOwnPolicy;
assert skillShipped;
assert skillFilesExist;
assert skillOmitted;
assert skillIsGeneric;
assert skillFrontmatter;
assert solutionExpertNamesSkill;
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
    credentialGuideMatches
    compositionOwnsPolicy
    providerDoesNotOwnPolicy
    skillShipped
    skillFilesExist
    skillOmitted
    skillIsGeneric
    skillFrontmatter
    solutionExpertNamesSkill
    ;
}
