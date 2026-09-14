# Change: Initial

**Feature:** [Provider contracts](../../README.md)
**From:** none
**To:** 1.0.0
**Type:** Requirements

## Reason

Teams deploy polyrepo components independently. A provider team changes its wire surface, and a
downstream consumer breaks without detection. The business needs provider-owned, machine-readable
contracts with acceptance gates, so consumer teams find breaking changes before they deploy.

## Artifacts

- [Requirements](requirements/README.md)
