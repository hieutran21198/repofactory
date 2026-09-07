{
  config,
  namespace,
  lib,
  ...
}:
let
  method = "ddd";
in
{
  config =
    let
      inherit (config.${namespace}.domain) design;
    in
    lib.mkIf (design.use == method) {
      files = {
        "docs/wiki/design/ddd/README.md" = {
          source = ./_assets/docs/wiki/design/ddd/README.md;
          copyMode = "copy";
        };
        "docs/wiki/design/ddd/templates" = {
          source = ./_assets/docs/wiki/design/ddd/templates;
          copyMode = "copy";
        };
        "docs/domain/README.md" = {
          source = ./_assets/docs/domain/README.md;
          copyMode = "seed";
        };
        "docs/domain/context-map.md" = {
          source = ./_assets/docs/domain/context-map.md;
          copyMode = "seed";
        };
        "docs/domain/glossary.md" = {
          source = ./_assets/docs/domain/glossary.md;
          copyMode = "seed";
        };
      };
    };
}
