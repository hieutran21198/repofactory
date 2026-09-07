let
  evalModule =
    method:
    (import ../default.nix {
      config.factory = {
        _utils = { };
        domain.design.use = method;
      };
      namespace = "factory";
      lib.mkIf = condition: value: if condition then value else { };
    }).config;

  ddd = evalModule "ddd";
  unset = evalModule "unset";

  copies = [
    "docs/wiki/design/ddd/README.md"
    "docs/wiki/design/ddd/templates"
  ];
  seeds = [
    "docs/domain/README.md"
    "docs/domain/context-map.md"
    "docs/domain/glossary.md"
  ];
  all = copies ++ seeds;

  hasMode = mode: name: ddd.files.${name}.copyMode == mode;
  sourceExists = name: builtins.pathExists ddd.files.${name}.source;
in
assert builtins.attrNames ddd.files == builtins.sort builtins.lessThan all;
assert builtins.all (hasMode "copy") copies;
assert builtins.all (hasMode "seed") seeds;
assert builtins.all sourceExists all;
assert !(builtins.hasAttr "files" unset);
{
  targets = builtins.attrNames ddd.files;
  copiesAreCopy = builtins.all (hasMode "copy") copies;
  seedsAreSeed = builtins.all (hasMode "seed") seeds;
  sourcesExist = builtins.all sourceExists all;
  unsetOmitsFiles = !(builtins.hasAttr "files" unset);
}
