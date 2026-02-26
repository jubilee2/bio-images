FROM julia:1.12

ARG TARGETARCH

ENV JULIA_DEPOT_PATH="/usr/local/share/julia"

WORKDIR /app

ENV JULIA_PROJECT="@."
COPY install.sh /tmp/install.sh
RUN TARGETARCH="$TARGETARCH" bash /tmp/install.sh && rm /tmp/install.sh
