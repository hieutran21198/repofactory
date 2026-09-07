# req-domain-model-artifacts: Keep the domain model in one shared location

**Master:** [Requirements](README.md)
**Priority:** Must

## Statement

A project that selects DDD must get one shared location for its domain model and one template
for each domain artifact.

## Acceptance criteria

- Given a project that selects DDD, when the factory generates the files, then the project has a domain model location with an index, a context map, and a glossary.
- Given the domain model location, when a user edits its files, then the factory does not overwrite the edits.
- Given the templates, when a user adds a bounded context, then a template exists for the bounded context and a template exists for an aggregate.
- Given a feature artifact, when it relates to a bounded context or an aggregate, then the guide says how the artifact points to the domain artifact.

## Notes

The domain model is shared by all features. It does not belong to one feature folder.
