{
  config,
  namespace,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.ci-cd.provider = {
    use = _utils.mkEnumOpt {
      values = [
        "unset"
        "github-actions"
      ];
      default = "unset";
    };
  };
}
