{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
  inherit (config.${namespace}.domain) agent;
  inherit (agent.harness) opencode;
  designTool = config.${namespace}.domain.design-tool.use;
  uxDesign = agent.harness.ux-design.enable;
  serverName = "figma-ui-mcp";
  # The bridge targets the plugin that runs inside Figma Desktop.
  canonicalServer = {
    type = "local";
    command = [
      "npx"
      "-y"
      serverName
    ];
    environment = {
      FIGMA_UI_MCP_TARGET = "Figma Desktop";
    };
    enabled = true;
  };
  # The adapter is active only for a selected OpenCode harness, the internal UX Design signal, and figma.
  active = builtins.elem "opencode" agent.harness.uses && uxDesign && designTool == "figma";
in
{
  options.${namespace}.domain.agent.harness.opencode = {
    settings = _utils.mkAttrsOpt {
      ofType = lib.types.json;
      default = { };
      description = "JSON configuration";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (builtins.elem "opencode" agent.harness.uses) {
      files.".opencode/opencode.jsonc".json = opencode.settings;
    })

    # Add only the nested figma-ui-mcp entry. The entry gate does not read settings.
    (lib.mkIf active {
      ${namespace}.domain.agent.harness.opencode.settings.mcp.${serverName} = canonicalServer;
      assertions = [
        {
          assertion = opencode.settings.mcp.${serverName} == canonicalServer;
          message = "${namespace}.domain.agent.harness.opencode.settings.mcp.\"${serverName}\" must equal the canonical Figma MCP server when the OpenCode adapter is active";
        }
      ];
    })
  ];
}
