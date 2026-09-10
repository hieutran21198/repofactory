# Change: Fix workflow watch path indentation

**Feature:** [Documentation site](../../README.md)
**From:** 4.0.2
**To:** 4.0.3
**Type:** Correction

## Reason

The workflow template strips six spaces from literal lines. It does not strip spaces in an
interpolated watch path. The renderer adds twelve spaces, so a configured path is deeper than the
factory path list. GitHub Actions rejects the generated YAML.

The renderer must add six spaces before a configured watch path. The evaluation must check the
exact generated line.

## Artifacts

- [Corrected workflow specification](specifications/spec-docs-site-workflow.md)
- [Implementation plan](tasks/README.md)
