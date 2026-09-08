{
  config,
  namespace,
  lib,
  ...
}:
let
  arch = "single";
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
        "docs/wiki/repo-arch/single-repository.md" = {
          source = ./_assets/docs/wiki/repo-arch/single-repository.md;
          copyMode = "seed";
        };
        "src/README.md" = {
          source = ./_assets/src/README.md;
          copyMode = "seed";
        };
        "tests/README.md" = {
          source = ./_assets/tests/README.md;
          copyMode = "seed";
        };
        "deployment/README.md" = {
          source = ./_assets/deployment/README.md;
          copyMode = "seed";
        };
      };
    };
}
