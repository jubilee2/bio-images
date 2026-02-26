FROM julia:1.12

ENV JULIA_DEPOT_PATH="/usr/local/share/julia"

WORKDIR /app

ENV JULIA_PROJECT="@."
COPY install.sh /tmp/install.sh
RUN bash /tmp/install.sh && rm /tmp/install.sh
