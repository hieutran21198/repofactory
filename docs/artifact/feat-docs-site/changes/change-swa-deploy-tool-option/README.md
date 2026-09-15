# Change: Add Static Web App deploy tool option

**Feature:** [Documentation site](../../README.md)
**From:** 6.1.0
**To:** 7.0.0
**Type:** Requirements

## Reason

The Azure Pipelines log shows that the deploy to Azure Static Web Apps takes
about 64 seconds in total. The container pull takes about 27 seconds. The
image is larger than 500 MB, it pulls on each run (`--pull=always`), and the
hosted agents keep no cache. The zip and upload step takes about 1 second.
The build output is only about 23 MB (about 2.2 MB compressed), it is already
minified, and it has no sourcemaps. The Azure-side polling takes about
32 seconds, and the factory cannot reduce it.

The repository maintainer wants a choice. A self-installed pinned SWA CLI
(about 70 MB) skips the container pull. Conservative users keep the official
task. Both CI providers give the same deployment result. Notifications and
hooks do not change.

## Artifacts

- [Requirements](requirements/README.md)
