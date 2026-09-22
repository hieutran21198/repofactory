let
  optionUtils = {
    mkBoolOpt = inputs: inputs;
    mkStrOpt = inputs: inputs;
    mkIntOpt = inputs: inputs;
    mkEnumOpt = inputs: inputs;
    mkListOpt = inputs: inputs;
    mkAttrsOpt = inputs: inputs;
  };

  # The local stub merges the blocks of the module. It proves key selection and values only.
  # The real module system in task-verify proves the merged value, the conflict, and the render.
  lib = {
    mkMerge = builtins.foldl' (
      acc: block:
      acc
      // block
      // {
        files = (acc.files or { }) // (block.files or { });
        assertions = (acc.assertions or [ ]) ++ (block.assertions or [ ]);
      }
    ) { };
    mkIf = condition: value: if condition then value else { };
    mkOption = value: value;
    types = {
      json = null;
      toml = null;
    };
  };

  serverName = "figma-ui-mcp";
  canonicalServer = {
    command = "npx";
    args = [
      "-y"
      serverName
    ];
    env.FIGMA_UI_MCP_TARGET = "Figma Desktop";
  };
  secondServer = {
    command = "other";
  };

  evalRaw =
    {
      uses ? [ ],
      signal ? false,
      use ? "unset",
      mcpServers ? { },
      claudeSettings ? { },
    }:
    (import ../default.nix {
      inherit lib;
      namespace = "factory";
      config.factory = {
        _utils = optionUtils;
        domain = {
          design-tool.use = use;
          agent = {
            harness = {
              uses = uses;
              ux-design.enable = signal;
              claude = {
                settings = claudeSettings;
                mcp-servers = mcpServers;
              };
            };
          };
        };
      };
    }).config;

  assertionsPass = cfg: builtins.all (assertion: assertion.assertion) (cfg.assertions or [ ]);
  moduleServer = cfg: cfg.factory.domain.agent.harness.claude.mcp-servers or { };
  hasMcpFile = cfg: builtins.hasAttr ".mcp.json" (cfg.files or { });

  # Each activation input has one off case.
  offSignal = evalRaw {
    uses = [ "claude" ];
    use = "figma";
  };
  offUse = evalRaw {
    uses = [ "claude" ];
    signal = true;
  };
  offHarness = evalRaw {
    signal = true;
    use = "figma";
  };
  offCases = [
    offSignal
    offUse
    offHarness
  ];

  # Pass 1: the module adds only the canonical nested entry.
  activePass1 = evalRaw {
    uses = [ "claude" ];
    signal = true;
    use = "figma";
  };
  added = moduleServer activePass1;
  canonicalAdded = added.${serverName} == canonicalServer;

  # Pass 2: the final merged mcp-servers holds the canonical entry and a second entry.
  active = evalRaw {
    uses = [ "claude" ];
    signal = true;
    use = "figma";
    mcpServers = added // {
      "other-server" = secondServer;
    };
  };
  activeFile = active.files.".mcp.json";

  # A different same-name value must fail the final-value assertion.
  conflict = evalRaw {
    uses = [ "claude" ];
    signal = true;
    use = "figma";
    mcpServers = {
      ${serverName} = {
        command = "different";
      };
    };
  };

  offOmitsServer = builtins.all (cfg: moduleServer cfg == { }) offCases;
  offOmitsFile = builtins.all (cfg: !(hasMcpFile cfg)) offCases;
  offOmitsAssertions = builtins.all (cfg: (cfg.assertions or [ ]) == [ ]) offCases;

  activeRendersFile = hasMcpFile active;
  activeCopyMode = activeFile.copyMode == "copy";
  activeRendersTwoServers = builtins.length (builtins.attrNames activeFile.json.mcpServers) == 2;
  activeCanonicalInFile = activeFile.json.mcpServers.${serverName} == canonicalServer;
  activeOtherServerKept = activeFile.json.mcpServers."other-server" == secondServer;
  activeSettingsSeparate =
    builtins.hasAttr ".claude/settings.json" active.files
    && activeFile.json ? mcpServers
    && !(activeFile.json ? attribution)
    && !(builtins.hasAttr ".mcp.json" (active.files.".claude/settings.json" or { }));
  activeSettingsUnchanged =
    active.files.".claude/settings.json".json == {
      attribution = {
        commit = "";
        pr = "";
      };
    };

  activeAssertionPasses = assertionsPass active;
  conflictAssertionFails = !(assertionsPass conflict);
in
assert canonicalAdded;
assert offOmitsServer;
assert offOmitsFile;
assert offOmitsAssertions;
assert activeRendersFile;
assert activeCopyMode;
assert activeRendersTwoServers;
assert activeCanonicalInFile;
assert activeOtherServerKept;
assert activeSettingsSeparate;
assert activeSettingsUnchanged;
assert activeAssertionPasses;
assert conflictAssertionFails;
{
  inherit
    canonicalAdded
    offOmitsServer
    offOmitsFile
    offOmitsAssertions
    activeRendersFile
    activeCopyMode
    activeRendersTwoServers
    activeCanonicalInFile
    activeOtherServerKept
    activeSettingsSeparate
    activeSettingsUnchanged
    activeAssertionPasses
    conflictAssertionFails
    ;
}
