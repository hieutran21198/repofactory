let
  evalModule =
    architecture:
    (import ../default.nix {
      config.factory = {
        _utils = { };
        domain.repo-arch.use = architecture;
      };
      namespace = "factory";
      lib.mkIf = condition: value: if condition then value else { };
    }).config;

  evalMultiple =
    architecture:
    (import ../../multiple/default.nix {
      config.factory = {
        _utils = { };
        domain.repo-arch.use = architecture;
      };
      namespace = "factory";
      lib.mkIf = condition: value: if condition then value else { };
    }).config;

  single = evalModule "single";
  unset = evalModule "unset";
  multiple = evalMultiple "multiple";

  seeds = [
    "AGENTS.md"
    "README.md"
    "deployment/README.md"
    "docs/README.md"
    "docs/wiki/README.md"
    "docs/wiki/repo-arch/single-repository.md"
    "src/README.md"
    "tests/README.md"
  ];
  singleOnly = [
    "src/README.md"
    "tests/README.md"
  ];

  isSeed = name: single.files.${name}.copyMode == "seed";
  sourceExists = name: builtins.pathExists single.files.${name}.source;

  targetsMatch = builtins.attrNames single.files == builtins.sort builtins.lessThan seeds;
  allSeeds = builtins.all isSeed seeds;
  sourcesExist = builtins.all sourceExists seeds;
  unsetOmitsFiles = !(builtins.hasAttr "files" unset);
  singleOmitsE2e = !(builtins.hasAttr "e2e/README.md" single.files);
  multipleOmitsSingleOnly = builtins.all (name: !(builtins.hasAttr name multiple.files)) singleOnly;
in
assert targetsMatch;
assert allSeeds;
assert sourcesExist;
assert unsetOmitsFiles;
assert singleOmitsE2e;
assert multipleOmitsSingleOnly;
{
  targets = builtins.attrNames single.files;
  inherit
    allSeeds
    sourcesExist
    unsetOmitsFiles
    singleOmitsE2e
    multipleOmitsSingleOnly
    ;
}
