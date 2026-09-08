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
  options.${namespace}.domain.project-management.provider.trello = {
    board-id = _utils.mkStrOpt {
      default = "";
      description = "ID of the Trello board";
    };
    api-key-secret = _utils.mkStrOpt {
      default = "TRELLO_API_KEY";
      description = "GitHub Actions secret that contains the Trello API key";
    };
    token-secret = _utils.mkStrOpt {
      default = "TRELLO_TOKEN";
      description = "GitHub Actions secret that contains the Trello token";
    };
  };

  config =
    let
      inherit (config.${namespace}.domain) project-management;
    in
    lib.mkIf (project-management.provider.use == "trello") {
      assertions = [
        {
          assertion = project-management.provider.trello.board-id != "";
          message = "${namespace}.domain.project-management.provider.trello.board-id must not be empty";
        }
        {
          assertion =
            builtins.match "[A-Za-z_][A-Za-z0-9_]*" project-management.provider.trello.api-key-secret != null;
          message = "${namespace}.domain.project-management.provider.trello.api-key-secret must be a GitHub secret name";
        }
        {
          assertion =
            builtins.match "[A-Za-z_][A-Za-z0-9_]*" project-management.provider.trello.token-secret != null;
          message = "${namespace}.domain.project-management.provider.trello.token-secret must be a GitHub secret name";
        }
      ];
    };
}
