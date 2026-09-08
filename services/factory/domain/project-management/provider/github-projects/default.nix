{ config, namespace, ... }:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.project-management.provider.github-projects = {
    ownership = _utils.mkEnumOpt {
      values = [
        "personal"
        "organization"
      ];
      default = "personal";
    };
    owner = _utils.mkStrOpt {
      default = "";
      description = "Owner login of the GitHub Project";
    };
    project-number = _utils.mkIntOpt {
      default = 0;
      description = "Number of the GitHub Project";
    };
    token-secret = _utils.mkStrOpt {
      default = "PROJECTS_TOKEN";
      description = "GitHub Actions secret that contains the Projects token";
    };
  };
}
