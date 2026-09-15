# req-release-role: Own the mechanical phase 5 copy

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The artifact release expert must own phase 5. It must copy and delete files
only. It must not edit a file. It must not run a domain-driven design step.
It must use a low-cost model or a script with verification.

## Acceptance criteria

- Given a change with code, when phase 5 starts, then the artifact release expert owns the version copy.
- Given a file under `versions/`, when the artifact release expert copies it, then the copy keeps the same content.
- Given phase 5, when the artifact release expert works, then it makes no edit and runs no design step.
- Given the version copy, when the artifact release expert ends it, then a check confirms the copy before the commit.

## Notes

The solution expert keeps the version gate only. It confirms that the change
is ready for release. It does not copy files.
