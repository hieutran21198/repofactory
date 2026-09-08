let
  lib = {
    # Merge the blocks into one config. The blocks share only the `files` key.
    mkMerge = builtins.foldl' (
      acc: block:
      acc
      // block
      // {
        files = (acc.files or { }) // (block.files or { });
      }
    ) { };
    mkIf = condition: value: if condition then value else { };
  };

  evalModule =
    method: architecture:
    (import ../default.nix {
      inherit lib;
      config.factory = {
        _utils = { };
        domain = {
          design.use = method;
          repo-arch.use = architecture;
        };
      };
      namespace = "factory";
    }).config;

  multiple = evalModule "ddd" "multiple";
  single = evalModule "ddd" "single";
  noArch = evalModule "ddd" "unset";
  off = evalModule "unset" "multiple";

  seeds = [
    "docs/domain/README.md"
    "docs/domain/context-map.md"
    "docs/domain/glossary.md"
  ];
  copies = [
    "docs/wiki/design/ddd/README.md"
    "docs/wiki/design/ddd/templates"
  ];
  all = builtins.sort builtins.lessThan (seeds ++ copies);

  hasMode = cfg: mode: name: cfg.files.${name}.copyMode == mode;
  sourceExists = cfg: name: builtins.pathExists cfg.files.${name}.source;
  sourceInTree =
    cfg: tree: name:
    cfg.files.${name}.source == ../_assets + "/${tree}/${name}";

  archTargets = builtins.all (cfg: builtins.attrNames cfg.files == all) [
    multiple
    single
  ];
  seedsAreSeed = builtins.all (cfg: builtins.all (hasMode cfg "seed") seeds) [
    multiple
    single
    noArch
  ];
  copiesAreCopy = builtins.all (cfg: builtins.all (hasMode cfg "copy") copies) [
    multiple
    single
  ];
  sourcesExist = builtins.all (cfg: builtins.all (sourceExists cfg) (builtins.attrNames cfg.files)) [
    multiple
    single
    noArch
  ];
  multipleTree = builtins.all (sourceInTree multiple "multiple") copies;
  singleTree = builtins.all (sourceInTree single "single") copies;
  noArchSeedsOnly = builtins.attrNames noArch.files == builtins.sort builtins.lessThan seeds;
  offOmitsFiles = noArch.files != null && off.files == { };

  # A guide of one architecture does not name the directory of the other architecture.
  guide = cfg: builtins.readFile cfg.files."docs/wiki/design/ddd/README.md".source;
  multipleNamesServices =
    builtins.match ".*`services/`.*" (guide multiple) != null && builtins.match ".*`src/`.*" (guide multiple) == null;
  singleNamesSrc =
    builtins.match ".*`src/`.*" (guide single) != null && builtins.match ".*`services/`.*" (guide single) == null;
in
assert archTargets;
assert seedsAreSeed;
assert copiesAreCopy;
assert sourcesExist;
assert multipleTree;
assert singleTree;
assert noArchSeedsOnly;
assert offOmitsFiles;
assert multipleNamesServices;
assert singleNamesSrc;
{
  inherit
    archTargets
    seedsAreSeed
    copiesAreCopy
    sourcesExist
    multipleTree
    singleTree
    noArchSeedsOnly
    offOmitsFiles
    multipleNamesServices
    singleNamesSrc
    ;
}
