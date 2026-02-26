#!/usr/bin/env bash
set -euo pipefail

julia -e 'using Pkg; Pkg.add("OrdinalGWAS"); Pkg.precompile();'
