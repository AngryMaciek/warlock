###############################################################################
#
#   Main execution script for the workflow
#
#   AUTHOR: Maciej_Bak
#   CONTACT: wsciekly.maciek@gmail.com
#   CREATED: 15-02-2022
#   LICENSE: Apache_2.0
#
###############################################################################

# exit at a first command that exits with a !=0 status
set -eo pipefail

user_dir=$PWD
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$repo_dir"

# in case of SIGINT go back to the user dir
goback () {
    rc=$?
    cd "$user_dir"
    echo "Exit status: $rc"
}
trap goback SIGINT

###############################################################################
# parse command line arguments
###############################################################################

# no args
if [ $# -eq 0 ]
then
    echo "Please execute $ warlock.sh --help to learn how to call this script."
fi

# --help msg
if printf '%s\n' "$@" | grep -q '^--help$'; then
    echo "This is the main script to call the warlock workflow."
    echo "Available options:"
    echo ""
    echo "  -c/--configfile {XXX} (REQUIRED)"
    echo "  Path to the snakemake config file."
    echo ""
    echo "  -e/--environment {local/slurm} (REQUIRED)"
    echo "  Environment to execute the workflow in:"
    echo "  * local = execution on the local machine."
    echo "  * slurm = slurm cluster support."
    echo ""
    echo "  -n/--cores {XXX} (OPTIONAL)"
    echo "  Number of cores available for the workflow."
    echo "  (Default = 1)"
    exit 0
fi

# parse args
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -c|--configfile)
            CONFIGFILE="$2"
            shift # past argument
            shift # past value
            ;;
        -e|--environment)
            ENV="$2"
            shift # past argument
            shift # past value
            ;;
        -n|--cores)
            CORES="$2"
            shift # past argument
            shift # past value
            ;;
        *) # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

###############################################################################
# MAIN
###############################################################################

# configfile is always required
if [ -z "$CONFIGFILE" ]; then
    echo "Invalid arguments. Please provide --configfile"
    exit 1
fi
if ! [[ "$CONFIGFILE" = /* ]]; then
    CONFIGFILE=$user_dir/$CONFIGFILE
fi
if ! [ -f "$CONFIGFILE" ]; then
    echo "Invalid arguments. Configuration file does not exist"
    exit 1
fi

# check environment parameter
if [ -z "$ENV" ]; then
    echo "Invalid arguments. Please provide --environment"
    exit 1
fi
if [ "$ENV" != "local" ] && [ "$ENV" != "slurm" ]; then
    echo "Invalid arguments. --environment = {local/slurm}"
    exit 1
fi

# set default number of cores
if [ -z "$CORES" ]; then
    CORES=1
fi

# in order to use R from conda-forge I need to set these env variables:
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

# select a proper smk profile based on the command line args
case "$ENV" in
    local)
        snakemake \
            --configfile="$CONFIGFILE" \
            --profile="workflow/profiles/local" \
            --cores="$CORES" \
            --nolock \
            all
        ;;
    slurm)
        snakemake \
            --configfile="$CONFIGFILE" \
            --profile="workflow/profiles/slurm" \
            --cores="$CORES" \
            --nolock \
            all
        ;;
esac
