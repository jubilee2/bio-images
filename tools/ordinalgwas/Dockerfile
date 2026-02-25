FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    julia \
    ca-certificates \
  && julia -e 'using Pkg; pkg"add OrdinalGWAS"' \
  && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.source="https://github.com/jubilee2/dna-dockerfiles"
LABEL org.opencontainers.image.title="ordinalgwas"

CMD ["julia"]
