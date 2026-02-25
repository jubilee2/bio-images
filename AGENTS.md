# AGENTS.md

## Project: DNA Tool Docker Images

Owner: `jubilee2`
Registry: Docker Hub
Pattern: **One Docker Hub repository per tool**
Install method: **apt (Ubuntu 22.04)**
CI: GitHub Actions

---

# 1. Purpose

This repository manages multiple Docker images for DNA tools using a **spec-driven development model**.

Each tool:

* Has its own folder
* Has its own `spec.yml`
* Builds to its own Docker Hub repository (`jubilee2/<tool>`)
* Is built/tested automatically by GitHub Actions
* Pushes images only on `main`

---

# 2. Repository Structure

```
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

# 3. Tool Contract (Spec-Driven Model)

Each tool MUST contain a `spec.yml`.

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

| Field   | Purpose                        |
| ------- | ------------------------------ |
| `tool`  | Folder name                    |
| `image` | Docker Hub repo                |
| `tags`  | Tags to push on main           |
| `test`  | Commands run in CI after build |

The `spec.yml` is the source of truth for:

* image naming
* tagging
* CI test validation

---

# 4. Dockerfile Rules

All tools must:

* Use `ubuntu:22.04`
* Install via `apt`
* Remove apt cache
* Include OCI labels
* Avoid unnecessary packages

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

# 5. CI Behavior (GitHub Actions)

Workflow: `.github/workflows/build-and-push.yml`

## Trigger Matrix

| Event             | Behavior            |
| ----------------- | ------------------- |
| Pull Request      | Build + Test only   |
| Push to main      | Build + Test + Push |
| workflow_dispatch | Manual run          |

---

## Build Process

For each tool:

1. Build Docker image
2. Run all `spec.yml` test commands
3. On main:

   * Push `sha-<short_sha>`
   * Push all tags from spec

---

## Tagging Policy

On push to main:

* `jubilee2/<tool>:sha-<commit>`
* `jubilee2/<tool>:latest`
* any additional tags from spec

---

# 6. Adding a New Tool

Steps:

1. Create folder:

   ```
   tools/<tool>/
   ```

2. Add `Dockerfile`

3. Add `spec.yml`

4. Commit + push

CI automatically:

* detects tool
* builds
* tests
* pushes image

No workflow modification required.

---

# 7. Local Testing Standard

Before pushing:

```bash
docker build -t test-image tools/<tool>
docker run --rm test-image <tool> --version
```

All `spec.yml` test commands must pass locally.

---

# 8. Definition of Done (DoD)

A tool is considered production-ready when:

* Dockerfile builds cleanly
* All spec tests pass in CI
* Image pushes successfully
* OCI labels are present
* apt cache removed
* No unnecessary packages installed

---

# 9. Scaling Guidelines

When adding many tools:

* Keep one tool per folder
* Do not combine tools into one image
* Keep install minimal
* Prefer official Ubuntu apt packages
* If apt lacks correct version, document limitation in README

---

# 10. Future Enhancements (Optional)

Possible next iterations:

* Auto-detect installed version and tag dynamically
* Security scan step (Trivy)
* Multi-arch build (amd64 + arm64)
* Non-root user enforcement
* Auto rebuild on base image updates (scheduled job)
* Generate Dockerfiles from spec

---

# 11. Design Principles

This repo follows:

* Spec-driven development
* CI-enforced contracts
* One image per tool
* Deterministic builds
* Minimal images
* Automated tagging
* No manual Docker Hub pushes

---

# 12. Governance

Owner: `jubilee2`
Changes require:

* PR review (if collaboration begins)
* CI must pass before merge
* No direct Docker Hub edits outside CI

---

# Summary

This repository provides:

* Reproducible Docker images for DNA tools
* Automated GitHub Actions builds
* One Docker Hub repo per tool
* Spec-driven CI enforcement
* Scalable, clean architecture
