# AGENTS.md

## DNA Tool Docker Images

**Owner:** `jubilee2`  
**Registry:** Docker Hub  
**Architecture:** one Docker Hub repository per tool  
**Base install method:** `apt` on Ubuntu 22.04  
**CI/CD:** GitHub Actions

---

## 1) Purpose

This repository manages Docker images for DNA tools using a **spec-driven workflow**.

Each tool:
- lives in its own folder
- defines its contract in `spec.yml`
- maps to its own image repository (`jubilee2/<tool>`)
- is automatically built and tested in CI
- is pushed only from `main`

---

## 2) Repository Layout

```text
dna-dockerfiles/
├── tools/
│   └── <tool>/
│       ├── Dockerfile
│       └── spec.yml
├── scripts/
│   └── list_tools.sh
├── .github/workflows/
│   └── build-and-push.yml
└── AGENTS.md
```

---

## 3) Tool Contract (Spec-Driven)

Every tool **must** include `spec.yml`.

Example:

```yaml
tool: bcftools
image: jubilee2/bcftools
tags:
  - "latest"
  - "1.20"
test:
  - "bcftools --version"
```

### Required fields

| Field   | Description |
|---|---|
| `tool`  | Tool name (matches folder name) |
| `image` | Docker Hub repository |
| `tags`  | Tags to publish from `main` |
| `test`  | Commands CI runs after build |

`spec.yml` is the single source of truth for:
- image naming
- tagging
- CI test validation

---

## 4) Dockerfile Standards

All tool Dockerfiles must:
- use `ubuntu:22.04`
- install packages with `apt`
- remove apt cache (`/var/lib/apt/lists/*`)
- include OCI labels
- avoid unnecessary packages

Template:

```dockerfile
FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    <package-name> \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/jubilee2/dna-dockerfiles"
LABEL org.opencontainers.image.title="<tool>"

CMD ["<tool>"]
```

---

## 5) CI/CD Behavior

Workflow: `.github/workflows/build-and-push.yml`

### Trigger behavior

| Event | Behavior |
|---|---|
| Pull request | Build + test |
| Push to `main` | Build + test + push |
| `workflow_dispatch` | Manual run |

### Per-tool CI steps

1. Build Docker image
2. Run all commands from `spec.yml:test`
3. On `main`, push:
   - `sha-<short_sha>`
   - all tags from `spec.yml`

### Tagging policy (`main`)

- `jubilee2/<tool>:sha-<commit>`
- `jubilee2/<tool>:latest`
- any additional tags listed in `spec.yml`

---

## 6) Adding a New Tool

1. Create `tools/<tool>/`
2. Add `Dockerfile`
3. Add `spec.yml`
4. Commit and push

CI auto-detects the tool and then builds, tests, and pushes (on `main`) without workflow edits.

---

## 7) Local Validation Standard

Before pushing:

```bash
docker build -t test-image tools/<tool>
docker run --rm test-image <tool> --version
```

All commands in `spec.yml:test` should pass locally.

---

## 8) Definition of Done

A tool is production-ready when:
- Dockerfile builds cleanly
- all spec tests pass in CI
- image pushes successfully
- OCI labels are present
- apt cache is removed
- no unnecessary packages are installed

---

## 9) Scaling Guidelines

When adding many tools:
- keep one tool per folder
- do not combine tools into one image
- keep installs minimal
- prefer official Ubuntu apt packages
- if apt lacks a required version, document the limitation in `README`

---

## 10) Optional Future Enhancements

- auto-detect installed version for tagging
- security scanning (Trivy)
- multi-arch builds (`amd64`, `arm64`)
- non-root user enforcement
- scheduled rebuilds for base image updates
- Dockerfile generation from spec

---

## 11) Design Principles

- spec-driven development
- CI-enforced contracts
- one image per tool
- deterministic builds
- minimal image footprint
- automated tagging
- no manual Docker Hub pushes

---

## 12) Governance

**Owner:** `jubilee2`

Change requirements:
- PR review (if/when collaboration is enabled)
- passing CI before merge
- no direct Docker Hub edits outside CI

---

## Summary

This repo provides:
- reproducible DNA tool images
- automated GitHub Actions builds
- one Docker Hub repository per tool
- spec-driven CI enforcement
- scalable, clean image architecture
