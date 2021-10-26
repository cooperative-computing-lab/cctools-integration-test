#!/bin/bash

# Test for integration of Parsl and Work Queue starting from Conda install.

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=
export CONDA_ENV=./wq_parsl

trap cleanup EXIT

cleanup() {
    rm -rf ${CONDA_ENV}
}


# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh


# Create local conda environment:
conda create --yes --prefix ${CONDA_ENV} -c conda-forge python=3.9 parsl ndcctools

# Run Parsl application with WQ option.
# Note that it internally uses the local provider to start workers.
conda run --prefix ${CONDA_ENV} python parsl-test.py
status=$?

exit $status
