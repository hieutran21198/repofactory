{
  config,
  namespace,
  lib,
  ...
}:
let
  method = "ddd";
  archs = [
    "multiple"
    "single"
  ];
in
{
  config =
    let
      inherit (config.${namespace}.domain) design repo-arch;
      ddd = design.use == method;
    in
    lib.mkMerge (
      [
        # The domain model seeds do not depend on the repository architecture.
        (lib.mkIf ddd {
          files = {
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
        })
      ]
      # The design guide and the templates have one version for each repository architecture.
      ++ map (
        arch:
        lib.mkIf (ddd && repo-arch.use == arch) {
          files = {
            "docs/wiki/design/ddd/README.md" = {
              source = ./_assets/${arch}/docs/wiki/design/ddd/README.md;
              copyMode = "copy";
            };
            "docs/wiki/design/ddd/templates" = {
              source = ./_assets/${arch}/docs/wiki/design/ddd/templates;
              copyMode = "copy";
            };
          };
        }
      ) archs
    );
}
