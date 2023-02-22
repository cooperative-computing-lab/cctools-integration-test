#!/bin/bash

# Test for integration of Parsl with Work Queue and TaskVine starting from Conda install.

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=
export CONDA_ENV=./wq_vine_parsl
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

# Create local conda environment that can compile and install CCTools on the master branch,
# this listing of packages can be found on CCTools installation webpage (install from GitHub):
conda create --yes --prefix ${CONDA_ENV} -c conda-forge --strict-channel-priority python=3.9 gcc_linux-64 gxx_linux-64 gdb m4 perl swig make zlib libopenssl-static openssl conda-pack pip ndcctools git

# Install Parsl manually from tphung's PR
conda run --prefix ${CONDA_ENV} git clone https://github.com/tphung3/parsl.git ${LOCAL_PARSL_SRC}
cd ${LOCAL_PARSL_SRC}
conda run --prefix ../${CONDA_ENV} git checkout taskvine-integration
cd -
conda run --prefix ${CONDA_ENV} pip install ${LOCAL_PARSL_SRC}

# Run Parsl application with WQ and TaskVine.
# Note that it internally uses the local provider to start workers.
conda run --prefix ${CONDA_ENV} python parsl-test.py
status=$?

exit $status
