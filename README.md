[![ci](https://github.com/AngryMaciek/demon-runner/workflows/ci/badge.svg)](https://github.com/AngryMaciek/demon-runner/actions?query=workflow%3Aci)
[![GitHub issues](https://img.shields.io/github/issues/AngryMaciek/demon-runner)](https://github.com/AngryMaciek/demon-runner/issues)
[![GitHub license](https://img.shields.io/github/license/AngryMaciek/demon-runner)](https://github.com/AngryMaciek/demon-runner/blob/master/LICENSE)

# _demon-runner_

_demon_ (deme-based oncology model) is a flexible framework for modelling intra-tumour population genetics with varied spatial structures and modes of cell dispersal.  
The following repository encapsulates _demon_ into an automated and reproducible [Snakemake](https://snakemake.readthedocs.io/en/stable/) workflow in order to simplify parallel simulations to all users.

## Installation

**The workflow is designed to run on Linux-based systems.**  
We have prepared a dedicated [conda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/environments.html) recipe which will contain all prerequisites required to execute the workflow. Thus Anaconda/Miniconda package manager is a natural dependency (see [Appendix A](#appendix-a-miniconda-installation) for installation instructions.)

1. Clone the repository and navigate inside that directory
   ```
   git clone https://github.com/AngryMaciek/demon-runner.git
   cd demon-runner
   ```
2. Create and activate conda environment
   ```
   conda env create
   conda activate demon-runner
   ```
3. Compile _demon_
   ```
   g++ workflow/src/demon.cpp -o workflow/bin/demon -I/usr/share/miniconda3/envs/demon-runner/include -lm
   ```
   _(assuming here that `/usr/share/miniconda3` is a path to your installation of the Miniconda package manager, please adjust if required)_

## Configuration

Original configuration file for _demon_ sets the following model parameters:

>**Spatial structure**
>* `int log2_deme_carrying_capacity`: log2 of deme carrying capacity
>
>**Dispersal**
>* `float migration_type`: type of cell dispersal (0 = invasion; 2 = deme fission)
>* `float init_migration_rate`: initial invasion rate or deme fission rate (-1 = set automatically)
>* `int migration_edge_only`: whether dispersal is limited to the tumour boundary (0 = no; 1 = yes)
>* `int migration_rate_scales_with_K`: whether to divide dispersal rates by the square root of the deme carrying capacity (0 = no; 1= yes)
>
>**Mutation rates**
>* `float mu_driver_birth`: driver mutation rate per cell division (for drivers affecting division rate)
>* `float mu_passenger`: passenger mutation rate per cell division
>* `float mu_driver_migration`: driver mutation rate per cell division (for drivers affecting dispersal rate)
>* `int passenger_pop_threshold`: population size at which passenger mutations stop occurring (-1 = no threshold)
>
>**Fitness effects**
>* `float normal_birth_rate`: normal cell division rate, relative to tumour cell division rate (-1 = no normal cells)
>* `float baseline_death_rate`: baseline death rate, independent of deme population size
>* `float s_passenger`: deleterious effect on division rate per passenger mutation
>* `float s_driver_birth`: beneficial effect on division rate per driver mutation (for drivers affecting division rate)
>* `float s_driver_migration`: beneficial effect on dispersal rate per driver mutation (for drivers affecting dispersal rate)
>* `float max_relative_birth_rate`: maximum division rate, relative to initial division rate
>* `float max_relative_migration_rate`: maximum dispersal rate, relative to initial dispersal rate
>
>**Non-biological parameters**
>* `int seed`: seed for pseudo-random number generator
>* `int init_pop`: initial tumour cell population
>* `int max_time`: max elapsed time before program halts, in seconds
>* `int max_pop`: max tumour cell population before program halts
>* `int max_generations`: max cell generations before program halts
>* `int matrix_max`: max number of genotypes before program halts (larger value => more allocated memory)
>* `int write_grid`: whether to generate plots of grid states during execution (can significantly increase running time)
>* `int write_clones_file`: whether to write contents of all clones (can be a very large file; typically unnecessary)
>* `int write_demes_file`: whether to write contents of all demes (can be a very large file; typically unnecessary)
>* `int record_matrix`: whether to record genetic distance matrix for all genotypes (can be a very large file; typically unnecessary)
>* `int write_phylo`: whether to write phylogeny for all genotypes (can be a very large file; typically unnecessary)
>* `int calculate_total_diversity`: whether to calculate diversity across all genotypes (can be computationally expensive)
>* `int biopsy_size_per_sample`: max number of cells per biopsy sample (reserved for future applications)

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

After each pipeline run the main output directory will contain two subdirectories: `simulations` and `logs`. The former is where all the results are stored whereas the latter keeps captured standard output and error streams for the jobs. Each _demon_ run generates multiple output files which will be stored under separate subdirectories of `simulations`. These subdirectories are encoded by 4-letter codes, in order to learn about specific parameters utilised for each of the runs please inspect the `config.dat` file located inside each of those folders.

## Community guidelines
For guidelines on how to contribute to the project or report issues, please see [contributing instructions](/CONTRIBUTING.md).  
For other inquires feel free to contact the developers at _wsciekly.maciek@gmail.com_

## Appendix A: Miniconda installation

To install the latest version of [Miniconda](https://docs.conda.io/en/latest/miniconda.html) on a Linux system please execute:
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
source .bashrc
```
