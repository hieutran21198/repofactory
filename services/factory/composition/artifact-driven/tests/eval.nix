let
  lib = {
    mkMerge = blocks: blocks;
    mkIf = condition: value: if condition then value else { };
    mkForce = value: value;
    optionalString = condition: string: if condition then string else "";
    foldl' = builtins.foldl';
    nameValuePair = name: value: { inherit name value; };
    mapAttrs' = f: set: builtins.listToAttrs (map (name: f name set.${name}) (builtins.attrNames set));
    filterAttrs =
      predicate: set:
      builtins.listToAttrs (
        builtins.concatMap (
          name:
          if predicate name set.${name} then
            [
              {
                inherit name;
                value = set.${name};
              }
            ]
          else
            [ ]
        ) (builtins.attrNames set)
      );
  };

  evalModule =
    method:
    (import ../default.nix {
      inherit lib;
      config.factory.domain = {
        documentation.use = "artifact-driven";
        repo-arch.use = "multiple";
        design.use = method;
      };
      namespace = "factory";
    }).config;

  # The mkMerge stub returns the list of blocks: agent, multiple, single, ddd.
  blocks = method: {
    agent = builtins.elemAt (evalModule method) 0;
    multiple = builtins.elemAt (evalModule method) 1;
    ddd = builtins.elemAt (evalModule method) 3;
  };
  on = blocks "ddd";
  off = blocks "unset";

  roles = [
    "requirement-expert"
    "solution-expert"
  ];
  base = role: builtins.readFile (../_assets/agent/role + "/${role}/ROLE.md");
  chapter = role: builtins.readFile (../_assets/ddd/agent/role + "/${role}/ROLE.md");
  instruction = cfg: role: cfg.agent.factory.domain.agent.role.builder.${role}.instruction;

  guidance = [
    "AGENTS.md"
    "docs/README.md"
    "docs/wiki/README.md"
  ];
  sourceOf = cfg: name: cfg.multiple.files.${name}.source;
  page = "docs/wiki/design/ddd/artifact-driven.md";

  chapterAppended = builtins.all (role: instruction on role == base role + "\n" + chapter role) roles;
  chapterOmitted = builtins.all (role: instruction off role == base role) roles;
  chapterHasHeading = builtins.all (
    role: builtins.match "## Domain-Driven Design\n.*" (chapter role) != null
  ) roles;
  dddSources = builtins.all (name: sourceOf on name == ../_assets/ddd + "/${name}") guidance;
  baseSources = builtins.all (name: sourceOf off name == ../_assets + "/${name}") guidance;
  sourcesExist = builtins.all (
    name: builtins.pathExists (sourceOf on name) && builtins.pathExists (sourceOf off name)
  ) guidance;
  pageOn = on.ddd.files.${page}.copyMode == "copy" && builtins.pathExists on.ddd.files.${page}.source;
  pageOff = !(builtins.hasAttr "files" off.ddd);
in
assert chapterAppended;
assert chapterOmitted;
assert chapterHasHeading;
assert dddSources;
assert baseSources;
assert sourcesExist;
assert pageOn;
assert pageOff;
{
  inherit
    chapterAppended
    chapterOmitted
    chapterHasHeading
    dddSources
    baseSources
    sourcesExist
    pageOn
    pageOff
    ;
}
