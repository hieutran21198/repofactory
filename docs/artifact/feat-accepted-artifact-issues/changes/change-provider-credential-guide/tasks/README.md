# Implementation plan: Provider credential guide

## Order of work

| Step | Task | Depends on |
| --- | --- | --- |
| 1 | [Add the generated credential guide](task-add-provider-credential-guide.md) | - |
| 2 | [Check conditional generation](task-check-provider-credential-guide.md) | 1 |

## Definition of done

- The project-issues composition generates the credential guide when enabled.
- The existing project-issues page links to the credential guide.
- The guide covers GitHub Projects and Trello credentials.
- The guide uses silent prompts and standard input for secret values.
- Evaluation checks confirm that disabled compositions omit the guide.
- Repository checks pass.
