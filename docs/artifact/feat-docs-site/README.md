# Feature: Documentation site

## Summary

This feature adds a documentation website to the factory. The website renders the `docs/` tree
of a generated repository and publishes it to GitHub Pages on each push to the default branch. A
project configures a title, a site URL, and a base URL. It can also send deployment messages to
Google Chat, Slack, and Telegram after a successful deployment.

## Artifacts

- [Requirements](requirements/README.md)
- [Specifications](specifications/README.md)
- [Decisions](decisions/)
- [Implementation plan](tasks/README.md)

## Changes

- [Send documentation site deployment notifications](changes/change-deployment-notifications/README.md)
- [Use multiple deployment notification providers](changes/change-multi-provider-deployment-notifications/README.md)
