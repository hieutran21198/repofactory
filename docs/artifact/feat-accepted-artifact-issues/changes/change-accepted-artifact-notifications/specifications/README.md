# Specifications: Accepted artifact notifications

**Change:** [Send accepted artifact notifications](../README.md)

## Solution

Add an optional notification policy to the project issues composition. The synchronizer writes a
result document. A separate workflow step sends that result to Google Chat or Slack.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-accepted-artifact-notification](spec-accepted-artifact-notification.md) | Configure and deliver an acceptance summary. | req-accepted-artifact-notification |
