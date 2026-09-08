{
  config,
  namespace,
  lib,
  ...
}:
{
  options.${namespace}.domain.ci-cd.provider.github-actions = {
  };

  config =
    let
      inherit (config.${namespace}.domain) ci-cd;
    in
    lib.mkIf (ci-cd.provider.use == "github-actions") { };
}
