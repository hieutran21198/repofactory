{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.ci-cd.provider.azure-pipelines = {
    folder = _utils.mkStrOpt {
      default = "azure-pipelines";
      description = "The repository folder that holds the Azure pipelines";
    };
  };

  config =
    let
      inherit (config.${namespace}.domain) ci-cd;
      folder = ci-cd.provider.azure-pipelines.folder;
      optionName = "${namespace}.domain.ci-cd.provider.azure-pipelines.folder";
      # The separator is not a segment. Keep only the string parts of the split.
      segments = builtins.filter builtins.isString (builtins.split "/" folder);
      hasSegment = value: builtins.any (segment: segment == value) segments;
    in
    {
      # The folder is valid for every CI provider selection. A folder error stops
      # evaluation before the factory emits a blueprint file.
      assertions = [
        {
          assertion = folder != "";
          message = "${optionName} must not be empty";
        }
        {
          assertion = builtins.substring 0 1 folder != "/";
          message = "${optionName} must not start with \"/\"";
        }
        {
          assertion = !hasSegment "";
          message = "${optionName} must not contain an empty path segment";
        }
        {
          assertion = !hasSegment ".";
          message = "${optionName} must not contain a \".\" path segment";
        }
        {
          assertion = !hasSegment "..";
          message = "${optionName} must not contain a \"..\" path segment";
        }
        {
          assertion = builtins.length (builtins.split "\\\\" folder) == 1;
          message = "${optionName} must not contain a backslash";
        }
      ];
    }
    // lib.mkIf (ci-cd.provider.use == "azure-pipelines") { };
}
