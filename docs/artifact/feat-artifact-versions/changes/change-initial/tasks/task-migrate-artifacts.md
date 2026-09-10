# task-migrate-artifacts: Migrate the existing features

**Plan:** [Implementation plan](README.md)
**Covers:** req-migrate-existing-features, req-change-is-unit-of-work, req-version-is-full-state, req-no-status, spec-migration, spec-artifact-layout
**Context:** context-factory

## Goal

The seven existing features in `docs/artifact/` follow spec-artifact-layout: the root artifacts are
in `changes/change-initial/`, each change README has `From`, `To`, and `Type`, and one version
folder holds the full state of each feature.

## Steps

Do this task after task-sync-classifier and task-eval-checks. The synchronizer must accept the new
tree before the tree changes.

1. Get the migration script. A copy is at
   `/tmp/claude-1000/-home-cirius-Workspaces-personal-repofactory/797fa126-4bbf-4953-a85d-44ea7856f517/scratchpad/migrate_artifacts.py`.
   Do not commit the script. If the copy is not available, do the mechanical steps of item 4 by
   hand or with the shell.
2. Make the script skip the folder `changes/change-artifact-versions` of
   `feat-accepted-artifact-issues`: exclude that folder in `plan_feature`. Reason: spec-migration
   gives `8.0.0` as the migrated version. The version `8.1.0` is produced by the phase 5 of that
   change, after the code of this feature exists. Without the exclusion, the script folds the new
   `spec-artifact-tree.md` into the version folder and prints `8.1.0`.
3. Run the dry run from the repository root: `nix-shell -p python3 --run "python3 <script>"`.
   Compare the printed changes, types, and versions with the table of spec-migration. The final
   versions are `8.0.0`, `3.0.0`, `1.1.0`, and `1.0.0` for the four other features. The script
   prints `skip feat-artifact-versions: already migrated`.
4. Run the script with `--apply`. For each feature the script does these mechanical steps: it
   copies the root `requirements/`, `specifications/`, and `decisions/` into
   `versions/<current>/`; it moves the root folders and `tasks/` into `changes/change-initial/`
   with `git mv`; it copies each `req-*.md`, `spec-*.md`, and `adr-*.md` of each change into the
   version folder in git order and stops on a name collision; it rewrites the three link forms of
   spec-migration item 5; it writes `changes/change-initial/README.md`; it inserts `**From:**`,
   `**To:**`, and the inferred `**Type:**` in each change README; it rewrites the feature README
   with `**Current version:**`, `## Current artifacts`, the `## Versions` table with the columns
   `Version`, `Change`, `Type`, and `Commits`, and the paragraph about the single version folder.
5. Add by hand one row to the `## Versions` table of
   `docs/artifact/feat-accepted-artifact-issues/README.md`, after the row `8.0.0`:
   `| 8.1.0 | [Artifact versions](changes/change-artifact-versions/README.md) | Specifications | <first commit, short form> |`.
   The change README already has `**From:** 8.0.0`, `**To:** 8.1.0`, and `**Type:** Specifications`.
   Do not change it. Its version folder does not exist yet.
6. Make the hand edits of spec-migration in the version folders only:
   - `feat-accepted-artifact-issues/versions/8.0.0/requirements/README.md`: the teardown table
     lists the 11 requirements; the sections reflect the whole feature.
   - `feat-accepted-artifact-issues/versions/8.0.0/specifications/README.md`: the teardown table
     lists the 17 specifications; `## Decisions` lists the 8 decisions with links inside the
     version folder.
   - `feat-accepted-artifact-issues/versions/8.0.0/specifications/spec-trello.md`: the board ID
     contract item with a link to `spec-resolve-trello-board-id.md`.
   - `feat-accepted-artifact-issues/versions/8.0.0/specifications/spec-provider-credential-guide.md`:
     `**Covers:** req-configurable-status`.
   - `feat-accepted-artifact-issues/versions/8.0.0/specifications/spec-accepted-artifact-notification.md`
     and `requirements/req-accepted-artifact-notification.md`: one `Superseded by` paragraph.
   - `feat-docs-site/versions/3.0.0/requirements/README.md`: 5 requirements.
   - `feat-docs-site/versions/3.0.0/specifications/README.md`: 7 specifications, 5 decisions.
   - `feat-docs-site/versions/3.0.0/specifications/spec-deployment-notification.md` and
     `requirements/req-deployment-notification.md`: one `Superseded by` paragraph.
   - `feat-single-repo-arch/versions/1.1.0/specifications/README.md`: 6 specifications, 3 decisions.
7. Rewrite `docs/artifact/README.md`: the columns `Feature`, `Version`, and `Summary`; one sentence
   after the table that says to read `versions/<current>/` of a feature for its state and
   `changes/` for its history. `feat-artifact-versions` has the version `none`.
8. Run the checks below. Correct a broken link in the version folder or in `change-initial`, then
   run the checks again.

## Check

1. `grep -rn '\.\./changes/' docs/artifact/*/versions docs/artifact/*/changes/change-initial` prints nothing.
2. `find docs/artifact/feat-* -maxdepth 1 -type d \( -name requirements -o -name specifications -o -name decisions -o -name tasks \)` prints nothing.
3. `ls -d docs/artifact/feat-*/versions/*/` lists one folder for each of the seven features and
   none for `feat-artifact-versions`.
4. `markdownlint --config .markdownlint.yaml docs/artifact` passes inside the devenv shell.
5. Each relative link in `docs/artifact/**/*.md` resolves to a file or a folder.
6. `docs/artifact/feat-accepted-artifact-issues/versions/8.0.0/specifications/README.md` links 17
   specifications, including `spec-resolve-trello-board-id.md`, and each link resolves inside the
   folder.
7. `docs/artifact/feat-accepted-artifact-issues/README.md` names `8.0.0` as the current version
   and has the rows `8.0.0` and `8.1.0`.
