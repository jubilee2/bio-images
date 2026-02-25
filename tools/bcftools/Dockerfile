FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    bcftools ca-certificates \
  && mkdir -p /usr/local/share/bcftools \
  && bcftools --version | head -n1 > /usr/local/share/bcftools/version.txt \
  && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/jubilee2/dna-dockerfiles"
LABEL org.opencontainers.image.title="bcftools"

CMD ["bcftools"]
