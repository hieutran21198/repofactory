let
  namespace = "factory";
  lib = (import <nixpkgs> { }).lib;

  # The real option builders. The test does not change libs/nix/options.
  utils =
    (import ../../../../../libs/nix/options/default.nix {
      inherit lib namespace;
    }).${namespace}._utils;

  # The imported module is used only for the structure checks. It declares no config.
  designToolModule = import ../default.nix {
    inherit lib namespace;
    config.${namespace}._utils = utils;
  };

  # The real module system evaluates each accepted value and rejects an unsupported value.
  evalWith =
    use:
    lib.evalModules {
      specialArgs = { inherit namespace; };
      modules = [
        ../../../../../libs/nix/default.nix
        ../../../../../libs/nix/options/default.nix
        ../default.nix
        { config.${namespace}.domain.design-tool.use = use; }
      ];
    };

  option = designToolModule.options.${namespace}.domain.design-tool.use;
  # The enum type carries its permitted values in the functor payload.
  optionValues = option.type.functor.payload.values;
  acceptedUnset = (evalWith "unset").config.${namespace}.domain.design-tool.use == "unset";
  acceptedFigma = (evalWith "figma").config.${namespace}.domain.design-tool.use == "figma";
  unsupportedRejected =
    !(builtins.tryEval (evalWith "sketch").config.${namespace}.domain.design-tool.use).success;

  valuesAreUnsetAndFigma =
    optionValues == [
      "unset"
      "figma"
    ];
  defaultIsUnset = option.default == "unset";
  declaresOnlyUse =
    builtins.attrNames designToolModule.options.${namespace}.domain.design-tool == [ "use" ];
  emitsNoConfig = !(designToolModule ? config);
in
assert valuesAreUnsetAndFigma;
assert defaultIsUnset;
assert declaresOnlyUse;
assert emitsNoConfig;
assert acceptedUnset;
assert acceptedFigma;
assert unsupportedRejected;
{
  inherit
    valuesAreUnsetAndFigma
    defaultIsUnset
    declaresOnlyUse
    emitsNoConfig
    acceptedUnset
    acceptedFigma
    unsupportedRejected
    ;
}
