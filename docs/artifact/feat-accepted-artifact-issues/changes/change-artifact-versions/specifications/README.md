# Specifications: Artifact versions

**Change:** [Artifact versions](../README.md)

## Solution

The synchronizer contract follows the new artifact layout. The feature README and every file
inside a change are artifacts. A file under `versions/` is a copy and is not an artifact. A file
in a root-level artifact folder is not a supported form. The Python code that implements this
contract changes under the feature `feat-artifact-versions`.

## Teardown specifications

| ID | Specification | Covers |
| --- | --- | --- |
| [spec-artifact-tree](spec-artifact-tree.md) | Classify each artifact path of the new layout and ignore the version folders. | req-artifact-hierarchy, req-portable-links |
