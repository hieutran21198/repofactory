{
  config,
  namespace,
  lib,
  ...
}:
{
  options.${namespace}.domain.agent.harness.claude = {
  };

  config =
    let
      inherit (config.${namespace}.domain) agent;
      inherit (agent.harness) claude;
    in
    lib.mkIf (builtins.elem "claude" agent.harness.uses) { };
}
