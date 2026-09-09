# task-write-synchronization-result: Write the synchronization result

**Plan:** [Implementation plan](README.md)
**Covers:** req-accepted-artifact-notification, spec-accepted-artifact-notification
**Context:** context-factory

## Work

1. Record one structured result for each changed artifact file.
2. Map pull request file states to the public notification change values.
3. Write the JSON result after synchronization succeeds when an output path is configured.
4. Keep implicit parent synchronization out of the notification result.
5. Add unit tests for each change type and an empty result.

## Verification

Run the artifact synchronizer unit tests.
