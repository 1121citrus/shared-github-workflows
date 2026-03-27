# shared-github-workflows

Reusable GitHub Actions workflows for [1121citrus](https://github.com/1121citrus) Docker image repos.

## Workflows

| Workflow | Purpose | Key inputs |
| -------- | ------- | ---------- |
| `lint.yml` | Hadolint, ShellCheck, markdownlint-cli | `node-syntax-check-file` (optional) |
| `build.yml` | Build image, upload `docker-image` artifact | `image` (required), `inject-metadata` |
| `scan.yml` | Trivy CRITICAL/HIGH scan of `:latest` artifact | `image` (required), `trivyignore` |
| `push.yml` | Multi-platform push to Docker Hub | `image` (required), `staging-use-timestamp` |
| `release-please.yml` | Automated release PR + semver tag | — |

## Usage

Calling workflows reference workflows at `@main`:

```yaml
jobs:
  lint:
    uses: 1121citrus/shared-github-workflows/.github/workflows/lint.yml@main

  build:
    needs: lint
    uses: 1121citrus/shared-github-workflows/.github/workflows/build.yml@main
    with:
      image: 1121citrus/myapp

  scan:
    needs: build
    uses: 1121citrus/shared-github-workflows/.github/workflows/scan.yml@main
    with:
      image: 1121citrus/myapp

  push:
    needs: [test, scan]
    if: >
      github.event_name == 'push' && (
        startsWith(github.ref, 'refs/tags/v') ||
        github.ref == 'refs/heads/staging'
      )
    uses: 1121citrus/shared-github-workflows/.github/workflows/push.yml@main
    with:
      image: 1121citrus/myapp
    secrets: inherit
```

The `test` job (and optional `smoke` job) remain in each repo's `ci.yml` since they are custom per project.

## Inputs reference

### `lint.yml`

| Input | Type | Default | Description |
| ----- | ---- | ------- | ----------- |
| `node-syntax-check-file` | string | `''` | Path passed to `node --check`; skipped when empty |

### `build.yml`

| Input | Type | Default | Description |
| ----- | ---- | ------- | ----------- |
| `image` | string | required | Docker Hub image name |
| `inject-metadata` | boolean | `false` | Inject `VERSION`, `GIT_COMMIT`, `BUILD_DATE` build-args at build time |

### `scan.yml`

| Input | Type | Default | Description |
| ----- | ---- | ------- | ----------- |
| `image` | string | required | Docker Hub image name (scans `:latest` tag) |
| `trivyignore` | string | `''` | Path to `.trivyignore.yaml`; skipped when empty |

### `push.yml`

| Input | Type | Default | Description |
| ----- | ---- | ------- | ----------- |
| `image` | string | required | Docker Hub image name |
| `staging-use-timestamp` | boolean | `false` | Use `YYYY.MM.DD.HHmmSS` in staging tag instead of short SHA |
| `platforms` | string | `linux/amd64,linux/arm64` | Docker build platforms |

Secrets `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` are consumed via `secrets: inherit`.

## Action version policy

All actions are pinned to full commit SHAs with a version comment, e.g.:

```yaml
uses: actions/checkout@34e114876b0b11c390a56381ad16ebd13914f8d5 # v4
```

Update pins here to update every consuming repo in one PR.
