FROM julia:1.12

RUN julia -e 'using Pkg; Pkg.add("OrdinalGWAS")'

COPY gwas_cli.jl /usr/local/bin/gwas_cli.jl
COPY gwas /usr/local/bin/gwas

RUN chmod +x /usr/local/bin/gwas /usr/local/bin/gwas_cli.jl

CMD ["julia"]
