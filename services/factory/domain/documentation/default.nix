{
  config,
  namespace,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.documentation = {
    use = _utils.mkEnumOpt {
      values = [
        "unset"
        "artifact-driven"
      ];
      default = "unset";
      description = "Documentation model to use";
    };
  };
}
