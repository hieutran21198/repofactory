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
    type = "local";
    command = [
      "npx"
      "-y"
      serverName
    ];
    environment.FIGMA_UI_MCP_TARGET = "Figma Desktop";
    enabled = true;
  };
  secondServer = {
    type = "local";
    command = [ "other" ];
    environment = { };
    enabled = false;
  };
  exploreModel = "example/model";

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
              opencode.settings = settings;
            };
          };
        };
      };
    }).config;

  assertionsPass = cfg: builtins.all (assertion: assertion.assertion) (cfg.assertions or [ ]);
  moduleSettings = cfg: cfg.factory.domain.agent.harness.opencode.settings or { };
  rendered = cfg: cfg.files.".opencode/opencode.jsonc".json;

  # Each activation input has one off case. The signal-off fixture keeps two unrelated values.
  offSignalSettings = {
    agent.explore.model = exploreModel;
    mcp."other-server" = secondServer;
  };
  offSignal = evalRaw {
    uses = [ "opencode" ];
    use = "figma";
    settings = offSignalSettings;
  };
  offUse = evalRaw {
    uses = [ "opencode" ];
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
    uses = [ "opencode" ];
    signal = true;
    use = "figma";
  };
  added = moduleSettings activePass1;
  canonicalAdded = added.mcp.${serverName} == canonicalServer;

  # Pass 2: the final merged settings hold the canonical entry, a second entry, and a model.
  active = evalRaw {
    uses = [ "opencode" ];
    signal = true;
    use = "figma";
    settings = {
      agent.explore.model = exploreModel;
      mcp = added.mcp // {
        "other-server" = secondServer;
      };
    };
  };
  activeRendered = rendered active;

  # A different same-name value must fail the final-value assertion.
  conflict = evalRaw {
    uses = [ "opencode" ];
    signal = true;
    use = "figma";
    settings.mcp.${serverName} = {
      type = "local";
      command = [ "different" ];
      environment = { };
      enabled = false;
    };
  };

  offRendered = rendered offSignal;
  offOmitsServer = builtins.all (cfg: !(builtins.hasAttr "mcp" (moduleSettings cfg))) offCases;
  offKeepsUnrelated =
    builtins.hasAttr "figma-ui-mcp" offRendered.mcp == false
    && offRendered.agent.explore.model == exploreModel
    && offRendered.mcp."other-server" == secondServer;
  offOmitsAssertions = builtins.all (cfg: (cfg.assertions or [ ]) == [ ]) offCases;

  activeRenderedFile = builtins.hasAttr ".opencode/opencode.jsonc" active.files;
  activeCanonicalInFile = activeRendered.mcp.${serverName} == canonicalServer;
  activeKeepsUnrelated =
    activeRendered.agent.explore.model == exploreModel
    && activeRendered.mcp."other-server" == secondServer;
  activeAssertionPasses = assertionsPass active;
  conflictAssertionFails = !(assertionsPass conflict);
in
assert canonicalAdded;
assert offOmitsServer;
assert offKeepsUnrelated;
assert offOmitsAssertions;
assert activeRenderedFile;
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
    activeCanonicalInFile
    activeKeepsUnrelated
    activeAssertionPasses
    conflictAssertionFails
    ;
}
