# req-ownership-boundary: Keep business rules outside the Design artifact

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The Design artifact must not own business behavior, domain rules, permissions, or constraints.
Requirements, Specs, and ADRs must keep ownership of those items.

## Acceptance criteria

- Given a business behavior, a domain rule, a permission, or a constraint, when the team changes it, then the team changes Requirements, Specs, or ADRs, not the Design artifact.
- Given a conflict between the Design artifact and the Requirements, the Specs, or the ADRs, when the team resolves it, then the Requirements, the Specs, or the ADRs win.

## Notes

The Design artifact shows how the feature looks and behaves for the user. It does not define
what the feature is permitted to do.
