{
  config,
  namespace,
  lib,
  ...
}:
let
  model = "artifact-driven";
  inherit (config.${namespace}) _utils;
in
{
  config =
    let
      inherit (config.${namespace}.domain) repo-arch documentation;
    in
    lib.mkMerge [
      # agent
      (lib.mkIf (documentation.use == model) {
        ${namespace}.domain = {
          agent =
            let
              mkRole = name: description: {
                inherit description;
                instruction = builtins.readFile ./_assets/agent/role/${name}/ROLE.md;
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
          "AGENTS.md".source = lib.mkForce ./_assets/AGENTS.md;
          "docs/README.md".source = lib.mkForce ./_assets/docs/README.md;
          "docs/wiki/README.md".source = lib.mkForce ./_assets/docs/wiki/README.md;
        };
      })

      # Combine the documentation model with the repo-arch seeds.
      (lib.mkIf (documentation.use == model && repo-arch.use == "single") {
        # TODO: implement me
      })
    ];
}
