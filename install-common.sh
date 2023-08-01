# Common setup steps for all install modes.

# Enable echo of all commands and stop on any failure.
set -xe

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=

# Put the Conda environment into this local path
export CONDA_ENV=`pwd`/cctools-test-env

# On exit, destroy the conda environment, to ensure a clean run each time.
trap cleanup EXIT

cleanup() {
    rm -rf ${CONDA_ENV}
}

# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

