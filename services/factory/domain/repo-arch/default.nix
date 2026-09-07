{
  config,
  namespace,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.repo-arch = {
    use = _utils.mkEnumOpt {
      values = [
        "unset"
        "single"
        "multiple"
      ];
      description = "Repository architecture to use";
      default = "unset";
      internal = true;
    };
  };
}
