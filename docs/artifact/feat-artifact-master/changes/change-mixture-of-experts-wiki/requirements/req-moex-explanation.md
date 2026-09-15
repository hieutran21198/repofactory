# req-moex-explanation: Explain the mixture-of-experts roles and routing

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The wiki must explain the mixture-of-experts idea that artifact-driven uses. It must explain
the artifact master as coordination only and the requirement expert, the solution expert, and
the implementation experts as the owners of phase content. It must explain Plan-Pn then
Build-Pn routing, coordinate-plan versus execution-plan, harness rendering from one canonical
source to each harness in use, and skill load.

## Acceptance criteria

- Given a reader who does not know the harness roles, when the reader reads the wiki page,
  then the reader can name the owner of the content of each phase.
- Given the wiki page, when the reader checks the coordination boundary, then the page states
  that the artifact master owns coordination only and never owns phase content.
- Given the wiki page, when the reader checks the routing, then the page explains Plan-Pn
  then Build-Pn, coordinate-plan versus execution-plan, harness rendering, and skill load.
- Given the wiki page, when the reader reads it in English, then the page needs no other
  document to explain the roles and their routing.

## Notes

- Canonical source: `docs/wiki/documentation/mixture-of-experts/README.md`.
- Language: English. The page must stay self-contained so the end-user can copy it.
- Terms follow the glossary of context-factory: artifact master, harness, role, skill,
  mixture of experts.
