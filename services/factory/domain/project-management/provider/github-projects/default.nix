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

  config =
    let
      inherit (config.${namespace}.domain) project-management;
    in
    lib.mkIf (project-management.provider.use == "github-projects") {
      assertions = [
        {
          assertion = project-management.provider.github-projects.owner != "";
          message = "${namespace}.domain.project-management.provider.github-projects.owner must not be empty";
        }
        {
          assertion = project-management.provider.github-projects.project-number > 0;
          message = "${namespace}.domain.project-management.provider.github-projects.project-number must be positive";
        }
        {
          assertion =
            builtins.match "[A-Za-z_][A-Za-z0-9_]*" project-management.provider.github-projects.token-secret
            != null;
          message = "${namespace}.domain.project-management.provider.github-projects.token-secret must be a GitHub secret name";
        }
      ];
    };
}
