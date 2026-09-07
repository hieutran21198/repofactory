{
  config,
  namespace,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.design = {
    use = _utils.mkEnumOpt {
      values = [
        "unset"
        "ddd"
      ];
      default = "unset";
      description = "Design method to use";
    };
  };
}
