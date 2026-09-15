# adr-composition-owned-policy: Keep lifecycle policy in the composition

**Relates to:** spec-composition-options
**Context:** context-factory

## Context

The artifact status map defines how the artifact-driven documentation model, GitHub Actions, and a
project-management adapter work together. It is not a capability or connection setting of the
project-management adapter. Adapter selection must also remain independent from activation of a
specific composition.

## Options

1. Keep statuses and activation in the project-management domain. Pro: all project settings have
   one option prefix. Con: one domain owns a cross-domain lifecycle and selecting an adapter
   activates a composition.
2. Move statuses and activation to the artifact-driven project-issues composition. Keep targets
   and credentials in provider adapters. Pro: policy and activation have the same owner, while
   adapters keep their connection settings. Con: one generated configuration reads two option
   groups.
3. Move statuses, targets, and credentials to the composition. Pro: all integration values have
   one option prefix. Con: adapter connection settings leave the adapter that defines them.

## Decision

Use option 2. The composition owns `enable` and `artifact-status`. The provider domain owns
adapter selection. The selected adapter owns its target and credential settings.

## Consequences

Selecting an adapter does not generate files. An enabled composition validates its domain
dependencies and the settings of the selected adapter. The old domain-level artifact status
option is removed without a compatibility alias.
