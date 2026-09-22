# Change: Harness owns each MCP setting

**Feature:** [UX Design](../../README.md)
**From:** 1.0.0
**To:** 1.1.0
**Type:** Specifications

## Reason

The factory maintainer needs a clear ownership boundary for the design tool
integration. Today the cross-domain Figma MCP configuration lives in the
artifact-driven composition. The harness area must own each harness MCP
setting instead. The design-tool area keeps only the `use` selection with the
default `unset`. This change moves the contract ownership without changing
the business need. The requirement `req-design-tool` stays valid: the
designer expert uses the optional tool when the repository selects it and
still produces the full Design artifact without it.

## Artifacts

No specification files exist yet in this change. Phase 2 adds the specifications.
