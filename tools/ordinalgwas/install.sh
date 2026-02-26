#!/usr/bin/env bash
set -euo pipefail

case "${TARGETARCH:-}" in
  amd64)
    export JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt;skylake-avx512,clone_all"
    ;;
  arm64)
    # Include Apple silicon tiers while keeping a generic baseline.
    export JULIA_CPU_TARGET="generic;apple-m1,clone_all;apple-m2,base(1);apple-m3,base(1)"
    ;;
  *)
    export JULIA_CPU_TARGET="generic"
    ;;
esac

echo "JULIA_CPU_TARGET=${JULIA_CPU_TARGET}"

julia -e 'using Pkg; Pkg.add("OrdinalGWAS"); Pkg.precompile();'
