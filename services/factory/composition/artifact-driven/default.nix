{
  config,
  namespace,
  lib,
  ...
}:
let
  model = "artifact-driven";
  workflow =
    provider: tokenSecret:
    let
      providerSecrets =
        if provider == "github-projects" then
          "PROJECT_TOKEN: \${{ secrets.${tokenSecret} }}"
        else
          let
            trello = config.${namespace}.domain.project-management.provider.trello;
          in
          "TRELLO_API_KEY: \${{ secrets.${trello.api-key-secret} }}\n          TRELLO_TOKEN: \${{ secrets.${trello.token-secret} }}";
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
        pull-requests: read

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
                ${providerSecrets}
    '';
in
{
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
      artifactIssues =
        documentation.use == model
        && ci-cd.provider.use == "github-actions"
        && builtins.elem projectProvider [
          "github-projects"
          "trello"
        ];
      githubProjects = project-management.provider.github-projects;
      trello = project-management.provider.trello;
      projectConfig = {
        provider = projectProvider;
        statuses = project-management.artifact-status;
        githubProjects = {
          inherit (githubProjects) ownership owner;
          projectNumber = githubProjects.project-number;
        };
        trello = {
          boardId = trello.board-id;
        };
      };
    in
    lib.mkMerge [
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

              builtinRoles = {
                requirement-expert = mkRole "requirement-expert" "Gathers the business need and writes the requirements of a feature. Owns phase 1 of the artifact-driven documentation model. Use when a new feature starts, or when the requirements of a feature change.";
                solution-expert = mkRole "solution-expert" "Designs the solution for a feature and writes the specifications, the decisions, and the implementation plan. Owns phases 2 and 3 of the artifact-driven documentation model. Works with the implementation expert of each component that the solution touches.";
              };

              inherit (import ../_utils.nix { inherit lib; }) loadRoleSkills;
            in
            {
              role.builder = builtinRoles;
              skill.general = lib.foldl' (
                acc: roleName: acc // loadRoleSkills ./_assets/agent/skill/by-role roleName
              ) { } (builtins.attrNames builtinRoles);
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
        }
        // lib.optionalAttrs ddd {
          "docs/wiki/design/ddd/artifact-driven.md" = {
            source = ./_assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md;
            copyMode = "copy";
          };
        };
      })

      # Combine accepted artifact issues with GitHub Actions and the selected project provider.
      (lib.mkIf artifactIssues {
        files = {
          ".github/workflows/accepted-artifact-issues.yml" = {
            text = workflow projectProvider (
              if projectProvider == "github-projects" then githubProjects.token-secret else ""
            );
            copyMode = "copy";
          };
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
        };
      })
    ];
}
