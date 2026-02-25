FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG GITHUB_SHA=unknown
ARG BUILD_DATE=unknown
ARG SOURCE_URL="https://github.com/jubilee2/dna-dockerfiles"
RUN apt-get update && apt-get install -y --no-install-recommends \
    samtools ca-certificates \
  && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="$SOURCE_URL"
LABEL org.opencontainers.image.title="samtools"
LABEL org.opencontainers.image.revision="$GITHUB_SHA"
LABEL org.opencontainers.image.created="$BUILD_DATE"

CMD ["samtools"]
