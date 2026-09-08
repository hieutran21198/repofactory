{ config, namespace, ... }:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.project-management = {
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
}
