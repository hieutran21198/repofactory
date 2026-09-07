{
  config,
  namespace,
  lib,
  ...
}:
let
  arch = "multiple";
  inherit (config.${namespace}) _utils;
in
{
  config =
    let
      inherit (config.${namespace}.domain) repo-arch;
    in
    lib.mkIf (repo-arch.use == arch) {
      files = {
        "AGENTS.md" = {
          source = ./_assets/AGENTS.md;
          copyMode = "seed";
        };
        "README.md" = {
          source = ./_assets/README.md;
          copyMode = "seed";
        };
        "docs/README.md" = {
          source = ./_assets/docs/README.md;
          copyMode = "seed";
        };
        "docs/wiki/README.md" = {
          source = ./_assets/docs/wiki/README.md;
          copyMode = "seed";
        };
        "docs/wiki/repo-arch/multiple-repositories.md" = {
          source = ./_assets/docs/wiki/repo-arch/multiple-repositories.md;
          copyMode = "seed";
        };
        "libs/README.md" = {
          source = ./_assets/libs/README.md;
          copyMode = "seed";
        };
        "apps/README.md" = {
          source = ./_assets/apps/README.md;
          copyMode = "seed";
        };
        "services/README.md" = {
          source = ./_assets/services/README.md;
          copyMode = "seed";
        };
        "deployment/README.md" = {
          source = ./_assets/deployment/README.md;
          copyMode = "seed";
        };
        "e2e/README.md" = {
          source = ./_assets/e2e/README.md;
          copyMode = "seed";
        };
      };
    };
}
