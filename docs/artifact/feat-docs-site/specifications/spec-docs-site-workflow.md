# spec-docs-site-workflow: Publish the site with a GitHub Actions workflow

**Master:** [Specifications](README.md)
**Covers:** req-github-pages-publishing
**Context:** context-factory

## Description

The authored file `.github/workflows/docs-site.yml` builds the website and publishes it to
GitHub Pages. It runs on a push that touches the docs, the site project, or the workflow itself.
A build job runs on the default branch only. A deploy job publishes the build output. The
repository owner sets the Pages source to "GitHub Actions" one time.

## Contract

### File

| Generated path | copyMode | Source |
| --- | --- | --- |
| `.github/workflows/docs-site.yml` | `copy` | `./_assets/.github/workflows/docs-site.yml` |

The file has no Nix interpolation. The module renders it with `source`.

### Workflow

```yaml
name: Documentation site

on:
  push:
    paths:
      - docs/**
      - apps/documentation/**
      - .github/workflows/docs-site.yml
  workflow_dispatch:

permissions:
  contents: read

concurrency:
  group: docs-site
  cancel-in-progress: false

jobs:
  build:
    if: github.ref_name == github.event.repository.default_branch
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: apps/documentation
    steps:
      - name: Check out the repository
        uses: actions/checkout@v4
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: apps/documentation/package-lock.json
      - name: Install the dependencies
        run: npm ci
      - name: Build the website
        run: npm run build
      - name: Upload the website
        uses: actions/upload-pages-artifact@v3
        with:
          path: apps/documentation/build

  deploy:
    needs: build
    runs-on: ubuntu-latest
    permissions:
      pages: write
      id-token: write
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### Trigger

| Event | Rule |
| --- | --- |
| `push` | Runs when a push changes a file under `docs/`, a file under `apps/documentation/`, or the workflow file. |
| `workflow_dispatch` | Runs when a person starts it from the Actions tab. |

### Top level

| Key | Value |
| --- | --- |
| `permissions` | `contents: read` |
| `concurrency.group` | `docs-site` |
| `concurrency.cancel-in-progress` | `false` |

One run at a time. A second run waits for the first run.

### Build job

| Key | Value |
| --- | --- |
| `if` | `github.ref_name == github.event.repository.default_branch` |
| `runs-on` | `ubuntu-latest` |
| `defaults.run.working-directory` | `apps/documentation` |

The steps, in this order:

| Step | Action or command | Inputs |
| --- | --- | --- |
| Check out | `actions/checkout@v4` | None |
| Set up Node.js | `actions/setup-node@v4` | `node-version: 22`, `cache: npm`, `cache-dependency-path: apps/documentation/package-lock.json` |
| Install | `npm ci` | Runs in `apps/documentation` |
| Build | `npm run build` | Runs in `apps/documentation` |
| Upload | `actions/upload-pages-artifact@v3` | `path: apps/documentation/build` |

`npm ci` installs the exact versions of `package-lock.json`. The `path` input is relative to the
repository root, not to the working directory.

### Deploy job

| Key | Value |
| --- | --- |
| `needs` | `build` |
| `runs-on` | `ubuntu-latest` |
| `permissions` | `pages: write`, `id-token: write` |
| `environment.name` | `github-pages` |
| `environment.url` | `${{ steps.deployment.outputs.page_url }}` |

One step: `actions/deploy-pages@v4` with `id: deployment`.

### Manual step

The repository owner opens the repository settings, Pages, and sets the source to
"GitHub Actions". This step runs one time. The wiki page of `spec-docs-site-files` documents it.

## Errors

The build job fails when `npm ci` or `npm run build` exits with a non-zero code. The deploy job
does not run, because `needs: build` requires a successful build. GitHub Pages keeps the last
published website. The Actions tab shows the failed run.
On a push to a branch that is not the default branch, the `if` condition is false. GitHub skips
the build job. GitHub skips the deploy job, because its `needs` job did not run. GitHub Pages
keeps the website of the default branch.
The deploy job fails when the Pages source is not "GitHub Actions". The error message names the
Pages settings.
The check `workflowMatches` in `tests/eval.nix` fails if the file text does not match one of the
six patterns of `spec-eval-checks`.
