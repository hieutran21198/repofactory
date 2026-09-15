# req-docs-site-azure-pipelines-folder: Emit the docs-site pipeline in the selected folder

**Master:** [Requirements](README.md)
**Covers:** none (new requirement)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must emit the docs-site pipeline file `docs-site.yml` in the
selected Azure Pipelines folder. The trigger self-path in the pipeline must
use the selected folder.

## Acceptance criteria

- Given a repository that uses Azure Pipelines and leaves the folder option unset, when the factory emits the blueprint, then the docs-site pipeline path is `azure-pipelines/docs-site.yml`.
- Given a repository that uses Azure Pipelines and sets a custom folder, when the factory emits the blueprint, then the docs-site pipeline path is `<folder>/docs-site.yml`.
- Given a repository that uses Azure Pipelines and sets a custom folder, when the factory emits the blueprint, then the pipeline content is unchanged except the trigger self-path, which is `<folder>/docs-site.yml`.
- Given a repository that uses Azure Pipelines and sets a custom folder, when the factory emits the blueprint, then each Azure Pipelines path of the docs-site composition starts with the selected folder.
- Given a repository that sets an empty folder value, when the factory evaluates the blueprint, then it rejects the value with a clear error and emits no pipeline file.
- Given a repository that sets a folder value with an invalid path, when the factory evaluates the blueprint, then it rejects the value with a clear error and emits no pipeline file.
- Given a repository that uses GitHub Actions, when the factory emits the blueprint, then the folder option changes no GitHub Actions path.

## Notes

The folder option `factory.domain.ci-cd.provider.azure-pipelines.folder`
exists, with validation for empty and invalid values. This change needs no
new domain option. Audit result: `services/factory/composition/artifact-driven/docs-site/default.nix`
hardcodes the folder at line 281 (the trigger self-path) and at line 571
(the emission path). `services/factory/composition/artifact-driven/default.nix`
already uses the folder variable for the project-issues pipeline at line 475.
Test files (`docs-site/tests/eval.nix`, `composition/artifact-driven/tests/eval.nix`)
and the user guide (`docs-site/_assets/.../docs-site.md`) name the default
path. They stay valid for the default folder. The specifications phase
decides whether the guide text follows the selected folder.
