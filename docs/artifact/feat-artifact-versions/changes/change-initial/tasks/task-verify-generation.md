# task-verify-generation: Render the generated files and run all checks

**Plan:** [Implementation plan](README.md)
**Covers:** req-roles-follow-model, req-sync-ignores-versions, req-migrate-existing-features, spec-wiki-model, spec-template-tree, spec-expert-role-skill, spec-guidance-pages, spec-eval-checks, spec-migration
**Context:** context-factory

## Goal

The generated files of this repository match their sources, and each check of this change passes
on the final tree.

## Steps

1. From the repository root, run `devenv shell` and exit. The shell renders
   `docs/wiki/documentation/artifact-driven/`, `AGENTS.md`, the role file of each harness in use
   (`.claude/agents/`, `.opencode/`, `.codex/`), the skills under `.claude/skills/`, and the
   configuration of `apps/documentation`.
2. Run `git status`. Confirm that the generated copies changed with their sources:
   `docs/wiki/documentation/artifact-driven/README.md` has `### Phase 5: Version`;
   `docs/wiki/documentation/artifact-driven/templates/change/` exists and
   `templates/feature/` holds only `README.md`; `.claude/agents/solution-expert.md` has
   `## Procedure: phase 5, version`; `AGENTS.md` names `changes/change-<name>/` and
   `versions/<version>/`. Do not edit a generated copy. If a copy is wrong, correct its source
   under `services/factory` and run the shell again.
3. Run `git diff --check`. It prints nothing.
4. Run the four Nix checks:
   `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`,
   `nix-instantiate --eval --strict services/factory/domain/documentation/artifact-driven/tests/eval.nix`,
   `nix-instantiate --eval --strict services/factory/composition/artifact-driven/docs-site/tests/eval.nix`,
   and `nix-instantiate --eval --strict services/factory/domain/design/ddd/tests/eval.nix`.
5. Run the Python tests with `nix-shell -p python3 --run "..."` from the repository root, or
   inside the `e2e/` devenv shell:
   `python3 services/factory/composition/artifact-driven/tests/test_sync.py`,
   `python3 services/factory/composition/artifact-driven/tests/test_notify.py`, and, from `e2e/`,
   `python3 accepted-artifact-issues/test_e2e.py`.
6. Run `npm ci && npm run build` in `apps/documentation`. The routes under
   `docs/artifact/feat-accepted-artifact-issues/versions/8.0.0/` build. The site generates the
   index page of the version folder.
7. Read test: open `docs/artifact/feat-accepted-artifact-issues/versions/8.0.0/specifications/README.md`
   and follow each of the 17 links. Each link opens a file in the same folder.

## Check

Each command of steps 3 to 6 exits with 0. `git diff --check` prints nothing. The build of
`apps/documentation` reports warnings for broken links at most (`onBrokenLinks: 'warn'`) and no
error. Step 7 finds the 17 specifications, including `spec-resolve-trello-board-id.md`.
