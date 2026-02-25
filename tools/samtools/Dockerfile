FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    samtools ca-certificates \
  && mkdir -p /usr/local/share/samtools \
  && samtools --version | head -n1 > /usr/local/share/samtools/version.txt \
  && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/jubilee2/dna-dockerfiles"
LABEL org.opencontainers.image.title="samtools"

CMD ["samtools"]
