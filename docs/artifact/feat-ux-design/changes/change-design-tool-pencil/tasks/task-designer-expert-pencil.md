# task-designer-expert-pencil: Update the designer expert Pencil contract

**Plan:** [Implementation plan](README.md)
**Covers:** req-design-tool, spec-ux-design-option, spec-pencil-mcp, spec-designer-expert
**Context:** context-factory
**Component:** `services/factory`
**Aggregate:** agg-repository-blueprint
**Depends on:** task-codex-harness-pencil
**can-parallel:** no
**Parallel reason:** This task consumes the completed adapter contracts and changes the same context and aggregate.

## Goal

Make the designer expert contract accept the three `use` values and constrain Pencil to the local
pen.dev host and the open `.pen` document. Prove the composition signal handoff.

## Scope

- `services/factory/composition/artifact-driven/_assets/agent/role/designer-expert/ROLE.md`
- `services/factory/composition/artifact-driven/tests/eval.nix`

This task changes no other file.

## Decisions

- `adr-design-tool-selection`
- `adr-repository-blueprint-pattern`

## Steps

1. In the `## Design tool` section of the role body, name the values `unset`, `figma`, and
   `pencil`.
2. Keep the Figma chain `selected harness -> MCP -> figma-ui-mcp -> Figma Desktop`.
3. Add the Pencil chain `selected harness -> MCP entry pencil -> local pen.dev host -> open .pen
   document`.
4. State that the Pencil adapter permits only the local pen.dev host and the open `.pen` document.
5. State that the adapter grants no remote endpoint and no filesystem privilege.
6. State that the user selects the target document by opening it in pen.dev.
7. State that the designer expert produces the full Design artifact for `unset`, an unavailable
   tool, and a failed operation.
8. Keep the rule that an external design is working material and the Markdown Design artifact is
   the repository record.
9. Keep the substrings that the unchanged assertions match: `figma-ui-mcp` before `Figma Desktop`,
   and ``When `use` is `unset` `` before `full Design artifact without the tool`.
10. Do not change the other sections of the role body.
11. In the composition evaluation, add a `pencil` fixture with UX Design on, all three harnesses
    selected, and an unrelated OpenCode setting.
12. Assert that the composition sets the internal `ux-design.enable` signal to `true` for this
    fixture.
13. Assert that the composition writes no `mcp`, `mcp_servers`, or `.mcp.json` value for this
    fixture.
14. Assert that this fixture keeps the designer expert and the Design template.
15. Add the role assertions. Use whole-string, case-sensitive `builtins.match` patterns. Give each
    pattern a leading and a trailing `.*`. Escape each metacharacter, including the dot in `.pen`.
16. The role assertions cover these items: the role body names the three values; the Pencil chain
    uses the local host and the open `.pen` document; the adapter grants no remote or filesystem
    privilege; and the full Design artifact does not depend on a tool.
17. Keep the existing Figma, off-state, and UX Design assertions unchanged.
18. Do not add an event mechanism to the composition or the evaluation.

## Check

1. Run `nix-instantiate --eval --strict services/factory/composition/artifact-driven/tests/eval.nix`.
2. Confirm that all Boolean assertions pass.
3. Confirm that the role body accepts the three values and states the Pencil constraint.
4. Confirm that each new pattern keeps the matched substrings of the unchanged assertions, escapes
   each metacharacter, including the dot in `.pen`, and has a leading and a trailing `.*`.
5. Confirm that the composition sets only the internal signal and writes no MCP setting for the
   `pencil` fixture.
6. Confirm that the off fixtures and their assertions stay unchanged.

## Definition of done

- The role body names `unset`, `figma`, and `pencil`, and states the Pencil chain through the local
  pen.dev host and the open `.pen` document.
- The role body states that the adapter grants no remote or filesystem privilege and that the full
  Design artifact does not depend on a tool.
- The new role patterns use whole-string, case-sensitive matches with escaped metacharacters and
  keep the matched substrings of the unchanged assertions.
- The composition sets only the internal UX Design signal and writes no MCP setting.
- The composition evaluation passes.
