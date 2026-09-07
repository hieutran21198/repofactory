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
  options.${namespace}.domain.agent.harness = {
    uses = _utils.mkListOpt {
      ofType = lib.types.enum [
        "claude"
        "codex"
        "opencode"
      ];
      default = [ ];
      description = "The harnesses to use for the agent.";
    };
  };
}
