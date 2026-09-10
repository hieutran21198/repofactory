let
  lib = {
    mkIf = condition: value: if condition then value else { };
  };

  evalModule =
    model:
    (import ../default.nix {
      inherit lib;
      config.factory = {
        _utils = { };
        domain.documentation.use = model;
      };
      namespace = "factory";
    }).config;

  on = evalModule "artifact-driven";
  off = evalModule "unset";

  wiki = "docs/wiki/documentation/artifact-driven/README.md";
  templates = "docs/wiki/documentation/artifact-driven/templates";
  index = "docs/artifact/README.md";

  assets = ../_assets/docs/wiki/documentation/artifact-driven;
  templateFiles = [
    "feature/README.md"
    "change/README.md"
    "change/requirements/README.md"
    "change/requirements/req-name.md"
    "change/specifications/README.md"
    "change/specifications/spec-name.md"
    "change/decisions/adr-name.md"
    "change/tasks/README.md"
    "change/tasks/task-name.md"
  ];
  legacyFolders = [
    "feature/requirements"
    "feature/specifications"
    "feature/decisions"
    "feature/tasks"
  ];
  template = file: assets + "/templates/${file}";
  templateText = file: builtins.readFile (template file);
  matchesAll = patterns: text: builtins.all (pattern: builtins.match pattern text != null) patterns;

  hasMode = name: mode: on.files.${name}.copyMode == mode;
  filesOn =
    builtins.attrNames on.files == builtins.sort builtins.lessThan [
      wiki
      templates
      index
    ]
    && hasMode wiki "copy"
    && hasMode templates "copy"
    && hasMode index "seed";
  filesOff = (off.files or { }) == { };
  sourcesExist = builtins.all (name: builtins.pathExists on.files.${name}.source) (
    builtins.attrNames on.files
  );

  templateTree = builtins.all (file: builtins.pathExists (template file)) templateFiles;
  legacyTemplatesAbsent = builtins.all (
    folder: !(builtins.pathExists (template folder))
  ) legacyFolders;

  wikiText = builtins.readFile (assets + "/README.md");
  wikiHasPhases =
    matchesAll [
      ".*### Phase 1: Requirements.*### Phase 2: Specifications.*### Phase 3: Plan.*### Phase 4: Implementation.*### Phase 5: Version.*"
      ".*## Removed artifacts.*"
    ] wikiText
    && builtins.match ".*update the master artifacts.*" wikiText == null;

  changeTemplateHasHeader =
    builtins.match ".*\\*\\*From:\\*\\*.*\\*\\*To:\\*\\*.*\\*\\*Type:\\*\\*.*## Removed artifacts.*" (
      templateText "change/README.md"
    ) != null;
  featureTemplateHasVersion =
    builtins.match ".*\\*\\*Current version:\\*\\*.*\\| Version \\| Change \\|.*" (
      templateText "feature/README.md"
    ) != null;
  noStatusInTemplates = builtins.all (
    file: builtins.match ".*\\*\\*Status:\\*\\*.*" (templateText file) == null
  ) templateFiles;
in
assert filesOn;
assert filesOff;
assert sourcesExist;
assert templateTree;
assert legacyTemplatesAbsent;
assert wikiHasPhases;
assert changeTemplateHasHeader;
assert featureTemplateHasVersion;
assert noStatusInTemplates;
{
  inherit
    filesOn
    filesOff
    sourcesExist
    templateTree
    legacyTemplatesAbsent
    wikiHasPhases
    changeTemplateHasHeader
    featureTemplateHasVersion
    noStatusInTemplates
    ;
}
