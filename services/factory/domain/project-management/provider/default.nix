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
  options.${namespace}.domain.project-management = {
    artifact-status = {
      feature-summary = _utils.mkStrOpt { default = "Accepted"; };
      master-requirement = _utils.mkStrOpt { default = "Accepted"; };
      requirement = _utils.mkStrOpt { default = "Accepted"; };
      master-specification = _utils.mkStrOpt { default = "Accepted"; };
      specification = _utils.mkStrOpt { default = "Accepted"; };
      decision = _utils.mkStrOpt { default = "Accepted"; };
      implementation-plan = _utils.mkStrOpt { default = "Accepted"; };
      task = _utils.mkStrOpt { default = "Ready"; };
      change-summary = _utils.mkStrOpt { default = "Accepted"; };
      withdrawn = _utils.mkStrOpt { default = "Withdrawn"; };
    };

    provider = {
      use = _utils.mkEnumOpt {
        values = [
          "unset"
          "trello"
          "github-projects"
        ];
        default = "unset";
      };
    };
  };

  config.assertions =
    let
      statuses = config.${namespace}.domain.project-management.artifact-status;
    in
    lib.mapAttrsToList (name: value: {
      assertion = value != "";
      message = "${namespace}.domain.project-management.artifact-status.${name} must not be empty";
    }) statuses;
}
