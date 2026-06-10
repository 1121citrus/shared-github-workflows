# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-06-10

### Changed

- `push.yml`: upgrade `docker/build-push-action` from v6.19.2 to v7.2.0;
  v7 runs on Node 24 natively
- `build.yml`: same `build-push-action` upgrade
- `push.yml`, `build.yml`: remove `FORCE_JAVASCRIPT_ACTIONS_TO_NODE24=true`
  env; redundant with v7

### Removed

- `push.yml`: `staging-use-timestamp` input and all staging-branch tag
  entries (`:staging`, `:staging-<sha>`, `:staging-<ts>`); staging images
  served no external purpose and polluted the DockerHub tag namespace

## [1.0.2] - 2026-04-25

### Removed

- `release-please.yml`: reusable release-please workflow removed; consumers
  version by hand using `version.txt` and `CHANGELOG.md`

## [1.0.1] - 2026-04-25

### Fixed

- `lint.yml`: pin shellcheck to `v0.11.0` to prevent transient download
  failures caused by the `stable` release alias resolving at runtime

### Added

- `version.txt`, `CHANGELOG.md`: manual versioning infrastructure
- `.github/workflows/tag-floating.yml`: CI workflow that force-updates the
  floating `vN` tag on every push to `main`
- `dev/git-hooks/pre-commit`: warns when a workflow file is staged without
  a corresponding `version.txt` bump
- `dev/git-hooks/install`: installs the pre-commit hook via symlink

## [1.0.0] - 2026-03-26

### Added

- `lint.yml`: Hadolint, ShellCheck (`stable`), markdownlint-cli; optional
  Node.js syntax check
- `build.yml`: linux/amd64 image build with GHA cache; uploads
  `docker-image` artifact; optional `VERSION`/`GIT_COMMIT`/`BUILD_DATE`
  build-arg injection
- `scan.yml`: Trivy CRITICAL/HIGH scan of `:latest` artifact; optional
  `.trivyignore` support
- `push.yml`: multi-platform push (amd64 + arm64) with SBOM and provenance;
  semver sub-tags; staging SHA/timestamp tag modes
- `release-please.yml`: reusable release-please automation

[Unreleased]: https://github.com/1121citrus/shared-github-workflows/compare/v1.0.2...HEAD
[1.0.2]: https://github.com/1121citrus/shared-github-workflows/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/1121citrus/shared-github-workflows/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/1121citrus/shared-github-workflows/releases/tag/v1.0.0
