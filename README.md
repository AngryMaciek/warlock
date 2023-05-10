[![Contribute with Gitpod](https://img.shields.io/badge/Contribute%20with-Gitpod-908a85?logo=gitpod)](https://gitpod.io/#https://github.com/AngryMaciek/warlock)
[![ci-pipeline](https://github.com/AngryMaciek/warlock/workflows/ci-pipeline/badge.svg)](https://github.com/AngryMaciek/warlock/actions?query=workflow%3Aci-pipeline)
[![CodeFactor](https://www.codefactor.io/repository/github/angrymaciek/warlock/badge/master)](https://www.codefactor.io/repository/github/angrymaciek/warlock/overview/master)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/AngryMaciek/warlock/master?labpath=notebook.ipynb)
[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/r/angrymaciek/warlock)
[![GitHub issues](https://img.shields.io/github/issues/AngryMaciek/warlock)](https://github.com/AngryMaciek/warlock/issues)
[![GitHub license](https://img.shields.io/github/license/AngryMaciek/warlock)](https://github.com/AngryMaciek/warlock/blob/master/LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7435093.svg)](https://doi.org/10.5281/zenodo.7435093)
[![preprint](https://img.shields.io/badge/preprint-arXiv-red)](https://arxiv.org/abs/2301.07808)
[![Twitter](https://img.shields.io/twitter/follow/angrymaciek.svg?style=social&label=Follow)](https://twitter.com/search?l=&q=%23warlock%20from%3Aangrymaciek%20OR%20from%3Arobjohnnoble)

# _warlock_ 🧙‍♂️

[_demon_](https://github.com/robjohnnoble/demon_model) (deme-based oncology model) is a flexible framework for modelling intra-tumour population genetics with varied spatial structures and modes of cell dispersal. It is primarly designed for computational biologists and mathematicians who work in the field of ecology on a cellular level; investiaging mechanisms behind tumour evolution.

The following repository encapsulates _demon_ into an automated and reproducible _snakemake_ workflow in order to simplify parallel simulations to all users. Just as a regular [_warlock_](https://en.wikipedia.org/wiki/Warlock_(Dungeons_%26_Dragons)), it can spawn multiple demons (as cluster jobs), provided enough mystic powers (computational resources) are available.

## Installation

**The workflow is designed to run on Linux and macOS systems.**  
We have prepared a dedicated [conda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/environments.html) recipe which will contain all prerequisites required to execute the workflow. Thus Anaconda/Miniconda package manager is a natural dependency (see [Appendix A](#appendix-a-miniconda-installation) for installation instructions.)

1. Clone the repository and navigate inside that directory
   ```bash
   git clone https://github.com/AngryMaciek/warlock.git --recursive
   cd warlock
   ```

    > Note: if you wish to compile a different version of _demon_ (i.e. other branch) please remember to navigate to `resources/demon_model` first and `git checkout` a proper branch of that repository.

2. Create and activate conda environment
   ```bash
   conda env create
   conda activate warlock
   ```
3. Compile _demon_
   * Linux:
     ```bash
     g++ resources/demon_model/src/demon.cpp -o resources/demon_model/bin/demon -I$HOME/miniconda3/envs/warlock/include -lm
     ```
   * macOS:
     ```bash
     clang++ resources/demon_model/src/demon.cpp -o resources/demon_model/bin/demon -I$HOME/miniconda3/envs/warlock/include -lm
     ```

    > Note: remember to adjust `miniconda3` (and its path) in the command above, in case you have a different manager installed on your system. All in all, the point is to provide the _include_ directory of your `warlock` environment to the compiler.

## Configuration

For a detailed description of all available simulation parameters please inspect [GitHub repository](https://github.com/robjohnnoble/demon_model) of the core _demon_ model.

These parameters are now required to be set inside a YAML-formatted pipeline configuration file. A template for this file is available [here](/workflow/config/config.yml). Please see an example configuration file designed for the CI tests [here](/tests/test2/config-Ubuntu.yml). Note that multiple values for distinct parameters might be provided in lists. Current implementation of the workflow prepares a Cartesian product of all parameter's values and runs _demon_ with each of them in parallel.

Additionally, please notice that two absolute paths are required to be set in the same configuration file: path to this cloned repository as well as path for the analyses output directory.

## Execution

This workflow should be executed via a top-level bash script: `warlock.sh` which has the following description:
```
This is the main script to call the _warlock_ workflow.
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
bash warlock.sh --configfile {PATH} --environment local
```

### Docker container

We have additionally prepared a development/execution Docker image which one may use in order to
run _warlock_ in a fully encapsulated environment (that is, a container).  
Assuming the Docker Engine is running locally please build the image with:
```
docker build -t warlock:latest .
```
To test the container one can execute the following bash command:
```
docker run --name warlock warlock bash -c "source ~/.bashrc; bash testscript.sh"
```
Finally, enter the container to start your work with:
```
docker run -it warlock:latest
```
Alternatively, please note that the image is also uploaded to [DockerHub](https://hub.docker.com/repository/docker/angrymaciek/warlock/), one may download it with:
```
docker pull angrymaciek/warlock:{TAG}
```


### SLURM cluster

Example command for a cluster-supported workflow execution:
```
bash warlock.sh --configfile {PATH} --environment slurm
```

Please note that, depending on the complexity of the simulations, it might be required to adjust parameters for cluster jobs. If the expected required resources (memory or computation time) are high please adjust `time` and `mem` fields in the cluster submission configuration file, located at: [`/workflow/profiles/slurm/slurm-config.json`](/workflow/profiles/slurm/slurm-config.json).  

Running large workflows with hundreds of cluster jobs might take very long; consider executing _warlock_ in a terminal multiplexer, e.g. [tmux](https://github.com/tmux/tmux/wiki).

## Output

After each pipeline run the main output directory will contain three subdirectories: `configfiles`, `simulations` and `logs`. Each simulation run with a specific set of parameters is encoded by a 4-letter code. The first directory contains configuration files for each of the simulation runs; `simulations` contain all _demon_ output files; `logs` keep captured standard output and error streams for the commands.

## Example

Feel free to run the pipeline and inspect the results yourself in an [interactive jupyter notebook](https://mybinder.org/v2/gh/AngryMaciek/warlock/master?labpath=notebook.ipynb) we prepared.  
Alternatively, feel free to run a small test script on your local machine with
`bash testscript.sh`.

## Community guidelines
For guidelines on how to contribute to the project or report issues, please see [contributing instructions](/CONTRIBUTING.md).  
For other inquires feel free to contact project lead by email: [✉️](mailto:wsciekly.maciek@gmail.com)

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

For other platforms, see all available installers [here](https://docs.conda.io/en/latest/miniconda.html#latest-miniconda-installer-links).
