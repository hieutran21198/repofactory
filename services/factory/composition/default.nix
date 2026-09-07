{
  config,
  namespace,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
}
