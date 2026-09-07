{
  namespace,
  lib,
  ...
}:
{
  options.${namespace} = {
    _utils = lib.mkOption {
      type = with lib.types; attrsOf anything;
      description = "Utilities for ${namespace}";
    };
  };
}
