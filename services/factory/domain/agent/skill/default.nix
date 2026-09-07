{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.agent.skill = {
    general = _utils.mkAttrsOpt {
      ofType = lib.types.path;
      description = "Path to skill folder; will be used for all harness tools";
      default = { };
    };
    builtins = lib.genAttrs [ "asd-ste-100" ] (name: {
      enable = _utils.mkBoolOpt {
        default = true;
        description = "Whether to enable the builtin skill ${name}";
      };
      path = _utils.mkPathOpt {
        default = ./_assets/${name};
        description = "Path to the folder of the builtin skill ${name}";
      };
    });
  };
  config =
    let
      inherit (config.${namespace}.domain.agent) harness skill;

      enabledBuiltinSkills = lib.mapAttrs' (name: opts: {
        inherit name;
        value = opts.path;
      }) (lib.filterAttrs (_: s: s.enable) skill.builtins);
    in
    lib.mkMerge [
      (lib.mkIf (builtins.elem "claude" harness.uses) {
        files = lib.mapAttrs' (name: path: {
          name = ".claude/skills/${name}";
          value = {
            source = path;
            copyMode = "copy";
          };
        }) (skill.general // enabledBuiltinSkills);
      })

      (lib.mkIf (lib.intersectLists [ "codex" "opencode" ] harness.uses != [ ]) {
        files = lib.mapAttrs' (name: path: {
          name = ".agents/skills/${name}";
          value = {
            source = path;
            copyMode = "copy";
          };
        }) (skill.general // enabledBuiltinSkills);
      })
    ];
}
