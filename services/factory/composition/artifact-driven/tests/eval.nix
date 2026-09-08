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

  multipleOn = evalModule "multiple" "ddd";
  multipleOff = evalModule "multiple" "unset";
  singleOn = evalModule "single" "ddd";
  singleOff = evalModule "single" "unset";

  roles = [
    "requirement-expert"
    "solution-expert"
  ];
  base = role: builtins.readFile (../_assets/agent/role + "/${role}/ROLE.md");
  chapter = role: builtins.readFile (../_assets/ddd/agent/role + "/${role}/ROLE.md");
  instruction = cfg: role: cfg.factory.domain.agent.role.builder.${role}.instruction;

  guidance = [
    "AGENTS.md"
    "docs/README.md"
    "docs/wiki/README.md"
  ];
  sourceOf = cfg: name: cfg.files.${name}.source;
  page = "docs/wiki/design/ddd/artifact-driven.md";

  # The knowledge index does not depend on the architecture.
  expected = {
    multipleOn = {
      "AGENTS.md" = ../_assets/ddd/AGENTS.md;
      "docs/README.md" = ../_assets/ddd/docs/README.md;
      "docs/wiki/README.md" = ../_assets/ddd/docs/wiki/README.md;
    };
    multipleOff = {
      "AGENTS.md" = ../_assets/AGENTS.md;
      "docs/README.md" = ../_assets/docs/README.md;
      "docs/wiki/README.md" = ../_assets/docs/wiki/README.md;
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
  configs = {
    inherit
      multipleOn
      multipleOff
      singleOn
      singleOff
      ;
  };
  sourcesMatch = builtins.all (
    key: builtins.all (name: sourceOf configs.${key} name == expected.${key}.${name}) guidance
  ) (builtins.attrNames configs);
  sourcesExist = builtins.all (
    key: builtins.all (name: builtins.pathExists (sourceOf configs.${key} name)) guidance
  ) (builtins.attrNames configs);

  chapterAppended = builtins.all (
    role: instruction multipleOn role == base role + "\n" + chapter role
  ) roles;
  chapterOmitted = builtins.all (role: instruction multipleOff role == base role) roles;
  chapterHasHeading = builtins.all (
    role: builtins.match "## Domain-Driven Design\n.*" (chapter role) != null
  ) roles;
  pageOn = builtins.all (
    cfg: cfg.files.${page}.copyMode == "copy" && builtins.pathExists cfg.files.${page}.source
  ) [ multipleOn singleOn ];
  pageOff = builtins.all (cfg: !(builtins.hasAttr page cfg.files)) [ multipleOff singleOff ];
in
assert chapterAppended;
assert chapterOmitted;
assert chapterHasHeading;
assert sourcesMatch;
assert sourcesExist;
assert pageOn;
assert pageOff;
{
  inherit
    chapterAppended
    chapterOmitted
    chapterHasHeading
    sourcesMatch
    sourcesExist
    pageOn
    pageOff
    ;
}
