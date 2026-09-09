{ config, namespace, ... }:
let
  inherit (config.${namespace}) _utils;
in
{
  options.${namespace}.domain.project-management.provider.trello = {
    board-id = _utils.mkStrOpt {
      default = "";
      description = "ID of the Trello board";
    };
    implementation-board-id = _utils.mkStrOpt {
      default = "";
      description = "Optional ID of the Trello implementation board";
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
}
