# spec-docusaurus-config: Configure Docusaurus to render documentation

**Master:** [Specifications](README.md)
**Covers:** req-browsable-docs, req-generated-assets, req-sidebar-sort-order, req-sidebar-feature-order-option
**Context:** context-factory

## Contract

### Configuration inputs

The authored CommonJS file `docusaurus.config.js` reads the site settings from `site.json`.

| Docusaurus setting | Value |
| --- | --- |
| `title` | `site.title` |
| `url` | `site.url` |
| `baseUrl` | `site.baseUrl` |
| `staticDirectories` | `site.staticDirectories` |
| `FEATURE_ORDER` | `site.featureOrder ?? []` |

The generic factory asset and its generated copy use this value:

```javascript
const FEATURE_ORDER = site.featureOrder ?? [];
```

An absent `featureOrder` field gives an empty list. An empty list puts all feature folders in
the alphabetical fallback group.

This repository sets this option value in the tracked root `devenv.nix` module:

```nix
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
```

The peers from each approved dependency stage use alphabetical display-label order. Thus,
`feat-e2e-folder` precedes `feat-provider-contracts`. The folder `feat-ddd-review-skill`
precedes `feat-expert-role-skill`.

The selected value travels only through `site.json.featureOrder`. The generated
`apps/documentation/docusaurus.config.js` file contains no repository-specific list.

### Sidebar item identity

The comparator gets a category source folder basename from `item.source`. It gets a document
source basename from `item.source`. It does not use a category display label as its identity. A
feature identity includes the `feat-` prefix.

The comparator uses the Docusaurus display label for alphabetical order. It resolves a document
label with this order: `item.label`, the title in `args.docs` for the document ID, then `item.id`.
The index operation sets category labels before the comparator sorts the items.

A direct document is an index page when its source basename is `index` or `README`, without
regard to letter case. Docusaurus absorbs a folder index into the category link. Such an index is
not a sibling item in its own folder. The direct-document rule applies to a top-level index and
to each index that remains a document item.

### Comparator

The sidebar generator applies the comparator recursively to each sibling level. Each recursive
call receives the source basename of its parent category. The comparator applies these rules in
priority order:

1. When both items are feature folders, it uses `FEATURE_ORDER` first. A listed folder uses its
   zero-based list position. A listed folder precedes an unlisted folder. Two unlisted folders
   continue to the next applicable rule.
2. An `index` or `README` document precedes each other item in its parent folder.
3. An artifact phase folder uses this rank: `requirements`, `specifications`, `decisions`,
   `tasks`. A ranked phase folder precedes an unranked folder at the same level.
4. Under a `versions` folder, semantic-version folders use descending numeric order. The
   comparator compares major, minor, and patch numbers. A valid semantic version precedes an
   invalid version folder. The current version is the highest version and comes first.
5. Under a `changes` folder, `change-initial` precedes all other change folders.
6. The fallback compares display labels without regard to letter case.

If two lowercase display labels are equal, the comparator compares the original labels. If the
original labels are equal, it compares the source identities. These comparisons use Unicode code
point order. Thus, the same sidebar input always gives the same order.

The comparator applies the special rules only to their specified item types and parent folders.
It does not apply a feature rank to a non-feature item.

### Verification

The Nix evaluation check verifies the option, the JSON data, and required text in the generic
asset. It does not execute the JavaScript comparator. A Docusaurus build executes the comparator
and verifies the sidebar order.

### Other Docusaurus settings

- `trailingSlash` is `true`.
- Both broken-link settings are `warn`.
- Markdown format is `detect`.
- The classic preset disables the blog.
- The docs path is `../../docs` and its route is `/`.
- The sidebar path is `./sidebars.js` and number-prefix parsing is off.
- The exclude list includes the Docusaurus defaults and `**/templates/**`.
- A folder without an index gets a generated index page.
- The classic theme reads `./src/css/custom.css`.
- The navbar title is `site.title`.

`staticDirectories` is an empty list by default. This value gives no default static directory
and no favicon.

## Description

The configuration renders the `docs/` tree at the website root. It uses CommonMark for `.md`
files and excludes templates. It also makes an index for a folder without `README.md`.

The generic factory copy reads the configured static directories and feature order. Thus, a
repository can publish generated files and select its feature-folder order.

## Errors

The build fails if `site.json`, the CSS file, or a configured static directory is absent. The
build also fails if `featureOrder` is present and is not an array that the comparator can read.
Broken Markdown links produce warnings and do not stop the build.
