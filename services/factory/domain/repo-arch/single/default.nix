{
  config,
  namespace,
  lib,
  ...
}:
let
  arch = "single";
  inherit (config.${namespace}) _utils;
in
{
  config =
    let
      inherit (config.${namespace}.domain) repo-arch;
      modCfg = repo-arch.${arch};
    in
    lib.mkIf (repo-arch.use == arch) {
    };
}
