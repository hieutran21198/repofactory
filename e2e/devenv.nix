{ pkgs, ... }:
{
  dotenv.enable = true;
  packages = [
    pkgs.gh
    pkgs.nix
    pkgs.python3
  ];
}
