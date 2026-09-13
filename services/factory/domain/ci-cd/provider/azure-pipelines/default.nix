{
  config,
  namespace,
  lib,
  ...
}:
{
  options.${namespace}.domain.ci-cd.provider.azure-pipelines = {
  };

  config =
    let
      inherit (config.${namespace}.domain) ci-cd;
    in
    lib.mkIf (ci-cd.provider.use == "azure-pipelines") { };
}
