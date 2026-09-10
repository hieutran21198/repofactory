# req-role-declaration-reference: Give a reference of the role declaration

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The expert role skill must give a reference of the role declaration. The reference must:

1. List each field that a project can set when it declares a role. The fields are enable, name,
   description, instruction, and the extra fields of each harness (claude, codex, opencode).
   Give the meaning of each field.
2. Say where each harness renders the role file.
3. Give one complete example of a role declaration in the local configuration file of the
   project.

The reference must follow the convention of the project: the body of a role is in
`utils/agent/role/<name>/ROLE.md`, and the declaration reads that file.

## Acceptance criteria

- Given the expert role skill, when an agent reads the reference, then the reference lists the fields enable, name, description, and instruction with the meaning of each field.
- Given the expert role skill, when an agent reads the reference, then the reference lists the extra fields of each of the harnesses claude, codex, and opencode.
- Given the expert role skill, when an agent reads the reference, then the reference says where each of the three harnesses renders the role file.
- Given the expert role skill, when an agent reads the reference, then the reference has one complete example of a role declaration in the local configuration file of the project.
- Given the example declaration, when an agent reads it, then the example reads the body from `utils/agent/role/<name>/ROLE.md`.
- Given an agent that copies the example and changes only the name and the body, when the project enters its shell, then each harness in use renders the role file.

## Notes

The user agreed the convention `utils/agent/role/<name>/ROLE.md`. The fields in this requirement
are the fields that a project can set today. The solution expert decides how the skill stays
correct when the fields change.
