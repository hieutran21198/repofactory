{ lib, ... }:
{
  loadRoleSkills =
    skillsDir: roleName:
    let
      dir = skillsDir + "/${roleName}";
    in
    if builtins.pathExists dir then
      lib.mapAttrs' (name: _: lib.nameValuePair name (dir + "/${name}")) (
        lib.filterAttrs (_: type: type == "regular" || type == "directory") (builtins.readDir dir)
      )
    else
      { };
}
