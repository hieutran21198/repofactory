{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
  inherit (config.${namespace}.domain) agent;
  inherit (agent.harness) codex;
  designTool = config.${namespace}.domain.design-tool.use;
  uxDesign = agent.harness.ux-design.enable;
  serverName = "figma-ui-mcp";
  # The bridge targets the plugin that runs inside Figma Desktop.
  canonicalServer = {
    command = "npx";
    args = [
      "-y"
      serverName
    ];
    env = {
      FIGMA_UI_MCP_TARGET = "Figma Desktop";
    };
  };
  # The adapter is active only for a selected Codex harness, the internal UX Design signal, and figma.
  active = builtins.elem "codex" agent.harness.uses && uxDesign && designTool == "figma";

  # The pen.dev adapter uses the portable launcher and the open .pen document.
  pencilServerName = "pencil";
  canonicalPencilServer = {
    command = "pen-mcp-server";
    args = [
      "--app"
      "desktop"
    ];
  };
  # The adapter is active only for a selected Codex harness, the internal UX Design signal, and pencil.
  pencilActive = builtins.elem "codex" agent.harness.uses && uxDesign && designTool == "pencil";
in
{
  options.${namespace}.domain.agent.harness.codex = {
    settings = _utils.mkAttrsOpt {
      ofType = lib.types.toml;
      default = { };
      description = "Codex configuration; rendered to .codex/config.toml. Definitions from several modules deep-merge.";
    };
  };

  config = lib.mkMerge [
    # The file gate stays separate from the entry gate. It reads the final settings value.
    (lib.mkIf (builtins.elem "codex" agent.harness.uses && codex.settings != { }) {
      files.".codex/config.toml" = {
        toml = codex.settings;
        copyMode = "copy";
      };
    })

    # The entry gate uses the three activation inputs only. It does not read codex.settings.
    (lib.mkIf active {
      ${namespace}.domain.agent.harness.codex.settings.mcp_servers.${serverName} = canonicalServer;
      assertions = [
        {
          assertion = codex.settings.mcp_servers.${serverName} == canonicalServer;
          message = "${namespace}.domain.agent.harness.codex.settings.mcp_servers.\"${serverName}\" must equal the canonical Figma MCP server when the Codex adapter is active";
        }
      ];
    })

    # The Pencil entry gate uses the three activation inputs only. It does not read codex.settings.
    (lib.mkIf pencilActive {
      ${namespace}.domain.agent.harness.codex.settings.mcp_servers.${pencilServerName} =
        canonicalPencilServer;
      assertions = [
        {
          assertion = codex.settings.mcp_servers.${pencilServerName} == canonicalPencilServer;
          message = "${namespace}.domain.agent.harness.codex.settings.mcp_servers.\"${pencilServerName}\" must equal the canonical Pencil MCP server when the Codex adapter is active";
        }
      ];
    })
  ];
}
