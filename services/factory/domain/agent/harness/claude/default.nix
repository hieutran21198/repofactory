{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
  inherit (config.${namespace}.domain) agent;
  inherit (agent.harness) claude;
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
  # The adapter is active only for a selected Claude harness, the internal UX Design signal, and figma.
  active = builtins.elem "claude" agent.harness.uses && uxDesign && designTool == "figma";

  # The pen.dev adapter uses the portable launcher and the open .pen document.
  pencilServerName = "pencil";
  canonicalPencilServer = {
    type = "stdio";
    command = "pencil";
    args = [ ];
    env = { };
  };
  # The adapter is active only for a selected Claude harness, the internal UX Design signal, and pencil.
  pencilActive = builtins.elem "claude" agent.harness.uses && uxDesign && designTool == "pencil";
in
{
  options.${namespace}.domain.agent.harness.claude = {
    settings = lib.mkOption {
      type = lib.types.json;
      default = { };
    };
    mcp-servers = _utils.mkAttrsOpt {
      ofType = lib.types.json;
      default = { };
      description = "Claude project MCP servers; rendered to .mcp.json as mcpServers. Definitions from several modules deep-merge.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (builtins.elem "claude" agent.harness.uses) {
      files.".claude/settings.json" = {
        copyMode = "copy";
        json = {
          attribution = {
            commit = "";
            pr = "";
          };
        };
      }
      // claude.settings;
    })

    # The entry gate uses the three activation inputs only. It does not read mcp-servers.
    (lib.mkIf active {
      ${namespace}.domain.agent.harness.claude.mcp-servers.${serverName} = canonicalServer;
      assertions = [
        {
          assertion = claude.mcp-servers.${serverName} == canonicalServer;
          message = "${namespace}.domain.agent.harness.claude.mcp-servers.\"${serverName}\" must equal the canonical Figma MCP server when the Claude adapter is active";
        }
      ];
    })

    # The Pencil entry gate uses the three activation inputs only. It does not read mcp-servers.
    (lib.mkIf pencilActive {
      ${namespace}.domain.agent.harness.claude.mcp-servers.${pencilServerName} = canonicalPencilServer;
      assertions = [
        {
          assertion = claude.mcp-servers.${pencilServerName} == canonicalPencilServer;
          message = "${namespace}.domain.agent.harness.claude.mcp-servers.\"${pencilServerName}\" must equal the canonical Pencil MCP server when the Claude adapter is active";
        }
      ];
    })

    # The file gate is separate. Any non-empty final mcp-servers value renders one .mcp.json.
    (lib.mkIf (claude.mcp-servers != { }) {
      files.".mcp.json" = {
        copyMode = "copy";
        json.mcpServers = claude.mcp-servers;
      };
    })
  ];
}
