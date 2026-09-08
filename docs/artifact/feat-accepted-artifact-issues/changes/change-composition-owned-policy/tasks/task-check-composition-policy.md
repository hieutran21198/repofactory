# task-check-composition-policy: Check activation and validation

**Plan:** [Implementation plan](README.md)
**Covers:** req-configurable-status, req-accepted-only, spec-composition-options
**Context:** context-factory

## Goal

Prove that explicit composition activation controls generation and validation.

## Steps

1. Check that adapter selection alone emits no integration files.
2. Check generated files and configuration for both supported adapters.
3. Check every incompatible domain selection.
4. Check missing targets, invalid secret names, and empty statuses.
5. Run synchronizer, workflow, Nix, and repository checks.

## Check

All valid evaluation cases pass, and every invalid enabled case reports an assertion.
