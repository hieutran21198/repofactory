# Specifications: Pull request comment permission

**Change:** [Permit pull request comments](../README.md)

## Solution

The generated workflow gives pull request write access to its automatic `GITHUB_TOKEN`. The
synchronizer uses this access only for its managed comment.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-comment-permission](spec-comment-permission.md) | Give the workflow access to write its managed comment. | req-portable-links |
