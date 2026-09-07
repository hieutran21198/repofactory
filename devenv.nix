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
}
