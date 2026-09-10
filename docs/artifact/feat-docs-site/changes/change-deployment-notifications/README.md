# Change: Send documentation site deployment notifications

**Feature:** [Documentation site](../../README.md)
**From:** 1.0.0
**To:** 2.0.0
**Type:** Requirements

## Reason

A repository maintainer can miss a successful documentation site deployment. GitHub Pages shows
the result, but it does not send a message to the maintainer's team.

## Effect

The documentation site workflow can send one message to a Google Chat space or a Slack channel.
The workflow sends the message only after GitHub Pages deploys the site.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)
