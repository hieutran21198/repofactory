# spec-eval-checks: Nix evaluation checks of the model

**Master:** [Specifications](README.md)
**Covers:** req-roles-follow-model, req-sync-ignores-versions
**Context:** context-factory

## Description

Two Nix check files verify that the seeded files describe the model of
[spec-artifact-layout](spec-artifact-layout.md). Each check is one named boolean. Each check
reads the source text under `services/factory` with `builtins.readFile` and tests it with
`builtins.match`. A check does not read a generated file.

The Python tests of the synchronizer are listed in
[spec-sync-classifier](spec-sync-classifier.md). This specification does not repeat them.

## Contract

### The composition check

File: `services/factory/composition/artifact-driven/tests/eval.nix`.

Command: `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.

The pattern `".*solution expert.*phases 2 and 3.*"` in `dddReviewContent` becomes
`".*solution expert.*phases 2, 3, and 5.*"`.

The file gets these named assertions. Each name is in the `assert` list and in the returned
attribute set. A pattern is a `builtins.match` pattern on the whole source text.

| Name | Source | Pattern |
| --- | --- | --- |
| `rolesNameVersions` | `_assets/agent/role/requirement-expert/ROLE.md` and `_assets/agent/role/solution-expert/ROLE.md` | Both match `.*versions/<current>.*` and `.*changes/change-<name>.*`. |
| `solutionExpertHasPhaseFive` | `_assets/agent/role/solution-expert/ROLE.md` | Matches `.*## Procedure: phase 5, version.*`. |
| `requirementExpertHasNoLegacyProcedure` | `_assets/agent/role/requirement-expert/ROLE.md` | Does not match `.*## Change to a feature whose code exists.*`. |
| `roleTemplateHasNoRootTasks` | `_assets/agent/skill/by-role/solution-expert/expert-role/references/role-template.md` | Does not match `.*feat-<name>/tasks/.*`. |
| `agentsNameVersions` | `_assets/multiple/AGENTS.md`, `_assets/multiple/ddd/AGENTS.md`, `_assets/single/AGENTS.md`, `_assets/single/ddd/AGENTS.md` | All four match `.*versions/.*` and `.*changes/change-<name>.*`. |
| `dddPageHasVersionRow` | `_assets/multiple/ddd/docs/wiki/design/ddd/artifact-driven.md` and `_assets/single/ddd/docs/wiki/design/ddd/artifact-driven.md` | Both match `.*\| 5 Version \| Solution expert \|.*`. |
| `dddReviewNamesPhaseFive` | `_assets/agent/skill/ddd-review/SKILL.md` | Matches `.*solution expert.*phases 2, 3, and 5.*` (the pattern change above). |
| `descriptions` | `cfg.factory.domain.agent.role.builder.solution-expert.description` of an evaluated configuration | Matches `.*phases 2, 3, and 5.*`. |

The paths in the table are relative to `services/factory/composition/artifact-driven/`. In a Nix
string, write `\|` as `\\|`.

### The domain check

File: `services/factory/domain/documentation/artifact-driven/tests/eval.nix`. This file is new.

Command: `nix-instantiate --eval --strict services/factory/domain/documentation/artifact-driven/tests/eval.nix`.

The file has the shape of `services/factory/domain/design/ddd/tests/eval.nix`: a local `lib`
with `mkIf`, and an evaluation of `../default.nix` with `documentation.use = "artifact-driven"`
and with another value. The assets root is
`services/factory/domain/documentation/artifact-driven/_assets/docs/wiki/documentation/artifact-driven/`.
`templates/` below is relative to this root.

| Name | Check |
| --- | --- |
| `filesOn` | With `use = "artifact-driven"`, the three file entries exist: `docs/wiki/documentation/artifact-driven/README.md` with `copyMode = "copy"`, `docs/wiki/documentation/artifact-driven/templates` with `copyMode = "copy"`, and `docs/artifact/README.md` with `copyMode = "seed"`. |
| `filesOff` | With another `use` value, `files` is empty. |
| `sourcesExist` | `builtins.pathExists` is true for the source of each file entry. |
| `templateTree` | `builtins.pathExists` is true for `templates/feature/README.md`, `templates/change/README.md`, `templates/change/requirements/README.md`, `templates/change/requirements/req-name.md`, `templates/change/specifications/README.md`, `templates/change/specifications/spec-name.md`, `templates/change/decisions/adr-name.md`, `templates/change/tasks/README.md`, and `templates/change/tasks/task-name.md`. |
| `legacyTemplatesAbsent` | `builtins.pathExists` is false for `templates/feature/requirements`, `templates/feature/specifications`, `templates/feature/decisions`, and `templates/feature/tasks`. |
| `wikiHasPhases` | The wiki `README.md` source matches `.*### Phase 1: Requirements.*### Phase 2: Specifications.*### Phase 3: Plan.*### Phase 4: Implementation.*### Phase 5: Version.*` and `.*## Removed artifacts.*`. It does not match `.*update the master artifacts.*`. |
| `changeTemplateHasHeader` | `templates/change/README.md` matches `.*\*\*From:\*\*.*\*\*To:\*\*.*\*\*Type:\*\*.*## Removed artifacts.*`. |
| `featureTemplateHasVersion` | `templates/feature/README.md` matches `.*\*\*Current version:\*\*.*\| Version \| Change \|.*`. |
| `noStatusInTemplates` | No file under `templates/` matches `.*\*\*Status:\*\*.*`. |

Each name is in the `assert` list and in the returned attribute set.

## Errors

- An assertion fails. The evaluation stops. The error names the assertion.
- A source file does not exist. `builtins.readFile` fails and names the path.
