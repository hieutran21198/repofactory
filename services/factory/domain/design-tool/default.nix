{
  config,
  namespace,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.design-tool = {
    use = _utils.mkEnumOpt {
      values = [
        "unset"
        "figma"
        "pencil"
      ];
      default = "unset";
      description = "Design tool to use";
    };
  };
}
