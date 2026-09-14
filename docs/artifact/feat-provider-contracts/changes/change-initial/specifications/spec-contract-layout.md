# spec-contract-layout: Contract file for each wire surface

**Master:** [Specifications](README.md)
**Covers:** req-provider-contract
**Context:** context-factory
**Aggregate:** agg-repository-blueprint

## Description

This specification defines the contract file that each provider component owns. It gives the file place, the link rule, and the normative source rule. It defines the conformance interface for deferred language selection. The downstream team selects the language for each wire surface within the allowed set.

## Contract

One provider component with a wire surface owns one machine-readable contract file. The file lives beside its specification. The specification links the file. The file is the normative source for the wire surface.

```text
docs/artifact/feat-provider-contracts/changes/change-initial/specifications/contract-<surface>.<ext>
docs/artifact/feat-provider-contracts/versions/<version>/specifications/contract-<surface>.<ext>

# <surface>: lowercase letters, digits, hyphens. One file for each wire surface.
# <ext>: the file type for the selected language (see language table).
```

The specification links the machine file under `## Contract`:

```markdown
## Contract

- Machine file: [contract-<surface>.<ext>](contract-<surface>.<ext>)
- Language: OpenAPI (or the selected language from the table below)
- Normative source: the machine file. The prose in this specification does not replace it.
```

Allowed languages and selection rule:

| Wire surface | Allowed languages | Primary language | Selection rule |
| --- | --- | --- | --- |
| Synchronous HTTP API | OpenAPI, JSON Schema | OpenAPI | The downstream team selects OpenAPI unless the surface has no HTTP operations. |
| Event stream | AsyncAPI, JSON Schema | AsyncAPI | The downstream team selects AsyncAPI for each event surface. |
| Binary RPC | Protobuf, JSON Schema | Protobuf | The downstream team selects Protobuf for each RPC surface. |
| Other wire surface | OpenAPI, AsyncAPI, Protobuf, JSON Schema | OpenAPI | The downstream team selects the language that describes each operation. The team records the reason. |

Conformance criteria for any selected language:

- The file uses the allowed language for its surface.
- The file describes each operation that a consumer team can use.
- The file names each operation with a stable identifier.
- The file is machine-readable. A tool can parse it without human help.
- A surface with no consumer needs no contract file.

## Errors

| Condition | Response |
| --- | --- |
| A wire surface has no contract file and has one or more consumers | The provider change fails. The provider team writes the file before release. |
| Two contract files claim the same wire surface | The provider change fails. The provider team keeps one file and removes the other. |
| The contract file uses a language outside the allowed set | The provider change fails. The downstream team selects an allowed language. |
| The contract file does not parse | The lint gate fails and names the parse error. |
| The contract file omits an operation that the provider serves | The verification gate fails and names the missing operation. |
