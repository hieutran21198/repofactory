# spec-solution-expert-link: Point the solution expert to the skill

**Master:** [Specifications](README.md)
**Covers:** req-solution-expert-hand-off
**Context:** context-factory

## Description

The shipped solution expert names the `expert-role` skill in its `## Mixture of experts`
section. When no expert covers a domain, the solution expert offers to set up the
implementation expert with the skill before it writes the part itself. Only the base body of
the solution expert changes. The requirement expert does not change.

## Contract

The file is
`services/factory/composition/artifact-driven/_assets/agent/role/solution-expert/ROLE.md`.

The last bullet of `## Mixture of experts` reads today:

```markdown
- If no expert covers a domain, write the part yourself. Say so in your report.
```

It changes to:

```markdown
- When no expert covers a domain, tell the user that the `expert-role` skill can set up an
  implementation expert for it. Offer to set up the expert. If the user declines, write the
  part yourself. Say so in your report.
```

The heading `## Mixture of experts` stays. The other bullets of the section stay. The rest of
the file does not change.

These files do not change:

- `services/factory/composition/artifact-driven/_assets/agent/role/requirement-expert/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/multiple/ddd/agent/role/solution-expert/ROLE.md`
- `services/factory/composition/artifact-driven/_assets/single/ddd/agent/role/solution-expert/ROLE.md`

The composition reads the base body at evaluation time. The existing checks `chapterAppended`
and `chapterOmitted` in `tests/eval.nix` compare the rendered instruction with the file
content, so they stay valid without a change.

The solution expert role and the skill are both inside the `lib.mkIf (documentation.use ==
model)` block of the composition. A project that does not select the model has no solution
expert role and no `expert-role` skill.

## Errors

The check `solutionExpertNamesSkill` in `tests/eval.nix` fails if the base body of
`solution-expert` does not contain `expert-role`.
The check `solutionExpertNamesSkill` fails if the base body of `requirement-expert` contains
`expert-role`.
The check `chapterAppended` or `chapterOmitted` fails if the DDD chapter of the solution expert
changes.
