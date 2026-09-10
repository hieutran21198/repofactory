{
  config,
  namespace,
  lib,
  ...
}:
{
  options.${namespace}.domain.agent.harness.claude = {
    settings = lib.mkOption {
      type = lib.types.json;
      default = { };
    };
  };

  config =
    let
      inherit (config.${namespace}.domain) agent;
      inherit (agent.harness) claude;
    in
    lib.mkIf (builtins.elem "claude" agent.harness.uses) {
      files.".claude/config.json" = {
        copyMode = "copy";
        json = {
          attribution = {
            commit = "";
            pr = "";
          };
        };
      }
      // claude.settings;
    };
}
