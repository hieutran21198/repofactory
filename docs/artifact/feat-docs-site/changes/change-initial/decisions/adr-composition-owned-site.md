# adr-composition-owned-site: Put the site in a composition sub-module

**Relates to:** spec-docs-site-options, spec-docs-site-files
**Context:** context-factory

## Context

The documentation site needs facts from three domains. It needs the documentation model
`artifact-driven`, because the site renders the `docs/` tree of that model. It needs the
repository architecture `multiple`, because the site project lives in `apps/documentation/`.
It needs the ci-cd provider `github-actions`, because a workflow publishes the site. A domain
module in `services/factory/domain/` renders only the files of its own domain. It does not read
the options of `repo-arch` or `ci-cd`. A composition combines domains. The precedent is
`project-issues` in `services/factory/composition/artifact-driven/default.nix`: options,
assertions, a workflow, a JSON configuration file, and a wiki page in one block.

The user rule is: prefer simple Nix. Copy a file or add an authored file. Do not translate a
format in Nix.

## Options

1. Add a sub-module `services/factory/composition/artifact-driven/docs-site/` with
   `default.nix`, `_assets/`, and `tests/eval.nix`. Pro: the module can read the three domains,
   because it is a composition. Pro: `libs/nix/_importer.nix` finds each `default.nix` under
   `services/`, so no import list changes. Pro: the assets, the module, and the checks of the
   site are in one folder, apart from the `project-issues` block. Con: the artifact-driven
   composition then has two folders that declare options under
   `factory.composition.artifact-driven`.
2. Add an option `documentation.site.use` to the documentation domain in
   `services/factory/domain/documentation/`. Pro: one option group for all documentation
   settings. Con: the domain module would read `repo-arch.use` and `ci-cd.provider.use`, which
   breaks the rule that a domain renders only its own files. Con: the domain would emit a
   GitHub Actions workflow, which belongs to the ci-cd provider.
3. Add the options and the files to the existing `project-issues` file
   `services/factory/composition/artifact-driven/default.nix`. Pro: one file for the whole
   composition. Con: the file already holds the project-issues workflow and the role loader;
   ten more files and a second option group make it hard to read. Con: the check file of the
   composition would grow with checks that do not relate to each other.

## Decision

Option 1. The site needs three domains, so it is a composition. A sub-module keeps the code,
the assets, and the checks of the site in one place, and the importer finds it without a
change.

## Consequences

The generated repository gets `apps/documentation/` only when
`factory.composition.artifact-driven.docs-site.enable` is `true`. Nix owns one settings file,
`site.json`; the authored `docusaurus.config.js` reads it. The root `.gitignore` of the
repository is hand-written and does not change; a per-folder `apps/documentation/.gitignore`
covers the build output of the site. A consumer needs Node.js to run the site locally; the
factory does not add a devenv `languages.javascript` entry, and the wiki page tells the
consumer how to get Node.js. The single repository architecture and a second site generator
are out of scope; a later feature can add a second sub-module or a second option value.
