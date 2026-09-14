# spec-publish-rule: Provider publishes its contract with each release

**Master:** [Specifications](README.md)
**Covers:** req-polyrepo-publish
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

This specification defines where the provider team publishes its contract and how the consumer team reads it. Publication occurs with each release. No central registry is necessary. The consumer team reads the contract that matches the release that it uses.

## Contract

The provider team publishes the contract file as a release asset. The release tag identifies the contract version. The consumer team reads the contract by release tag.

```text
<provider-repo>/releases/<release-tag>/contract-<surface>.<ext>
<provider-repo>/releases/latest/contract-<surface>.<ext>

# Example
payments/releases/v2.3.0/contract-payments-api.openapi.yaml
payments/releases/latest/contract-payments-api.openapi.yaml
```

Publication rules:

- Each release includes the contract file for each wire surface that the release ships.
- The `latest` link points to the contract of the newest release.
- A release with no wire change republishes the prior contract file under the new release tag.
- The contract file beside the specification is the source. The release asset is the published copy. Both files have the same content for the same release.

Consumer read path:

1. The consumer team selects the release tag that it uses.
2. The consumer team reads the contract asset for that tag.
3. The consumer team compares two tags to list each added, altered, and removed operation.

Version rule for contract changes:

| Contract change | Release bump | Gate result |
| --- | --- | --- |
| Compatible addition only | Minor bump at least | All three gates pass |
| Breaking change | Major bump | Comparison gate reports breaking; provider team informs each consumer team |
| No wire change | Patch bump or no bump per team rule | Gates pass; contract file content does not change |

## Errors

| Condition | Response |
| --- | --- |
| A new release has no contract asset | The release fails acceptance. The provider team adds the contract and reruns the gates. |
| The published contract does not match the release | The verification gate fails. The provider team republishes the correct contract under a new patch release. |
| A consumer team requests an unknown release tag | The read path returns `release-not-found` and lists the available tags. |
| A consumer team requests the contract with no new release | The read path returns the last published contract under `latest`. |
| Two releases cannot be compared | The read path returns `baseline-missing` and names the release without a contract. |
