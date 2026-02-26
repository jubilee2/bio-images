#!/usr/bin/env bash
set -euo pipefail

export JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,zarch;skylake-avx512,clone_all"

julia -e 'using Pkg; Pkg.add("OrdinalGWAS"); Pkg.precompile();'
