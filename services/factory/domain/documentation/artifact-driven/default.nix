{
  config,
  namespace,
  lib,
  ...
}:
let
  model = "artifact-driven";
in
{
  config =
    let
      inherit (config.${namespace}.domain) documentation;
    in
    lib.mkIf (documentation.use == model) {
      files = {
        "docs/wiki/documentation/artifact-driven/README.md" = {
          source = ./_assets/docs/wiki/documentation/artifact-driven/README.md;
          copyMode = "copy";
        };
        "docs/wiki/documentation/artifact-driven/templates" = {
          source = ./_assets/docs/wiki/documentation/artifact-driven/templates;
          copyMode = "copy";
        };
        "docs/artifact/README.md" = {
          source = ./_assets/docs/artifact/README.md;
          copyMode = "seed";
        };
      };
    };
}
