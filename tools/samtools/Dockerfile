FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    samtools ca-certificates \
  && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/jubilee2/dna-dockerfiles"
LABEL org.opencontainers.image.title="samtools"

CMD ["samtools"]
