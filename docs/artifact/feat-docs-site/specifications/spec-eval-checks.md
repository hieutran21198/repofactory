# spec-eval-checks: Check the docs-site module with a stub evaluation

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs, req-github-pages-publishing
**Context:** context-factory

## Description

The check file `services/factory/composition/artifact-driven/docs-site/tests/eval.nix` evaluates
the module with a stub `lib` and an identity `_utils`. It follows the pattern of
`services/factory/composition/artifact-driven/tests/eval.nix`. Each check is a named boolean.
The file asserts each check and exposes it in the result attribute set.

The checks read the authored files with `builtins.readFile`. A text check uses `builtins.match`
with a pattern in the form `".*<pattern>.*"`. `builtins.match` matches the whole string, and `.`
matches a newline, so the form matches a whole file.

## Contract

### Stubs

The stub `lib` has `mkIf`, `mkMerge`, `mkForce`, `optionalString`, and `optionalAttrs`, as in
the parent check file. `mkMerge` merges `files` and concatenates `assertions`. The stub `_utils`
has `mkBoolOpt` and `mkStrOpt` as identity functions.

### `moduleFor`

```nix
moduleFor =
  {
    architecture ? "multiple",
    documentation ? "artifact-driven",
    ciProvider ? "github-actions",
    enable ? false,
    title ? "Documentation",
    url ? "https://example.github.io",
    baseUrl ? "/repo/",
  }:
  import ../default.nix {
    inherit lib;
    config.factory = {
      _utils = optionUtils;
      domain = {
        documentation.use = documentation;
        repo-arch.use = architecture;
        ci-cd.provider.use = ciProvider;
      };
      composition.artifact-driven.docs-site = {
        inherit enable title url;
        base-url = baseUrl;
      };
    };
    namespace = "factory";
  };

evalModule = args: (moduleFor args).config;
```

### Configurations

| Name | Arguments |
| --- | --- |
| `on` | `{ enable = true; }` |
| `off` | `{ }` |
| `single` | `{ enable = true; architecture = "single"; }` |
| `noCi` | `{ enable = true; ciProvider = "unset"; }` |
| `noModel` | `{ enable = true; documentation = "unset"; }` |
| `emptyUrl` | `{ enable = true; url = ""; }` |
| `badBaseUrl` | `{ enable = true; baseUrl = "repo"; }` |

`invalidSetups` is the list `[ single noCi noModel emptyUrl badBaseUrl ]`.

### Bindings

```nix
site = "apps/documentation";
copyFiles = [
  "${site}/package.json"
  "${site}/package-lock.json"
  "${site}/docusaurus.config.js"
  "${site}/sidebars.js"
  "${site}/site.json"
  "${site}/.gitignore"
  ".github/workflows/docs-site.yml"
  "docs/wiki/documentation/artifact-driven/docs-site.md"
];
seedFiles = [
  "${site}/src/css/custom.css"
  "${site}/README.md"
];
allFiles = copyFiles ++ seedFiles;
sourced = builtins.filter (name: name != "${site}/site.json") allFiles;
fileOf = name: on.files.${name};
textOf = name: builtins.readFile (fileOf name).source;
matches = pattern: text: builtins.match ".*${pattern}.*" text != null;
assertionsPass = cfg: builtins.all (a: a.assertion) (cfg.assertions or [ ]);
pkg = builtins.fromJSON (textOf "${site}/package.json");
lock = builtins.fromJSON (textOf "${site}/package-lock.json");
```

### Checks

| Check | Condition |
| --- | --- |
| `filesPresent` | For each name in `allFiles`: `builtins.hasAttr name on.files`. |
| `sourcesExist` | For each name in `sourced`: `(fileOf name).source == ../_assets + "/${name}"` and `builtins.pathExists (fileOf name).source`. |
| `copyModes` | For each name in `copyFiles`: `(fileOf name).copyMode == "copy"`. For each name in `seedFiles`: `(fileOf name).copyMode == "seed"`. |
| `siteJsonRoundTrip` | `builtins.fromJSON (fileOf "${site}/site.json").text == { title = "Documentation"; url = "https://example.github.io"; baseUrl = "/repo/"; }`. |
| `packageJsonPinned` | `pkg.private == true`, `pkg.scripts.build == "docusaurus build"`, `pkg.dependencies."@docusaurus/core" == pkg.dependencies."@docusaurus/preset-classic"`, `builtins.match "3\\.9\\.[0-9]+" pkg.dependencies."@docusaurus/core" != null`, and `!(builtins.hasAttr "type" pkg)`. |
| `lockfilePinned` | `lock.lockfileVersion >= 2`. |
| `configMatches` | `textOf "${site}/docusaurus.config.js"` matches each of: `trailingSlash: true`, `site\\.json`, `'\\.\\./\\.\\./docs'`, `routeBasePath: '/'`, `format: 'detect'`, `\\*\\*/templates/\\*\\*`, `numberPrefixParser: false`. |
| `workflowMatches` | `textOf ".github/workflows/docs-site.yml"` matches each of: `actions/upload-pages-artifact@v3`, `actions/deploy-pages@v4`, `working-directory: apps/documentation`, `npm ci`, `pages: write`, `id-token: write`. |
| `gitignoreMatches` | `textOf "${site}/.gitignore"` matches each of: `node_modules/`, `build/`, `\\.docusaurus/`. |
| `wikiPageMatches` | `textOf "docs/wiki/documentation/artifact-driven/docs-site.md"` matches each of: `npm run start`, `GitHub Actions`. |
| `onAssertionsPass` | `assertionsPass on`. |
| `offEmitsNothing` | `(off.files or { }) == { }` and `(off.assertions or [ ]) == [ ]`. |
| `invalidSetupsRejected` | For each `cfg` in `invalidSetups`: `!assertionsPass cfg`. |

The patterns in the table are Nix string literals. `\\.` in the literal is `\.` in the regular
expression, which matches a literal dot. `matches` adds `.*` before and after the pattern.

`offEmitsNothing` uses `or`. When `enable` is `false`, the `lib.mkIf` block gives `{ }`, so
`off` may have no `files` and no `assertions` attribute.

### Result

The file asserts the thirteen checks in the order of the table:

```nix
assert filesPresent;
assert sourcesExist;
assert copyModes;
assert siteJsonRoundTrip;
assert packageJsonPinned;
assert lockfilePinned;
assert configMatches;
assert workflowMatches;
assert gitignoreMatches;
assert wikiPageMatches;
assert onAssertionsPass;
assert offEmitsNothing;
assert invalidSetupsRejected;
{
  inherit
    filesPresent
    sourcesExist
    copyModes
    siteJsonRoundTrip
    packageJsonPinned
    lockfilePinned
    configMatches
    workflowMatches
    gitignoreMatches
    wikiPageMatches
    onAssertionsPass
    offEmitsNothing
    invalidSetupsRejected
    ;
}
```

### Commands

Run the check of the module:

```sh
nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix
```

Run the check of the parent composition. The result shows that the new module does not change
the parent:

```sh
nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix
```

Both commands print an attribute set with each check equal to `true` and exit with code 0.

## Errors

Nix evaluation fails with an assertion error and names no result when one of the thirteen
checks is false.
Nix evaluation fails if a source file does not exist, because `textOf` reads each file.
Nix evaluation fails if `package.json`, `package-lock.json`, or `site.json` is not valid JSON.
The command exits with a non-zero code in each case.
