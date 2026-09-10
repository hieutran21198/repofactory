# req-single-guidance: Point the guidance at the single repository architecture

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

When `repo-arch.use` is `single` and `documentation.use` is `artifact-driven`, the generated
agent guidance and the knowledge indexes must point at the single repository architecture page,
with and without the DDD design method.

## Acceptance criteria

- Given `repo-arch.use = "single"` and `documentation.use = "artifact-driven"`, when the
  generator configures `AGENTS.md`, then the file names
  `docs/wiki/repo-arch/single-repository.md` and gives the directories of the single repository
  architecture.
- Given the same options, when the generator configures `docs/wiki/README.md`, then the file
  links to the single repository architecture page.
- Given the same options and `design.use = "ddd"`, when the generator configures `AGENTS.md` and
  `docs/wiki/README.md`, then the files also link to the DDD pages.
- Given `repo-arch.use = "multiple"`, when the generator configures the guidance, then the files
  do not name the single repository architecture page.
- Given the solution expert role, when a user reads its read list, then it names the repository
  architecture page in a way that is correct for both architectures.

## Notes

The multiple repositories architecture already has its guidance variants in the artifact-driven
composition. The single repository architecture uses the same mechanism.
