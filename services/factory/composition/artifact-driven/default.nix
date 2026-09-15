{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
  model = "artifact-driven";
  workflow =
    provider: tokenSecret:
    let
      notification = config.${namespace}.composition.artifact-driven.project-issues.notification;
      notificationEnabled = notification.uses != [ ];
      providerSecrets =
        if provider == "github-projects" then
          "PROJECT_TOKEN: \${{ secrets.${tokenSecret} }}"
        else
          let
            trello = config.${namespace}.domain.project-management.provider.trello;
          in
          "TRELLO_API_KEY: \${{ secrets.${trello.api-key-secret} }}\n          TRELLO_TOKEN: \${{ secrets.${trello.token-secret} }}";
      resultEnvironment = lib.optionalString notificationEnabled "\n          ARTIFACT_ISSUES_RESULT: \${{ runner.temp }}/accepted-artifacts.json";
      notificationSecrets =
        lib.optionalString (builtins.elem "google-chat" notification.uses) "\n          ARTIFACT_NOTIFICATION_GOOGLE_CHAT_WEBHOOK: \${{ secrets.${notification.google-chat.webhook-secret} }}"
        + lib.optionalString (builtins.elem "slack" notification.uses) "\n          ARTIFACT_NOTIFICATION_SLACK_WEBHOOK: \${{ secrets.${notification.slack.webhook-secret} }}"
        + lib.optionalString (builtins.elem "telegram" notification.uses) "\n          ARTIFACT_NOTIFICATION_TELEGRAM_TOKEN: \${{ secrets.${notification.telegram.token-secret} }}\n          ARTIFACT_NOTIFICATION_TELEGRAM_CHAT_ID: ${builtins.toJSON notification.telegram.chat-id}";
      notificationStep = lib.optionalString notificationEnabled "\n      - name: Notify the team about accepted artifacts\n        if: github.event_name == 'pull_request_target'\n        run: python3 .github/artifact-issues/notify.py\n        env:\n          ARTIFACT_ISSUES_RESULT: \${{ runner.temp }}/accepted-artifacts.json\n          ARTIFACT_NOTIFICATION_USES: '${builtins.toJSON notification.uses}'${notificationSecrets}";
    in
    ''
      name: Accepted artifact issues

      on:
        pull_request_target:
          types: [closed]
        workflow_dispatch:

      permissions:
        contents: read
        issues: write
        pull-requests: write

      concurrency:
        group: accepted-artifact-issues-''${{ github.repository }}-''${{ github.event.pull_request.number || 'scan' }}
        cancel-in-progress: false

      jobs:
        synchronize:
          if: github.event_name == 'workflow_dispatch' || github.event.pull_request.merged == true
          runs-on: ubuntu-latest
          steps:
            - name: Check out accepted content
              uses: actions/checkout@v4
              with:
                ref: ''${{ github.event.pull_request.merge_commit_sha || github.sha }}
                persist-credentials: false
            - name: Synchronize accepted artifacts
              run: python3 .github/artifact-issues/sync.py
              env:
                GITHUB_TOKEN: ''${{ github.token }}
                ${providerSecrets}${resultEnvironment}
      ${notificationStep}
    '';
  azurePipeline =
    provider: tokenSecret:
    let
      notification = config.${namespace}.composition.artifact-driven.project-issues.notification;
      notificationEnabled = notification.uses != [ ];
      providerSecrets =
        if provider == "github-projects" then
          "PROJECT_TOKEN: $(${tokenSecret})"
        else
          let
            trello = config.${namespace}.domain.project-management.provider.trello;
          in
          "TRELLO_API_KEY: $(${trello.api-key-secret})\n    TRELLO_TOKEN: $(${trello.token-secret})";
      notificationSecrets =
        lib.optionalString (builtins.elem "google-chat" notification.uses) "\n    ARTIFACT_NOTIFICATION_GOOGLE_CHAT_WEBHOOK: $(${notification.google-chat.webhook-secret})"
        + lib.optionalString (builtins.elem "slack" notification.uses) "\n    ARTIFACT_NOTIFICATION_SLACK_WEBHOOK: $(${notification.slack.webhook-secret})"
        + lib.optionalString (builtins.elem "telegram" notification.uses) "\n    ARTIFACT_NOTIFICATION_TELEGRAM_TOKEN: $(${notification.telegram.token-secret})\n    ARTIFACT_NOTIFICATION_TELEGRAM_CHAT_ID: ${builtins.toJSON notification.telegram.chat-id}";
      notificationStep = lib.optionalString notificationEnabled ''
        - script: python3 .github/artifact-issues/notify.py
          displayName: Notify the team about accepted artifacts
          condition: and(succeeded(), eq(variables['ArtifactIssuesNotify'], 'true'))
          env:
            ARTIFACT_ISSUES_RESULT: $(Agent.TempDirectory)/accepted-artifacts.json
            ARTIFACT_NOTIFICATION_USES: '${builtins.toJSON notification.uses}'${notificationSecrets}
      '';
    in
    ''
      trigger:
        branches:
          include:
          - main
      pr: none

      pool:
        vmImage: 'ubuntu-latest'

      steps:
      - checkout: self
        persistCredentials: false
      - script: |
          python3 - <<'PYEOF'
          import json, os, urllib.request
          reason = os.environ.get("BUILD_REASON", "Manual")
          repository = os.environ.get("BUILD_REPOSITORY_NAME", "")
          sha = os.environ.get("BUILD_SOURCEVERSION", "")
          branch = os.environ.get("BUILD_SOURCEBRANCHNAME", "main")
          event_path = os.environ.get("ARTIFACT_ISSUES_EVENT", "")
          token = os.environ.get("GITHUB_TOKEN", "")
          event = {"repository": {"default_branch": branch or "main"}}
          notify = "false"
          if reason != "Manual" and repository and sha and token:
              api = "https://api.github.com/repos/" + repository + "/commits/" + sha + "/pulls"
              request = urllib.request.Request(api, headers={"Accept": "application/vnd.github+json", "Authorization": "Bearer " + token, "X-GitHub-Api-Version": "2022-11-28"})
              try:
                  with urllib.request.urlopen(request, timeout=30) as response:
                      pulls = json.loads(response.read().decode())
                  merged = [pull for pull in pulls if isinstance(pull, dict) and pull.get("merged")]
                  if merged:
                      pull = merged[0]
                      event["pull_request"] = {"number": pull.get("number", 0), "title": pull.get("title", ""), "html_url": pull.get("html_url", ""), "merged": True, "merge_commit_sha": sha}
                      notify = "true"
                  else:
                      print("No merged pull request found for this commit; scan the complete artifact tree")
              except Exception as error:
                  raise SystemExit("accepted-artifact-issues: cannot resolve the merged pull request: " + str(error))
          with open(event_path, "w") as handle:
              json.dump(event, handle)
          print("##vso[task.setvariable variable=ArtifactIssuesNotify]" + notify)
          PYEOF
        displayName: Write the accepted artifact event file
        env:
          ARTIFACT_ISSUES_EVENT: $(Agent.TempDirectory)/accepted-artifact-event.json
          BUILD_REASON: $(Build.Reason)
          BUILD_REPOSITORY_NAME: $(Build.Repository.Name)
          BUILD_SOURCEBRANCHNAME: $(Build.SourceBranchName)
          BUILD_SOURCEVERSION: $(Build.SourceVersion)
          GITHUB_TOKEN: $(GITHUB_TOKEN)
      - script: python3 .github/artifact-issues/sync.py
        displayName: Synchronize accepted artifacts
        env:
          GITHUB_REPOSITORY: $(Build.Repository.Name)
          GITHUB_SHA: $(Build.SourceVersion)
          GITHUB_EVENT_PATH: $(Agent.TempDirectory)/accepted-artifact-event.json
          GITHUB_TOKEN: $(GITHUB_TOKEN)
          ${providerSecrets}
          ARTIFACT_ISSUES_RESULT: $(Agent.TempDirectory)/accepted-artifacts.json
      ${notificationStep}'';
in
{
  options.${namespace}.composition.artifact-driven.project-issues = {
    enable = _utils.mkBoolOpt {
      default = false;
      description = "Whether to synchronize accepted artifacts to the selected project-management provider";
    };
    artifact-status = {
      feature-summary = _utils.mkStrOpt { default = "Accepted"; };
      master-requirement = _utils.mkStrOpt { default = "Accepted"; };
      requirement = _utils.mkStrOpt { default = "Accepted"; };
      master-specification = _utils.mkStrOpt { default = "Accepted"; };
      specification = _utils.mkStrOpt { default = "Accepted"; };
      decision = _utils.mkStrOpt { default = "Accepted"; };
      implementation-plan = _utils.mkStrOpt { default = "Accepted"; };
      task = _utils.mkStrOpt { default = "Ready"; };
      change-summary = _utils.mkStrOpt { default = "Accepted"; };
      withdrawn = _utils.mkStrOpt { default = "Withdrawn"; };
    };
    notification = {
      uses = _utils.mkListOpt {
        ofType = lib.types.enum [
          "google-chat"
          "slack"
          "telegram"
        ];
        default = [ ];
        description = "The team providers for accepted artifact summaries";
      };
      google-chat.webhook-secret = _utils.mkStrOpt {
        default = "ARTIFACT_NOTIFICATION_GOOGLE_CHAT_WEBHOOK";
        description = "The GitHub Actions secret that contains the Google Chat webhook URL";
      };
      slack.webhook-secret = _utils.mkStrOpt {
        default = "ARTIFACT_NOTIFICATION_SLACK_WEBHOOK";
        description = "The GitHub Actions secret that contains the Slack webhook URL";
      };
      telegram = {
        token-secret = _utils.mkStrOpt {
          default = "ARTIFACT_NOTIFICATION_TELEGRAM_TOKEN";
          description = "The GitHub Actions secret that contains the Telegram bot token";
        };
        chat-id = _utils.mkStrOpt {
          default = "";
          description = "The Telegram chat ID that receives accepted artifact summaries";
        };
      };
    };
  };

  config =
    let
      inherit (config.${namespace}.domain)
        repo-arch
        documentation
        design
        ci-cd
        project-management
        ;
      ddd = design.use == "ddd";
      projectProvider = project-management.provider.use;
      projectIssues = config.${namespace}.composition.artifact-driven.project-issues;
      artifactIssues = projectIssues.enable;
      notificationEnabled = projectIssues.notification.uses != [ ];
      githubProjects = project-management.provider.github-projects;
      trello = project-management.provider.trello;
      projectConfig = {
        provider = projectProvider;
        statuses = projectIssues.artifact-status;
        githubProjects = {
          inherit (githubProjects) ownership owner;
          projectNumber = githubProjects.project-number;
        };
        trello = {
          boardId = trello.board-id;
          implementationBoardId = trello.implementation-board-id;
        };
      };
    in
    lib.mkMerge [
      (lib.mkIf artifactIssues {
        assertions = [
          {
            assertion = documentation.use == model;
            message = "${namespace}.composition.artifact-driven.project-issues requires ${namespace}.domain.documentation.use = \"artifact-driven\"";
          }
          {
            assertion = builtins.elem ci-cd.provider.use [
              "github-actions"
              "azure-pipelines"
            ];
            message = "${namespace}.composition.artifact-driven.project-issues requires ${namespace}.domain.ci-cd.provider.use = \"github-actions\" or \"azure-pipelines\"";
          }
          {
            assertion = builtins.elem projectProvider [
              "github-projects"
              "trello"
            ];
            message = "${namespace}.composition.artifact-driven.project-issues requires a supported project-management provider";
          }
        ]
        ++ builtins.map (name: {
          assertion = projectIssues.artifact-status.${name} != "";
          message = "${namespace}.composition.artifact-driven.project-issues.artifact-status.${name} must not be empty";
        }) (builtins.attrNames projectIssues.artifact-status)
        ++ lib.optional notificationEnabled {
          assertion = builtins.all (
            use:
            builtins.elem use [
              "google-chat"
              "slack"
              "telegram"
            ]
          ) projectIssues.notification.uses;
          message = "${namespace}.composition.artifact-driven.project-issues.notification.uses must contain only supported providers";
        }
        ++ lib.optional notificationEnabled {
          assertion =
            builtins.length projectIssues.notification.uses
            == builtins.length (lib.unique projectIssues.notification.uses);
          message = "${namespace}.composition.artifact-driven.project-issues.notification.uses must not contain a provider more than once";
        }
        ++ lib.optional (builtins.elem "google-chat" projectIssues.notification.uses) {
          assertion =
            builtins.match "[A-Za-z_][A-Za-z0-9_]*" projectIssues.notification.google-chat.webhook-secret
            != null;
          message = "${namespace}.composition.artifact-driven.project-issues.notification.google-chat.webhook-secret must be a GitHub secret name";
        }
        ++ lib.optional (builtins.elem "slack" projectIssues.notification.uses) {
          assertion =
            builtins.match "[A-Za-z_][A-Za-z0-9_]*" projectIssues.notification.slack.webhook-secret != null;
          message = "${namespace}.composition.artifact-driven.project-issues.notification.slack.webhook-secret must be a GitHub secret name";
        }
        ++ lib.optional (builtins.elem "telegram" projectIssues.notification.uses) {
          assertion =
            builtins.match "[A-Za-z_][A-Za-z0-9_]*" projectIssues.notification.telegram.token-secret != null;
          message = "${namespace}.composition.artifact-driven.project-issues.notification.telegram.token-secret must be a GitHub secret name";
        }
        ++ lib.optional (builtins.elem "telegram" projectIssues.notification.uses) {
          assertion = projectIssues.notification.telegram.chat-id != "";
          message = "${namespace}.composition.artifact-driven.project-issues.notification.telegram.chat-id must not be empty";
        }
        ++ (
          if projectProvider == "github-projects" then
            [
              {
                assertion = githubProjects.owner != "";
                message = "${namespace}.domain.project-management.provider.github-projects.owner must not be empty when project issues are enabled";
              }
              {
                assertion = githubProjects.project-number > 0;
                message = "${namespace}.domain.project-management.provider.github-projects.project-number must be positive when project issues are enabled";
              }
              {
                assertion = builtins.match "[A-Za-z_][A-Za-z0-9_]*" githubProjects.token-secret != null;
                message = "${namespace}.domain.project-management.provider.github-projects.token-secret must be a GitHub secret name";
              }
            ]
          else
            [ ]
        )
        ++ (
          if projectProvider == "trello" then
            [
              {
                assertion = trello.board-id != "";
                message = "${namespace}.domain.project-management.provider.trello.board-id must not be empty when project issues are enabled";
              }
              {
                assertion =
                  trello.implementation-board-id == "" || trello.implementation-board-id != trello.board-id;
                message = "${namespace}.domain.project-management.provider.trello board IDs must be different";
              }
              {
                assertion = builtins.match "[A-Za-z_][A-Za-z0-9_]*" trello.api-key-secret != null;
                message = "${namespace}.domain.project-management.provider.trello.api-key-secret must be a GitHub secret name";
              }
              {
                assertion = builtins.match "[A-Za-z_][A-Za-z0-9_]*" trello.token-secret != null;
                message = "${namespace}.domain.project-management.provider.trello.token-secret must be a GitHub secret name";
              }
            ]
          else
            [ ]
        );
      })

      # agent
      (lib.mkIf (documentation.use == model) {
        ${namespace}.domain = {
          agent =
            let
              mkRole = name: description: {
                inherit description;
                # The DDD chapter is a second authored file, appended when the design method is DDD.
                # It has one version for each repository architecture.
                instruction =
                  let
                    chapter = ./_assets/${repo-arch.use}/ddd/agent/role/${name}/ROLE.md;
                  in
                  builtins.readFile ./_assets/agent/role/${name}/ROLE.md
                  + lib.optionalString (ddd && builtins.pathExists chapter) ("\n" + builtins.readFile chapter);
                harness.opencode.mode = "subagent";
              };

              # The coordinator is directly selectable in opencode, but stays a delegated
              # subagent in claude and codex, which have no custom primary mode.
              mkCoordinatorRole =
                name: description:
                (mkRole name description)
                // {
                  harness.opencode.mode = "all";
                };

              builtinRoles = {
                requirement-expert = mkRole "requirement-expert" "Gathers the business need and writes the change summary and the requirements of a feature. Owns phase 1 of the artifact-driven documentation model. Use when a new feature starts, or when a change to a feature starts.";
                solution-expert = mkRole "solution-expert" "Designs the solution for a feature and writes the specifications, the decisions, and the implementation plan. Owns phases 2, 3, and 5 of the artifact-driven documentation model. Keeps the versions of each feature. Works with the implementation expert of each component that the solution touches.";
                artifact-master = mkCoordinatorRole "artifact-master" "Coordinates one artifact-driven change phase by phase with Plan-Pn then Build-Pn. Owns coordination only and delegates content to the owning expert. Use for coordinating a change, planning then building a phase, or running the next artifact phase.";
              };

              inherit (import ../_utils.nix { inherit lib; }) loadRoleSkills;
            in
            {
              role.builder = builtinRoles;
              skill.general =
                (lib.foldl' (acc: roleName: acc // loadRoleSkills ./_assets/agent/skill/by-role roleName) { } (
                  builtins.attrNames builtinRoles
                ))
                //
                  lib.optionalAttrs
                    (
                      ddd
                      && builtins.elem repo-arch.use [
                        "multiple"
                        "single"
                      ]
                    )
                    {
                      ddd-review = ./_assets/agent/skill/ddd-review;
                    };
            };
        };
      })

      # Combine the documentation model with the repo-arch seeds.
      (lib.mkIf (documentation.use == model && repo-arch.use == "multiple") {
        files = {
          "AGENTS.md".source = lib.mkForce (
            if ddd then ./_assets/multiple/ddd/AGENTS.md else ./_assets/multiple/AGENTS.md
          );
          "docs/README.md".source = lib.mkForce (
            if ddd then ./_assets/ddd/docs/README.md else ./_assets/docs/README.md
          );
          "docs/wiki/README.md".source = lib.mkForce (
            if ddd then ./_assets/multiple/ddd/docs/wiki/README.md else ./_assets/multiple/docs/wiki/README.md
          );
          "docs/wiki/documentation/mixture-of-experts/README.md" = {
            source = ./_assets/multiple/docs/wiki/documentation/mixture-of-experts/README.md;
            copyMode = "copy";
          };
        }
        // lib.optionalAttrs ddd {
          "docs/wiki/design/ddd/artifact-driven.md" = {
            source = ./_assets/multiple/ddd/docs/wiki/design/ddd/artifact-driven.md;
            copyMode = "copy";
          };
        };
      })

      # Combine the documentation model with the repo-arch seeds.
      (lib.mkIf (documentation.use == model && repo-arch.use == "single") {
        files = {
          "AGENTS.md".source = lib.mkForce (
            if ddd then ./_assets/single/ddd/AGENTS.md else ./_assets/single/AGENTS.md
          );
          "docs/README.md".source = lib.mkForce (
            if ddd then ./_assets/ddd/docs/README.md else ./_assets/docs/README.md
          );
          "docs/wiki/README.md".source = lib.mkForce (
            if ddd then ./_assets/single/ddd/docs/wiki/README.md else ./_assets/single/docs/wiki/README.md
          );
          "docs/wiki/documentation/mixture-of-experts/README.md" = {
            source = ./_assets/single/docs/wiki/documentation/mixture-of-experts/README.md;
            copyMode = "copy";
          };
        }
        // lib.optionalAttrs ddd {
          "docs/wiki/design/ddd/artifact-driven.md" = {
            source = ./_assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md;
            copyMode = "copy";
          };
        };
      })

      # Combine accepted artifact issues with the selected CI provider and project provider.
      (lib.mkIf artifactIssues {
        files = {
          ".github/artifact-issues/sync.py" = {
            source = ./_assets/project-issues/sync.py;
            copyMode = "copy";
          };
          ".github/artifact-issues/config.json" = {
            text = builtins.toJSON projectConfig;
            copyMode = "copy";
          };
          "docs/wiki/documentation/artifact-driven/project-issues.md" = {
            source = ./_assets/project-issues/project-issues.md;
            copyMode = "copy";
          };
          "docs/wiki/documentation/artifact-driven/project-issue-credentials.md" = {
            source = ./_assets/project-issues/project-issue-credentials.md;
            copyMode = "copy";
          };
        }
        // lib.optionalAttrs (ci-cd.provider.use == "github-actions") {
          ".github/workflows/accepted-artifact-issues.yml" = {
            text = workflow projectProvider (
              if projectProvider == "github-projects" then githubProjects.token-secret else ""
            );
            copyMode = "copy";
          };
        }
        // lib.optionalAttrs (ci-cd.provider.use == "azure-pipelines") {
          "${ci-cd.provider.azure-pipelines.folder}/accepted-artifact-issues.yml" = {
            text = azurePipeline projectProvider (
              if projectProvider == "github-projects" then githubProjects.token-secret else ""
            );
            copyMode = "copy";
          };
        }
        // lib.optionalAttrs notificationEnabled {
          ".github/artifact-issues/notify.py" = {
            source = ./_assets/project-issues/notify.py;
            copyMode = "copy";
          };
        };
      })
    ];
}
