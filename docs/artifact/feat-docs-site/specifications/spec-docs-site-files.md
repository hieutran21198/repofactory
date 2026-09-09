# spec-docs-site-files: Render the site project files

**Master:** [Specifications](README.md)
**Covers:** req-factory-owned-site, req-browsable-docs
**Context:** context-factory

## Description

When `factory.composition.artifact-driven.docs-site.enable` is `true`, the module renders ten base
files. Eight files are in `copy` mode. Two files are in `seed` mode. When a notification provider
is selected, the module renders one more file in `copy` mode.

Nix owns one settings file, `site.json`. The authored file `docusaurus.config.js` reads it with
`require('./site.json')`. This is the pattern of `services/factory/domain/agent/harness/codex/`:
Nix renders the settings, an authored file consumes them, and Nix translates no format.

The root `.gitignore` does not change. A `.gitignore` inside `apps/documentation/` covers the
factory-owned folder.

## Contract

### Generated files

| Generated path | copyMode | Source |
| --- | --- | --- |
| `apps/documentation/package.json` | `copy` | `source = ./_assets/apps/documentation/package.json` |
| `apps/documentation/package-lock.json` | `copy` | `source = ./_assets/apps/documentation/package-lock.json` |
| `apps/documentation/docusaurus.config.js` | `copy` | `source = ./_assets/apps/documentation/docusaurus.config.js` |
| `apps/documentation/sidebars.js` | `copy` | `source = ./_assets/apps/documentation/sidebars.js` |
| `apps/documentation/site.json` | `copy` | `text = builtins.toJSON { title = docsSite.title; url = docsSite.url; baseUrl = docsSite.base-url; }` |
| `apps/documentation/.gitignore` | `copy` | `source = ./_assets/apps/documentation/.gitignore` |
| `apps/documentation/src/css/custom.css` | `seed` | `source = ./_assets/apps/documentation/src/css/custom.css` |
| `apps/documentation/README.md` | `seed` | `source = ./_assets/apps/documentation/README.md` |
| `.github/workflows/docs-site.yml` | `copy` | `text = workflow docsSite.notification` |
| `docs/wiki/documentation/artifact-driven/docs-site.md` | `copy` | `source = ./_assets/docs/wiki/documentation/artifact-driven/docs-site.md` |
| `.github/docs-site/notify.py` | `copy` | `source = ./_assets/.github/docs-site/notify.py`; only present when notification is enabled. |

`docsSite` is `config.factory.composition.artifact-driven.docs-site`. Each `source` path is
relative to the module. An authored source uses `_assets/<generated path>`. Nix renders the
settings file and the workflow text.

### Asset folder

```text
services/factory/composition/artifact-driven/docs-site/_assets/
├── .github/
│   └── docs-site/
│       └── notify.py
├── apps/
│   └── documentation/
│       ├── .gitignore
│       ├── README.md
│       ├── docusaurus.config.js
│       ├── package-lock.json
│       ├── package.json
│       ├── sidebars.js
│       └── src/
│           └── css/
│               └── custom.css
└── docs/
    └── wiki/
        └── documentation/
            └── artifact-driven/
                └── docs-site.md
```

The asset folder has no `site.json` or workflow file. Nix renders both files from the options.

### `site.json`

The module renders `site.json` with `builtins.toJSON`. The attribute set has three keys:

```json
{"baseUrl":"/repofactory/","title":"Repository factory","url":"https://example.github.io"}
```

| Key | Value |
| --- | --- |
| `title` | `docsSite.title` |
| `url` | `docsSite.url` |
| `baseUrl` | `docsSite.base-url` |

`builtins.toJSON` writes the keys in alphabetical order. `builtins.fromJSON` on the text gives
the same three values. The file has no other key.

### `package.json`

```json
{
  "name": "documentation",
  "private": true,
  "scripts": {
    "start": "docusaurus start",
    "build": "docusaurus build",
    "serve": "docusaurus serve",
    "clear": "docusaurus clear"
  },
  "dependencies": {
    "@docusaurus/core": "3.9.<patch>",
    "@docusaurus/preset-classic": "3.9.<patch>",
    "@mdx-js/react": "^3.0.0",
    "prism-react-renderer": "^2.3.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  },
  "overrides": {
    "webpackbar": "^7.0.0"
  }
}
```

| Field | Rule |
| --- | --- |
| `private` | `true`. |
| `scripts` | Exactly four scripts. Each script is `docusaurus <name>`, where `<name>` is the script name. |
| `dependencies."@docusaurus/core"` | One exact version `3.9.<patch>`. No `^` and no `~`. |
| `dependencies."@docusaurus/preset-classic"` | The same string as `@docusaurus/core`. |
| `dependencies."@mdx-js/react"` | Major version 3. |
| `dependencies."prism-react-renderer"` | Major version 2. |
| `dependencies.react`, `dependencies."react-dom"` | Major version 19. |
| `overrides.webpackbar` | `^7.0.0`. The lockfile resolves webpack 5.110, which validates the options of `ProgressPlugin` in `apply()` since 5.106.0. `webpackbar` 6.0.1, which `@docusaurus/bundler` 3.9.2 requires, overwrites these options, and `npm run build` fails with a `ValidationError`. `webpackbar` 7.0.0 keeps its options separate. |
| `type` | Absent. The config file is CommonJS. |

`<patch>` is the latest 3.9 patch release at the time of the implementation. The factory pins the
version. A project does not edit the file.

The factory removes the `overrides` field when the pin moves to a Docusaurus version that
requires `webpackbar ^7`. The factory then runs the lockfile command again.

### `package-lock.json`

The factory produces the lockfile one time in the asset folder
`_assets/apps/documentation/`:

```sh
nix shell nixpkgs#nodejs_22 -c npm install --package-lock-only --ignore-scripts
```

The command writes `package-lock.json` and no `node_modules/`. The file is valid JSON with
`lockfileVersion` of 2 or more. The factory runs the command again when `package.json` changes.

### `.gitignore`

```text
node_modules/
build/
.docusaurus/
```

The file has these three entries and no other entry.

### `sidebars.js`

```js
module.exports = {
  docs: [{ type: 'autogenerated', dirName: '.' }],
};
```

One sidebar, `docs`, generated from the whole docs folder. `spec-docusaurus-config` gives the
generator that shapes the items.

### `docusaurus.config.js`

The content is in `spec-docusaurus-config`.

### `src/css/custom.css`

A seed. The file has one comment and no rule:

```css
/* Project styles. The factory writes this file one time. The project owns it. */
```

Docusaurus needs the file because `theme.customCss` names it.

### `README.md`

A seed. The file says, in this order:

1. The folder is the documentation website. It renders the `docs/` tree of the repository.
2. The factory owns `package.json`, `package-lock.json`, `docusaurus.config.js`, `sidebars.js`,
   `site.json`, and `.gitignore`. The shell overwrites them. Change the options in
   `devenv.local.nix`, not these files.
3. The project owns `README.md` and `src/css/custom.css`.
4. The guide is at `docs/wiki/documentation/artifact-driven/docs-site.md`.

The file has no status field.

### `.github/workflows/docs-site.yml`

The content is in `spec-docs-site-workflow`.

### `docs/wiki/documentation/artifact-driven/docs-site.md`

The wiki page tells a project how to use the site. It has these sections, in this order:

| Section | Required content |
| --- | --- |
| `## Run locally` | Node.js 22 is not in the shell. Use `languages.javascript = { enable = true; npm.enable = true; }` in `devenv.local.nix`, or `nix shell nixpkgs#nodejs_22`. Then `cd apps/documentation`, `npm ci`, `npm run start`. |
| `## Publish` | The workflow `.github/workflows/docs-site.yml` builds and publishes on each push to the default branch. One manual step: set the Pages source to "GitHub Actions" in the repository settings. |
| `## Write pages that render` | `.md` files render as CommonMark. Put a `<name>` placeholder in backticks or in a code block. Link a `README.md` file, not a folder. A link to a URL path of a folder must end with `/`, for example `](decisions/)`. The templates under `docs/wiki/**/templates/` do not render. |

The page contains the strings `npm run start` and `GitHub Actions`.

## Errors

Nix evaluation fails if a `source` path does not exist.
The check `filesPresent` in `tests/eval.nix` fails if one of the ten paths is absent when
`enable` is `true`.
The check `copyModes` fails if a copy file has `copyMode = "seed"` or a seed file has
`copyMode = "copy"`.
The check `siteJsonRoundTrip` fails if `site.json` does not give back the three values.
The check `packageJsonPinned` fails if `scripts.build` is not `docusaurus build`, or if the
core version and the preset version differ.
The check `lockfilePinned` fails if the lockfile is not JSON or `lockfileVersion` is below 2.
`npm ci` fails in the workflow when `package-lock.json` does not match `package.json`.
