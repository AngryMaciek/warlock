[![ci](https://github.com/AngryMaciek/demon-runner/workflows/ci/badge.svg)](https://github.com/AngryMaciek/demon-runner/actions?query=workflow%3Aci)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/AngryMaciek/demon-runner/master?labpath=notebook.ipynb)
[![GitHub issues](https://img.shields.io/github/issues/AngryMaciek/demon-runner)](https://github.com/AngryMaciek/demon-runner/issues)
[![GitHub license](https://img.shields.io/github/license/AngryMaciek/demon-runner)](https://github.com/AngryMaciek/demon-runner/blob/master/LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7143400.svg)](https://doi.org/10.5281/zenodo.7143400)

# _demon-runner_

[_demon_](https://github.com/robjohnnoble/demon_model) (deme-based oncology model) is a flexible framework for modelling intra-tumour population genetics with varied spatial structures and modes of cell dispersal. It is primarly designed for computational biologists and mathematicians who work in the field of ecology on a cellular level; investiaging mechanisms behind tumour evolution. The following repository encapsulates _demon_ into an automated and reproducible [Snakemake](https://snakemake.readthedocs.io/en/stable/) workflow in order to simplify parallel simulations to all users.

## Installation

**The workflow is designed to run on Linux and macOS systems.**  
We have prepared a dedicated [conda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/environments.html) recipe which will contain all prerequisites required to execute the workflow. Thus Anaconda/Miniconda package manager is a natural dependency (see [Appendix A](#appendix-a-miniconda-installation) for installation instructions.)

1. Clone the repository and navigate inside that directory
   ```bash
   git clone https://github.com/AngryMaciek/demon-runner.git --recursive
   cd demon-runner
   ```
2. Create and activate conda environment
   ```bash
   conda env create
   conda activate demon-runner
   ```
3. Compile _demon_
   * Linux:
     ```bash
     g++ resources/demon_model/src/demon.cpp -o resources/demon_model/bin/demon -I$HOME/miniconda3/envs/demon-runner/include -lm
     ```
   * macOS:
     ```bash
     clang++ resources/demon_model/src/demon.cpp -o resources/demon_model/bin/demon -I$HOME/miniconda3/envs/demon-runner/include -lm
     ```

    > Note: remember to adjust `miniconda3` (and its path) in the command above, in case you have a different manager installed on your system. All in all, the point is to provide the _include_ directory of your `demon-runner` environment to the compiler.

## Configuration

For a detailed description of all available simulation parameters please inspect [GitHub repository](https://github.com/robjohnnoble/demon_model) of the core _demon_ model.

These parameters are now required to be set inside a YAML-formatted pipeline configuration file. A template for this file is available [here](/workflow/config/config.yml). Please see an example configuration file designed for the CI tests [here](/tests/test2/config.yml). Note that multiple values for distinct parameters might be provided in lists. Current implementation of the workflow prepares a Cartesian product of all parameter's values and runs _demon_ with each of them in parallel.

Additionally, please notice that two absolute paths are required to be set in the same configuration file: path to this cloned repository as well as path for the analyses output directory.

## Execution

This workflow should be executed via a top-level bash script: `demon-runner.sh` which has the following description:
```
This is the main script to call the demon-runner workflow.
Available options:

  -c/--configfile {XXX} (REQUIRED)
  Path to the snakemake config file.

  -e/--environment {local/slurm} (REQUIRED)
  Environment to execute the workflow in:
  * local = execution on the local machine.
  * slurm = slurm cluster support.

  -n/--cores {XXX} (OPTIONAL)
  Number of cores available for the workflow.
  (Default = 1)
```

### Local

Example command for a local workflow execution:
```
bash demon-runner.sh --configfile {PATH} --environment local
```

### SLURM cluster

Example command for a cluster-supported workflow execution:
```
bash demon-runner.sh --configfile {PATH} --environment slurm
```

Please note that, depending on the complexity of the simulations, it might be required to adjust parameters for cluster jobs. If the expected required resources (memory or computation time) are high please adjust `time` and `mem` fields in the cluster submission configuration file, located at: [`/workflow/profiles/slurm/slurm-config.json`](/workflow/profiles/slurm/slurm-config.json).

## Output

After each pipeline run the main output directory will contain three subdirectories: `configfiles`, `simulations` and `logs`. Each simulation run with a specific set of parameters is encoded by a 4-letter code. The first directory contains configuration files for each of the simulation runs; `simulations` contain all _demon_ output files; `logs` keep captured standard output and error streams for the commands.

## Example

Feel free to run the pipeline and inspect the results yourself in an [interactive jupyter notebook](https://mybinder.org/v2/gh/AngryMaciek/demon-runner/master?labpath=notebook.ipynb) we prepared.

## Community guidelines
For guidelines on how to contribute to the project or report issues, please see [contributing instructions](/CONTRIBUTING.md).  
For other inquires feel free to contact the developers at _wsciekly.maciek@gmail.com_

## Citation

Results obtained with _demon_ have already been published in:
> Noble R, Burri D, Le Sueur C, Lemant J, Viossat Y, Kather JN, Beerenwinkel N. Spatial structure governs the mode of tumour evolution. Nat Ecol Evol. 2022 Feb;6(2):207-217. doi: https://doi.org/10.1038/s41559-021-01615-9

> Noble R, Burley JT, Le Sueur C, Hochberg ME. When, why and how tumour clonal diversity predicts survival. Evol Appl. 2020 Jul 18;13(7):1558-1568. doi: https://doi.org/10.1111/eva.13057

## Appendix A: Miniconda installation

To install the latest version of [Miniconda](https://docs.conda.io/en/latest/miniconda.html) on a Linux system please execute:
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
source .bashrc
```
