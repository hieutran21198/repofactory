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
  };

  config =
    let
      inherit (config.${namespace}.domain) agent;
      inherit (agent.harness) opencode;
    in
    lib.mkIf (builtins.elem "opencode" agent.harness.uses) { };
}
