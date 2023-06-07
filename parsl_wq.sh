#!/bin/bash

# Test for integration of Parsl with Work Queue starting from Conda install.

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=
export CONDA_ENV=./wq_parsl
export LOCAL_PARSL_SRC=./parsl-src

trap cleanup EXIT

cleanup() {
    rm -rf ${CONDA_ENV}
    rm -rf ${LOCAL_PARSL_SRC}
    rm -rf runinfo
}

# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

conda create --yes --prefix ${CONDA_ENV} -c conda-forge --strict-channel-priority python=3.9 ndcctools parsl

# Run Parsl application with WQ.
# Note that it internally uses the local provider to start workers.
conda run --prefix ${CONDA_ENV} python parsl-wq-test.py
status=$?

exit $status
