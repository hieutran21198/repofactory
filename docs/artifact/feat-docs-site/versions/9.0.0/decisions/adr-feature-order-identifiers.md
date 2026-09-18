# adr-feature-order-identifiers: Use actual feature folder basenames

**Relates to:** spec-docusaurus-config, spec-docs-site-options, spec-docs-site-files
**Context:** context-factory

## Context

The approved dependency path uses the groups `e2e/provider-contracts` and `skills`. These group
names are not feature folders. The option contract also requires a list of folder names.

The repository has separate folders for both features in each group. The comparator needs one
identity for each folder to give all current features a deterministic position.

The factory copies the generic `docusaurus.config.js` asset on each shell entry. A fixed list in
that generated file is not durable. The root `devenv.local.nix` file is not tracked. Thus, the
repository needs a tracked configuration path for its list.

## Options

1. Use each actual `feat-*` folder basename in `sidebar.feature-order`. Set this repository's list
   in the tracked root `devenv.nix` module. Pro: The repository and downstream projects use one
   identity and one delivery path. Pro: Each current feature has one strict position. Con: The
   list expands the group shorthand.
2. Keep the group aliases `e2e/provider-contracts` and `skills` in the typed option. Map each
   alias to multiple folders in the comparator. Pro: The list keeps the approved shorthand. Con:
   The aliases are not folder names. Con: The comparator needs repository-specific aliases.
3. Put the actual folder basenames in `apps/documentation/docusaurus.config.js`. Pro: The list is
   close to the comparator. Con: The factory overwrites this generated copy on each shell entry.

## Decision

Use option 1. The list uses actual folder basenames, including the `feat-` prefix. The tracked
root `devenv.nix` module sets the value. Nix writes it to `site.json.featureOrder`. The generic
asset reads it with `site.featureOrder ?? []`.

The peers use alphabetical display-label order. Thus, `feat-e2e-folder` precedes
`feat-provider-contracts`. The folder `feat-ddd-review-skill` precedes
`feat-expert-role-skill`.

## Consequences

The repository configuration lists each current feature folder. A downstream project uses its
own complete feature folder basenames in `sidebar.feature-order`.

A feature-folder rename needs a matching list update. An unlisted folder remains visible and
sorts alphabetically after the listed folders.

The generated JavaScript configuration contains no repository-specific list. The root
`devenv.local.nix` file does not supply this repository value.

## Feasibility constraints

| ID | Constraint | Responsible owner | Resolution |
| --- | --- | --- | --- |
| C-SORT-01 | A literal repository `FEATURE_ORDER` in `apps/documentation/docusaurus.config.js` is not durable. The factory overwrites that copy on each shell entry. | solution-expert | Remove the literal list from the generated-file contract. Use the typed option and `site.json`. |
| C-SORT-02 | The only durable channel for the repository order is `sidebar.feature-order` rendered into `site.json`. A tracked module must set the value. | solution-expert | Set the repository value in the tracked root `devenv.nix` module. Do not use `devenv.local.nix`. |
| C-SORT-03 | Read a category source folder basename from `item.source`. Read a document basename from `item.source`. Run the label operation before sorting. | factory-expert | The comparator contract specifies these sources and this operation order. |
| C-SORT-04 | A document item display label can be absent. Resolve it from `item.label`, the matching document title, or `item.id`. | factory-expert | The sidebar identity contract specifies this fallback order. |
| C-SORT-05 | A sibling level has no parent value. Recursion must pass the parent category source basename. | factory-expert | The comparator contract requires each recursive call to receive the parent basename. |
| C-SORT-06 | `localeCompare` is locale-dependent. The code-point order needs an explicit comparison. | factory-expert | The comparator contract keeps code-point order and excludes locale order. |
| C-SORT-07 | Docusaurus absorbs a folder index into its category link. The index is not a sibling item in its own folder. | factory-expert | The index contract limits direct-document sorting to index items that remain in the sidebar. |
| C-SORT-08 | A Nix check cannot execute the comparator. Only a Docusaurus build can execute it. | factory-expert | The verification contract assigns text and data checks to Nix. It assigns comparator checks to a Docusaurus build. |
| C-OPT-01 | Use `_utils.mkListOpt` with `lib.types.str`, an empty default, and the dotted key `sidebar.feature-order`. | factory-expert | The option contract specifies `listOf str`, the dotted key, and the empty default. |
| C-OPT-02 | Non-empty and unique assertions are feasible and case-sensitive. Their messages must name the option and rule. | factory-expert | The assertion contract specifies both checks, case-sensitive equality, and the message rule. |
| C-OPT-03 | The test builder must supply `sidebar.feature-order` to enabled module evaluations. | factory-expert | The option contract requires the builder cases for default, selected, empty, duplicate, and wrong-type values. |
| C-FILES-01 | The new field changes the exact JSON round-trip assertions. All target variants must write it. | factory-expert | The file contract adds `featureOrder = []` to both round-trip values and keeps cross-target equality. |
| C-FILES-02 | The JSON example does not define factory defaults or repository values. A task must not encode it as defaults. | solution-expert, factory-expert | The example uses the test inputs, identifies itself as a shape example, and prohibits its use as defaults. |
| C-FILES-03 | `builtins.toJSON` writes keys alphabetically. A check must not require a different key order. | factory-expert | The JSON contract gives no meaning to object key order and prohibits such a text check. |
| C-FILES-04 | The change adds no file or copy-mode change. Edit only the generic asset, not its generated copy. | factory-expert | The file contract keeps all copy modes and prohibits a repository-specific generated-file edit. |
| C-FILES-05 | The guide bytes stay unchanged. No task documents `sidebar.feature-order` in the guide asset. | factory-expert | The file contract keeps the guide unchanged and excludes the sidebar option from it. |
| C-FILES-06 | The absent-field default is in JavaScript. A Docusaurus build verifies it. The repository order travels through `site.json`. | factory-expert, solution-expert | The configuration and file contracts specify the JavaScript default, build check, and tracked Nix delivery path. |
