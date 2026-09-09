# adr-pinned-dependencies: Ship the lockfile in copy mode

**Relates to:** spec-docs-site-files, spec-docs-site-workflow
**Context:** context-factory

## Context

The requirement `req-factory-owned-site` says that the factory pins the dependency versions of
the site tooling, that two projects with the same factory version use the same versions, and
that a factory update brings new versions without a change to the project. The workflow runs
`npm ci`, which needs a `package-lock.json` that agrees with `package.json`. The action
`actions/setup-node@v4` caches the npm store with a lockfile as the cache key. The versions in
`package.json` alone do not fix the transitive dependency tree.

## Options

1. Ship `package.json` and `package-lock.json` as assets in copy mode. The factory maintainer
   makes the lockfile one time with
   `nix shell nixpkgs#nodejs_22 -c npm install --package-lock-only --ignore-scripts` in the
   asset folder, and again after each change to `package.json`. Pro: `npm ci` gets a lockfile
   that agrees with `package.json` in each generated repository. Pro: two projects with the
   same factory version get the same tree. Pro: a factory update overwrites both files, so the
   project gets the new tree without a change. Con: the lockfile is a large generated file in
   the factory repository. Con: the maintainer must run the lockfile command after each change
   to `package.json`.
2. Ship `package.json` in copy mode and `package-lock.json` in seed mode. Pro: a project can
   change its lockfile. Con: after a factory update of `package.json`, the seeded lockfile no
   longer agrees with it, and `npm ci` fails until the project runs `npm install`. This breaks
   the acceptance criterion that a factory update needs no project change.
3. Ship `package.json` only, with no lockfile, and run `npm install` in the workflow. Pro: no
   generated file in the factory. Con: `npm install` resolves the transitive tree at each run,
   so two projects can get two trees and a build can break without a change. Con:
   `actions/setup-node@v4` with `cache: npm` needs a lockfile.

## Decision

Option 1. Only a lockfile in copy mode gives the same tree to each project and keeps `npm ci`
valid after a factory update.

## Consequences

The workflow uses `npm ci` and the cache of `actions/setup-node@v4` with
`cache-dependency-path: apps/documentation/package-lock.json`. The factory maintainer runs the
lockfile command after each change to `package.json`; the check `lockfileParses` in
`tests/eval.nix` confirms that the lockfile is JSON with `lockfileVersion >= 2`, but it does not
confirm that the lockfile agrees with `package.json`. The task `task-verify-generation` runs
`npm ci` to confirm that. A project cannot add a dependency to the site, because the next shell
entry overwrites `package.json`. This follows the requirement: a project configures only a
title, a site URL, and a base URL.
