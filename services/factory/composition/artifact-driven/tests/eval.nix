let
  lib = {
    # Merge the blocks into one config. The blocks share only the `files` key.
    mkMerge = builtins.foldl' (
      acc: block:
      acc
      // block
      // {
        files = (acc.files or { }) // (block.files or { });
      }
    ) { };
    mkIf = condition: value: if condition then value else { };
    mkForce = value: value;
    optionalString = condition: string: if condition then string else "";
    optionalAttrs = condition: attrs: if condition then attrs else { };
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
    architecture: method:
    (import ../default.nix {
      inherit lib;
      config.factory.domain = {
        documentation.use = "artifact-driven";
        repo-arch.use = architecture;
        design.use = method;
        ci-cd.use = "unset";
      };
      namespace = "factory";
    }).config;

  configs = {
    multipleOn = evalModule "multiple" "ddd";
    multipleOff = evalModule "multiple" "unset";
    singleOn = evalModule "single" "ddd";
    singleOff = evalModule "single" "unset";
  };
  noArchOn = evalModule "unset" "ddd";

  roles = [
    "requirement-expert"
    "solution-expert"
  ];
  base = role: builtins.readFile (../_assets/agent/role + "/${role}/ROLE.md");
  chapter = arch: role: builtins.readFile (../_assets + "/${arch}/ddd/agent/role/${role}/ROLE.md");
  instruction = cfg: role: cfg.factory.domain.agent.role.builder.${role}.instruction;

  guidance = [
    "AGENTS.md"
    "docs/README.md"
    "docs/wiki/README.md"
  ];
  page = "docs/wiki/design/ddd/artifact-driven.md";
  sourceOf = cfg: name: cfg.files.${name}.source;

  # The knowledge index does not depend on the architecture.
  expected = {
    multipleOn = {
      "AGENTS.md" = ../_assets/multiple/ddd/AGENTS.md;
      "docs/README.md" = ../_assets/ddd/docs/README.md;
      "docs/wiki/README.md" = ../_assets/multiple/ddd/docs/wiki/README.md;
    };
    multipleOff = {
      "AGENTS.md" = ../_assets/multiple/AGENTS.md;
      "docs/README.md" = ../_assets/docs/README.md;
      "docs/wiki/README.md" = ../_assets/multiple/docs/wiki/README.md;
    };
    singleOn = {
      "AGENTS.md" = ../_assets/single/ddd/AGENTS.md;
      "docs/README.md" = ../_assets/ddd/docs/README.md;
      "docs/wiki/README.md" = ../_assets/single/ddd/docs/wiki/README.md;
    };
    singleOff = {
      "AGENTS.md" = ../_assets/single/AGENTS.md;
      "docs/README.md" = ../_assets/docs/README.md;
      "docs/wiki/README.md" = ../_assets/single/docs/wiki/README.md;
    };
  };
  keys = builtins.attrNames configs;

  sourcesMatch = builtins.all (
    key: builtins.all (name: sourceOf configs.${key} name == expected.${key}.${name}) guidance
  ) keys;
  sourcesExist = builtins.all (
    key: builtins.all (name: builtins.pathExists (sourceOf configs.${key} name)) guidance
  ) keys;

  chapterAppended = builtins.all (
    arch:
    builtins.all (
      role: instruction configs."${arch}On" role == base role + "\n" + chapter arch role
    ) roles
  ) [ "multiple" "single" ];
  chapterOmitted = builtins.all (
    cfg: builtins.all (role: instruction cfg role == base role) roles
  ) [ configs.multipleOff configs.singleOff noArchOn ];
  chapterHasHeading = builtins.all (
    arch: builtins.all (
      role: builtins.match "## Domain-Driven Design\n.*" (chapter arch role) != null
    ) roles
  ) [ "multiple" "single" ];

  pageOn = builtins.all (
    arch:
    let
      cfg = configs."${arch}On";
    in
    cfg.files.${page}.copyMode == "copy"
    && cfg.files.${page}.source == ../_assets + "/${arch}/ddd/${page}"
    && builtins.pathExists cfg.files.${page}.source
  ) [ "multiple" "single" ];
  pageOff = builtins.all (cfg: !(builtins.hasAttr page cfg.files)) [
    configs.multipleOff
    configs.singleOff
    noArchOn
  ];
  noArchOmitsGuidance = noArchOn.files == { };
in
assert sourcesMatch;
assert sourcesExist;
assert chapterAppended;
assert chapterOmitted;
assert chapterHasHeading;
assert pageOn;
assert pageOff;
assert noArchOmitsGuidance;
{
  inherit
    sourcesMatch
    sourcesExist
    chapterAppended
    chapterOmitted
    chapterHasHeading
    pageOn
    pageOff
    noArchOmitsGuidance
    ;
}
