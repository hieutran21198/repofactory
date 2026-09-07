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

  multiple = evalModule "multiple";
  single = evalModule "single";
  e2eSeed = multiple.files."e2e/README.md";
in
assert e2eSeed.copyMode == "seed";
assert builtins.pathExists e2eSeed.source;
assert !builtins.hasAttr "e2e/README.md" (single.files or { });
{
  copyMode = e2eSeed.copyMode;
  sourceExists = builtins.pathExists e2eSeed.source;
  singleArchitectureOmitsSeed = !builtins.hasAttr "e2e/README.md" (single.files or { });
}
