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
    args = [ ];
    env = { };
  };
  unrelatedSetting = "kept";

  evalRaw =
    {
      uses ? [ ],
      signal ? false,
      use ? "unset",
      settings ? { },
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
              codex.settings = settings;
            };
          };
        };
      };
    }).config;

  assertionsPass = cfg: builtins.all (assertion: assertion.assertion) (cfg.assertions or [ ]);
  moduleSettings = cfg: cfg.factory.domain.agent.harness.codex.settings or { };
  rendered = cfg: cfg.files.".codex/config.toml".toml;

  # Each activation input has one off case. The signal-off fixture keeps two unrelated values.
  offSignalSettings = {
    unrelated = unrelatedSetting;
    mcp_servers."other-server" = secondServer;
  };
  offSignal = evalRaw {
    uses = [ "codex" ];
    use = "figma";
    settings = offSignalSettings;
  };
  offUse = evalRaw {
    uses = [ "codex" ];
    signal = true;
    settings = offSignalSettings;
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
    uses = [ "codex" ];
    signal = true;
    use = "figma";
  };
  added = moduleSettings activePass1;
  canonicalAdded = added.mcp_servers.${serverName} == canonicalServer;

  # Pass 2: the final merged settings hold the canonical entry, a second entry, and a setting.
  active = evalRaw {
    uses = [ "codex" ];
    signal = true;
    use = "figma";
    settings = {
      unrelated = unrelatedSetting;
      mcp_servers = added.mcp_servers // {
        "other-server" = secondServer;
      };
    };
  };
  activeRendered = rendered active;

  # A different same-name value must fail the final-value assertion.
  conflict = evalRaw {
    uses = [ "codex" ];
    signal = true;
    use = "figma";
    settings = {
      unrelated = unrelatedSetting;
      mcp_servers.${serverName} = {
        command = "different";
      };
    };
  };

  offRendered = rendered offSignal;
  offOmitsServer = builtins.all (
    cfg: !(builtins.hasAttr "mcp_servers" (moduleSettings cfg))
  ) offCases;
  offKeepsUnrelated =
    builtins.hasAttr serverName offRendered.mcp_servers == false
    && offRendered.unrelated == unrelatedSetting
    && offRendered.mcp_servers."other-server" == secondServer;
  offOmitsAssertions = builtins.all (cfg: (cfg.assertions or [ ]) == [ ]) offCases;

  activeRenderedFile = builtins.hasAttr ".codex/config.toml" active.files;
  activeCopyMode = active.files.".codex/config.toml".copyMode == "copy";
  activeCanonicalInFile = activeRendered.mcp_servers.${serverName} == canonicalServer;
  activeKeepsUnrelated =
    activeRendered.unrelated == unrelatedSetting
    && activeRendered.mcp_servers."other-server" == secondServer;
  activeAssertionPasses = assertionsPass active;
  conflictAssertionFails = !(assertionsPass conflict);
in
assert canonicalAdded;
assert offOmitsServer;
assert offKeepsUnrelated;
assert offOmitsAssertions;
assert activeRenderedFile;
assert activeCopyMode;
assert activeCanonicalInFile;
assert activeKeepsUnrelated;
assert activeAssertionPasses;
assert conflictAssertionFails;
{
  inherit
    canonicalAdded
    offOmitsServer
    offKeepsUnrelated
    offOmitsAssertions
    activeRenderedFile
    activeCopyMode
    activeCanonicalInFile
    activeKeepsUnrelated
    activeAssertionPasses
    conflictAssertionFails
    ;
}
