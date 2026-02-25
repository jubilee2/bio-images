#!/usr/bin/env julia

using OrdinalGWAS
using StatsModels

function usage()
    println("""
Usage:
  gwas "<trait ~ covariates>" <covariate_csv> <genetic_prefix_or_none>

Options:
  -h, --help       Show this help message
  -v, --version    Print CLI and package version information

Examples:
  gwas "trait ~ sex + age" covariates.csv plink_prefix
  gwas "trait ~ sex" covariates.csv none

Notes:
  - This is a lightweight wrapper over OrdinalGWAS.ordinalgwas.
  - The formula should be provided without @formula, e.g. \"trait ~ sex\".
  - Use the literal value 'none' to fit only the null model.
""")
end

function print_version()
    pkgid = Base.PkgId(OrdinalGWAS)
    ordinalgwas_version = isnothing(pkgid.version) ? "unknown" : string(pkgid.version)
    println("gwas CLI")
    println("OrdinalGWAS version: " * ordinalgwas_version)
    println("Julia version: " * string(VERSION))
end

function parse_formula(formula_str::String)
    return eval(Meta.parse("@formula($(formula_str))"))
end

function main(args::Vector{String})
    if any(arg -> arg in ("-h", "--help"), args)
        usage()
        return 0
    end

    if any(arg -> arg in ("-v", "--version"), args)
        print_version()
        return 0
    end

    if length(args) < 3
        usage()
        return 1
    end

    formula = parse_formula(args[1])
    covfile = args[2]
    genetic = lowercase(args[3]) == "none" ? nothing : args[3]

    OrdinalGWAS.ordinalgwas(formula, covfile, genetic)
    return 0
end

exit(main(ARGS))
