#!/bin/sh

set -xe

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=

# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

# Create and install a new development environment.
conda create -yq --name cctools-test -c conda-forge --strict-channel-priority python=3 gcc_linux-64 gxx_linux-64 gdb m4 perl swig make zlib libopenssl-static openssl conda-pack cloudpickle packaging
conda activate cctools-test

# Now build and install from github and test that.
exec ./github.sh
