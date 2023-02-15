#!/bin/bash

# Test for integration of Parsl with Work Queue and TaskVine starting from Conda install.

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=
export CONDA_ENV=./wq_vine_parsl
export LOCAL_PARSL=./parsl

#trap cleanup EXIT

cleanup() {
    rm -rf ${CONDA_ENV}
    rm -rf ${LOCAL_PARSL}
}


# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh


# Create local conda environment:
conda create --yes --prefix ${CONDA_ENV} -c conda-forge python=3.9

# Install Parsl manually from tphung's PR
git clone git@github.com:tphung3/parsl.git parsl
git checkout taskvine-integration
pip install ${LOCAL_PARSL}
exit
# Install CCTools taskvine

# Run Parsl application with WQ option.
# Note that it internally uses the local provider to start workers.
conda run --prefix ${CONDA_ENV} python parsl-test.py
status=$?

exit $status
