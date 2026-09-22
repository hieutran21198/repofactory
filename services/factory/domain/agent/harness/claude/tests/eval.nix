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
  canonicalPencilServer = {
    type = "stdio";
    command = "pencil";
    args = [ ];
    env = { };
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
  hasPencilEntry = cfg: builtins.hasAttr "pencil" (moduleServer cfg);

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

  # Each Pencil activation input has one off case.
  pencilOffHarness = evalRaw {
    signal = true;
    use = "pencil";
  };
  pencilOffSignal = evalRaw {
    uses = [ "claude" ];
    use = "pencil";
  };
  pencilOffUse = evalRaw {
    uses = [ "claude" ];
    signal = true;
    use = "unset";
  };
  pencilOffCases = [
    pencilOffHarness
    pencilOffSignal
    pencilOffUse
  ];

  # Pass 1: the module adds only the canonical nested Pencil entry.
  pencilPass1 = evalRaw {
    uses = [ "claude" ];
    signal = true;
    use = "pencil";
  };
  pencilAdded = moduleServer pencilPass1;
  pencilEntry = pencilAdded.pencil;
  pencilCanonicalAdded = pencilEntry == canonicalPencilServer;

  # Pass 2: the final merged mcp-servers holds the canonical Pencil entry and a second entry.
  activePencil = evalRaw {
    uses = [ "claude" ];
    signal = true;
    use = "pencil";
    mcpServers = pencilAdded // {
      "other-server" = secondServer;
    };
  };
  activePencilFile = activePencil.files.".mcp.json";

  # A different same-name Pencil value must fail the final-value assertion.
  conflictPencil = evalRaw {
    uses = [ "claude" ];
    signal = true;
    use = "pencil";
    mcpServers = {
      pencil = {
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

  # Pencil off cases: no module-owned entry, no rendered file, no assertions.
  pencilOffOmitsEntry = builtins.all (cfg: !(hasPencilEntry cfg)) pencilOffCases;
  pencilOffOmitsFile = builtins.all (cfg: !(hasMcpFile cfg)) pencilOffCases;
  pencilOffOmitsAssertions = builtins.all (cfg: (cfg.assertions or [ ]) == [ ]) pencilOffCases;

  # Pencil active: exact canonical entry, stdio transport, no forbidden field.
  pencilKeysExact =
    builtins.attrNames pencilEntry == [
      "args"
      "command"
      "env"
      "type"
    ];
  pencilTransportStdio = pencilEntry.type == "stdio";
  pencilEmptyArgsAndEnv = pencilEntry.args == [ ] && pencilEntry.env == { };
  pencilNoForbiddenFields =
    !(pencilEntry ? url)
    && !(pencilEntry ? document)
    && !(pencilEntry ? repository)
    && !(pencilEntry ? remote)
    && !(pencilEntry ? filesystem);

  # Pencil active: render, copy mode, two entries, preservation, assertion, conflict.
  activePencilRendersFile = hasMcpFile activePencil;
  activePencilCopyMode = activePencilFile.copyMode == "copy";
  activePencilRendersTwoServers =
    builtins.length (builtins.attrNames activePencilFile.json.mcpServers) == 2;
  activePencilCanonicalInFile = activePencilFile.json.mcpServers.pencil == canonicalPencilServer;
  activePencilOtherServerKept = activePencilFile.json.mcpServers."other-server" == secondServer;
  activePencilAssertionPasses = assertionsPass activePencil;
  conflictPencilAssertionFails = !(assertionsPass conflictPencil);

  # Cross-exclusion: figma adds no pencil, pencil adds no figma.
  figmaAddsNoPencil =
    !(hasPencilEntry activePass1) && !(builtins.hasAttr "pencil" activeFile.json.mcpServers);
  pencilAddsNoFigma =
    !(builtins.hasAttr "figma-ui-mcp" pencilAdded)
    && !(builtins.hasAttr "figma-ui-mcp" activePencilFile.json.mcpServers);
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
assert pencilOffOmitsEntry;
assert pencilOffOmitsFile;
assert pencilOffOmitsAssertions;
assert pencilCanonicalAdded;
assert pencilKeysExact;
assert pencilTransportStdio;
assert pencilEmptyArgsAndEnv;
assert pencilNoForbiddenFields;
assert activePencilRendersFile;
assert activePencilCopyMode;
assert activePencilRendersTwoServers;
assert activePencilCanonicalInFile;
assert activePencilOtherServerKept;
assert activePencilAssertionPasses;
assert conflictPencilAssertionFails;
assert figmaAddsNoPencil;
assert pencilAddsNoFigma;
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
    pencilOffOmitsEntry
    pencilOffOmitsFile
    pencilOffOmitsAssertions
    pencilCanonicalAdded
    pencilKeysExact
    pencilTransportStdio
    pencilEmptyArgsAndEnv
    pencilNoForbiddenFields
    activePencilRendersFile
    activePencilCopyMode
    activePencilRendersTwoServers
    activePencilCanonicalInFile
    activePencilOtherServerKept
    activePencilAssertionPasses
    conflictPencilAssertionFails
    figmaAddsNoPencil
    pencilAddsNoFigma
    ;
}
