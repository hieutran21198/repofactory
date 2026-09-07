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
  options.${namespace}.domain.agent.harness.codex = {
    settings = _utils.mkAttrsOpt {
      ofType = lib.types.toml;
      default = { };
      description = "Codex configuration; rendered to .codex/config.toml. Definitions from several modules deep-merge.";
    };
  };

  config =
    let
      inherit (config.${namespace}.domain) agent;
      inherit (agent.harness) codex;
    in
    lib.mkIf (builtins.elem "codex" agent.harness.uses && codex.settings != { }) {
      files.".codex/config.toml" = {
        toml = codex.settings;
        copyMode = "copy";
      };
    };
}
