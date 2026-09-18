# Implementation plan: Documentation site

**Change:** [Sidebar sort order](../../../changes/change-sidebar-sort-order/README.md)

## Order of work

All tasks use `services/factory`, `context-factory`, and `agg-repository-blueprint`. Thus, phase 4
must do the tasks in sequence. The option and JSON data path are upstream from the JavaScript
consumer. The evaluation checks and the Docusaurus build follow both implementation tasks.

| Step | Task | Depends on | can-parallel |
| --- | --- | --- | --- |
| 1 | [task-add-feature-order-data-path](task-add-feature-order-data-path.md) | none | no |
| 2 | [task-implement-sidebar-comparator](task-implement-sidebar-comparator.md) | task-add-feature-order-data-path | no |
| 3 | [task-check-feature-order-evaluation](task-check-feature-order-evaluation.md) | task-implement-sidebar-comparator | no |
| 4 | [task-verify-sidebar-build](task-verify-sidebar-build.md) | task-check-feature-order-evaluation | no |

## Dependency table

| Upstream task | Downstream task | Relation | Reason |
| --- | --- | --- | --- |
| task-add-feature-order-data-path | task-implement-sidebar-comparator | Data dependency | The generic asset reads the `featureOrder` value that the composition writes. |
| task-implement-sidebar-comparator | task-check-feature-order-evaluation | Verification dependency | The evaluation checks inspect the final generic asset and the final JSON data. |
| task-check-feature-order-evaluation | task-verify-sidebar-build | Verification dependency | The Docusaurus build starts after the Nix interface and data checks pass. |

## Parallel groups

| Group | Tasks | Start condition |
| --- | --- | --- |
| 1 | task-add-feature-order-data-path | The approved phase 3 plan is available. |
| 2 | task-implement-sidebar-comparator | Group 1 completes its source changes. |
| 3 | task-check-feature-order-evaluation | Group 2 completes its source changes. |
| 4 | task-verify-sidebar-build | Group 3 passes both Nix evaluations. |

Each group has one task. No task can run in parallel because all tasks use the same component,
context, and aggregate.

## Verification split

The Nix evaluation verifies the declared option shape, defaults, assertions, JSON values, copy
modes, and required generic-asset text. It does not execute the sidebar comparator or its helpers.

The Docusaurus build executes the comparator. The `theme-doc-sidebar-menu` element in each
applicable `build/<route>/index.html` file verifies the observable order.

## Owner selection

`task-add-feature-order-data-path` changes the tracked root `devenv.nix` module. The artifact
master must select an owner for that step before phase 4 starts.

**OWNER ADVICE:** Extend the factory implementation owner's boundary to the root `devenv.nix`
option value and the rendered docs-site files. The option selects the factory interface that the
same task adds. This selection keeps the data-path change in one unit. If that owner cannot accept
the root boundary, use the `expert-role` skill to select a repository-configuration owner.

## Feasibility resolutions

| Constraint | Resolution |
| --- | --- |
| FD-01 | The artifact master selects the owner for the root `devenv.nix` step. The plan gives owner advice above. |
| FD-02 | The phase 4 commit includes the rendered `apps/documentation/site.json`. |
| FD-03 | The data-path task has no independent Nix check. The evaluation task supplies and runs the final round-trip checks. |
| FC-01 | `withIndexes` captures source identity from docs and category metadata before sorting. It does not assume public items have `source`. |
| FC-02 | The comparator reads captured identities for feature, phase, version, change, and tie-break rules. |
| FC-03 | The phase 4 commit includes the regenerated `apps/documentation/docusaurus.config.js`. No task hand-edits it. |
| FC-04 | The comparator uses `Array.from` or `codePointAt` for code-point order. |
| FC-05 | Nix checks asset text only. Docusaurus verifies helper behavior. |
| FE-01 | The evaluation checks the declared `listOf str` shape. It does not claim module-system wrong-type rejection. |
| FE-02 | The docs-site evaluation covers the change. The composition evaluation is a regression guard only. |
| FE-03 | Each JavaScript regex pattern escapes or brackets its metacharacters. |
| FB-01 | Build verification extracts `theme-doc-sidebar-menu` from rendered route HTML. |
| FB-02 | The absent-field build runs directly after the temporary JSON edit and before another shell entry. |
| FB-03 | The commit boundary includes both regenerated tracked documentation files. |
| FB-04 | Temporary partial and empty lists use tracked `devenv.nix`; the task restores it and `site.json`. |
| FB-05 | A temporary fixture supplies case-differing and non-BMP labels. The task removes the fixture before commit. |

## Coverage

| Artifact | Tasks |
| --- | --- |
| `req-sidebar-sort-order` | `task-implement-sidebar-comparator`, `task-verify-sidebar-build` |
| `req-sidebar-feature-order-option` | `task-add-feature-order-data-path`, `task-check-feature-order-evaluation`, `task-verify-sidebar-build` |
| `spec-docusaurus-config` | `task-implement-sidebar-comparator`, `task-check-feature-order-evaluation`, `task-verify-sidebar-build` |
| `spec-docs-site-options` | `task-add-feature-order-data-path`, `task-check-feature-order-evaluation` |
| `spec-docs-site-files` | `task-add-feature-order-data-path`, `task-check-feature-order-evaluation`, `task-verify-sidebar-build` |

## Phase 4 commit boundary

Put all tracked source changes and required rendered data in one phase 4 commit. The intended
files include the root `devenv.nix`, rendered `apps/documentation/site.json`, and regenerated
`apps/documentation/docusaurus.config.js`. Do not hand-edit either rendered file. Do not commit a
temporary verification value, fixture, or build output.

## Definition of done

- The check of each task passes.
- Both Nix evaluation commands exit with status zero.
- The Docusaurus build exits with status zero and executes the comparator.
- The extracted sidebar menus meet both changed requirements.
- `site.json.featureOrder` equals the selected option list.
- The generic asset contains no repository-specific feature list.
- The two tracked documentation files contain their final regenerated bytes.
- The user guide bytes and all copy modes stay unchanged.
- Only the intended phase 4 files occur in the final commit.
