{
  config,
  namespace,
  lib,
  ...
}:
let
  model = "artifact-driven";
in
{
  config =
    let
      inherit (config.${namespace}.domain) repo-arch documentation design;
      ddd = design.use == "ddd";
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
    ];
}
