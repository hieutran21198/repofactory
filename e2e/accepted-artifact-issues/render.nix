{
  provider,
  owner ? "hieutran21198",
  projectNumber ? 1,
  trelloBoard ? "unused",
  trelloImplementationBoard ? "",
  notificationProvider ? "unset",
  notificationSecret ? "ARTIFACT_NOTIFICATION_SLACK_WEBHOOK",
}:
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

  statuses = {
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

  module = import ../../services/factory/composition/artifact-driven/default.nix {
    inherit lib;
    namespace = "factory";
    config.factory = {
      _utils = optionUtils;
      domain = {
        documentation.use = "artifact-driven";
        repo-arch.use = "multiple";
        design.use = "ddd";
        ci-cd.provider.use = "github-actions";
        project-management.provider = {
          use = provider;
          github-projects = {
            ownership = "personal";
            inherit owner;
            project-number = projectNumber;
            token-secret = "PROJECTS_TOKEN";
          };
          trello = {
            board-id = trelloBoard;
            implementation-board-id = trelloImplementationBoard;
            api-key-secret = "TRELLO_API_KEY";
            token-secret = "TRELLO_TOKEN";
          };
        };
      };
      composition.artifact-driven.project-issues = {
        enable = true;
        artifact-status = statuses;
        notification = {
          uses = if notificationProvider == "unset" then [ ] else [ notificationProvider ];
          google-chat.webhook-secret = notificationSecret;
          slack.webhook-secret = notificationSecret;
          telegram = {
            token-secret = notificationSecret;
            chat-id = "-100123";
          };
        };
      };
    };
  };

  wanted = [
    ".github/workflows/accepted-artifact-issues.yml"
    ".github/artifact-issues/sync.py"
    ".github/artifact-issues/config.json"
    "docs/wiki/documentation/artifact-driven/project-issues.md"
  ]
  ++ lib.optional (notificationProvider != "unset") ".github/artifact-issues/notify.py";
  files = module.config.files;
in
builtins.listToAttrs (
  map (name: {
    inherit name;
    value = if files.${name} ? text then files.${name}.text else builtins.readFile files.${name}.source;
  }) wanted
)
