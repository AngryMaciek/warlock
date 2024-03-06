###############################################################################
#
#   Create internal conda envs with all dependencies
#
#   AUTHOR: Maciej_Bak
#   CONTACT: wsciekly.maciek@gmail.com
#
###############################################################################

# exit at a first command that exits with a !=0 status
set -eo pipefail

snakemake \
    --snakefile="workflow/Snakefile" \
    --configfile="tests/localtest/config-template.yml" \
    --config workflow_repo_path="$PWD" workflow_analysis_outdir="$PWD/tests/localtest/output" \
    --use-conda \
    --conda-create-envs-only \
    --cores 1 \
    --nolock \
    all

for file in .snakemake/conda/*.yaml; do
    if [ -f "$file" ]; then
        if grep -q "name: warlock-r" "$file"; then
            ENVPATH="${file%.yaml}"
            break
        fi
    fi
done

eval "$(conda shell.bash hook)"
conda deactivate
conda activate $ENVPATH

# strange error often appears, installation needs to be called twice
Rscript -e "devtools::install('resources/demonanalysis', upgrade=TRUE)" || true
Rscript -e "devtools::install('resources/demonanalysis', upgrade=TRUE)" || true
