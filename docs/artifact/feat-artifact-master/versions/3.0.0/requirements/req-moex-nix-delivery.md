# req-moex-nix-delivery: Deliver the wiki page through the Nix wiki assets copy

**Master:** [Requirements](README.md)
**Priority:** Must
**Context:** context-factory

## Statement

The factory must deliver the mixture-of-experts wiki page to a generated repository through
the Nix wiki assets copy. The canonical source must live in `docs/wiki/`, with mirrors under
`services/factory/composition/artifact-driven/_assets/{single,multiple}[/ddd]/docs/wiki/...`,
file entries with `copyMode="copy"` in
`services/factory/composition/artifact-driven/default.nix` for the single and multiple layouts
(and the ddd variant if needed), and a link in the `docs/wiki/README.md` index. The generated
repository must receive a self-contained copy of the page.

## Acceptance criteria

- Given the documentation model use, when the factory composes a single-layout repository,
  then the generated repository holds a copy of the wiki page.
- Given the documentation model use, when the factory composes a multiple-layout repository,
  then the generated repository holds a copy of the wiki page.
- Given the generated repository, when the maintainer reads `docs/wiki/README.md`, then the
  index links the mixture-of-experts page.
- Given the delivered page in the generated repository, when the maintainer reads it, then
  the page is self-contained and the maintainer can copy it without another source file.

## Notes

- The delivery must follow the same pattern as the existing wiki docs delivered with
  `copyMode="copy"`.
- The ddd variant mirror applies only if the page needs a DDD-specific version.
