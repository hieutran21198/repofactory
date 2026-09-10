# Implementation plan: Documentation site

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [task-add-docs-site-module](task-add-docs-site-module.md) | - |
| 2 | [task-write-site-scaffold](task-write-site-scaffold.md) | 1 |
| 3 | [task-write-docs-site-workflow](task-write-docs-site-workflow.md) | 1 |
| 4 | [task-write-docs-site-guide](task-write-docs-site-guide.md) | 1 |
| 5 | [task-add-eval-checks](task-add-eval-checks.md) | 1, 2, 3, 4 |
| 6 | [task-verify-generation](task-verify-generation.md) | 5 |

Task 1 makes the module folder, the options, the assertions, and the file entries. Tasks 2, 3,
and 4 write the assets that the file entries name: the site project, the workflow, and the wiki
page. They are independent of each other. Task 5 needs the module and all assets, because its
checks read them. Task 6 needs the checks to pass first; it renders the site in this repository
and builds it.

All tasks touch one component, `services/factory`, and one context, `context-factory`.

## Definition of done

- The module `services/factory/composition/artifact-driven/docs-site/default.nix` declares the
  four options and the six assertions of `spec-docs-site-options`.
- The module emits the ten files of `spec-docs-site-files` with the copy modes of that
  specification when the option is on, and nothing when the option is off.
- `docusaurus.config.js` has each setting of `spec-docusaurus-config`.
- `.github/workflows/docs-site.yml` has the trigger, the jobs, and the steps of
  `spec-docs-site-workflow`.
- The thirteen checks of `spec-eval-checks` pass, and the checks of the parent composition
  still pass.
- With the option on in this repository, `npm ci` and `npm run build` succeed in
  `apps/documentation/`, the build has the home page and the generated index pages, and the
  build has no page for the templates.
- The acceptance criteria of each requirement pass.
