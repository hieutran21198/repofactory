{
  ...
}:
let
  namespace = "factory";
  nsImporter = import ./libs/nix/_importer.nix { inherit namespace; };
in
{
  imports = nsImporter [
    ./libs
    ./services
  ];
  factory.composition.artifact-driven.docs-site.sidebar.feature-order = [
    "feat-single-repo-arch"
    "feat-e2e-folder"
    "feat-provider-contracts"
    "feat-ddd-design"
    "feat-artifact-versions"
    "feat-artifact-master"
    "feat-accepted-artifact-issues"
    "feat-docs-site"
    "feat-ddd-review-skill"
    "feat-expert-role-skill"
  ];
}
