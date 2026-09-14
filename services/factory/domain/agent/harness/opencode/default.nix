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
  options.${namespace}.domain.agent.harness.opencode = {
    settings = _utils.mkAttrsOpt {
      ofType = lib.types.json;
      default = { };
      description = "JSON configuration";
    };
  };

  config =
    let
      inherit (config.${namespace}.domain) agent;
      inherit (agent.harness) opencode;
    in
    lib.mkIf (builtins.elem "opencode" agent.harness.uses) {
      files.".opencode/opencode.jsonc".json = opencode.settings;
    };
}
