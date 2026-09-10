# Specifications: DDD review skill

The artifact-driven composition registers one shared DDD review skill when DDD guidance exists.
The skill reports domain-artifact findings and leaves each phase owner responsible for a change.

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-ddd-review-skill-location](spec-ddd-review-skill-location.md) | Register and render the shared skill. | req-ddd-review-skill-shipped, req-ddd-review-skill-selection |
| [spec-ddd-review-skill-content](spec-ddd-review-skill-content.md) | Define the review procedure and report format. | req-ddd-review-guidance |

## Requirement coverage

| Requirement | Specifications |
| --- | --- |
| req-ddd-review-skill-shipped | spec-ddd-review-skill-location |
| req-ddd-review-guidance | spec-ddd-review-skill-content |
| req-ddd-review-skill-selection | spec-ddd-review-skill-location |
