# spec-design-option: Define the design option

**Master:** [Specifications](README.md)
**Covers:** req-design-option

## Description

A new factory domain `design` gives one option that selects the design method. The option has
the same shape as `documentation.use` and `repo-arch.use`.

## Contract

The module `services/factory/domain/design/default.nix` declares this option:

```nix
options.factory.domain.design.use = _utils.mkEnumOpt {
  values = [ "unset" "ddd" ];
  default = "unset";
  description = "Design method to use";
};
```

The module importer finds the new module and its submodules without a change to an index file.

## Errors

Nix evaluation fails if `design.use` has a value that is not in the list.
