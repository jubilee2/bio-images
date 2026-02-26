FROM julia:1.12

ENV JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,zarch;skylake-avx512,clone_all"
ENV JULIA_DEPOT_PATH="/usr/local/share/julia"

WORKDIR /app

ENV JULIA_PROJECT="@."
RUN julia -e 'using Pkg; Pkg.add("OrdinalGWAS"); Pkg.precompile();'
