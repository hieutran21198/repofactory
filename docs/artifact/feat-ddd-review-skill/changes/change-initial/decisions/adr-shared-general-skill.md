# adr-shared-general-skill: Register the DDD review as a general skill

**Master:** [Decisions](README.md)
**Context:** context-factory

## Context

The requirement expert and the solution expert both review DDD artifacts. The review must use one
procedure and must not give either role ownership of the other role's phase.

## Options

1. Put one `ddd-review` folder under a role-specific skill folder for each expert. This gives role
   context, but duplicates the source and risks a name collision in general skills.
2. Put one `ddd-review` folder in the shared skill assets and register it as a general skill. This
   keeps one source and lets every configured harness load it.
3. Add the review checklist directly to both role bodies. This avoids a skill, but duplicates the
   procedure and makes ad-hoc review less clear.

## Decision

Select option 2. The composition registers one shared `ddd-review` skill as a general skill only
for a project that selects artifact-driven documentation, DDD, and a repository architecture.

## Consequences

The skill is available to both phase owners without a role-body change. It remains a review tool,
so the requirement expert owns phase 1 and the solution expert owns phases 2 and 3.
