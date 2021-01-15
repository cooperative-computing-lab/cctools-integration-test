#!/bin/sh

# Test for integration of Parsl and Work Queue starting from Conda install.

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=

# Create local Conda environment
conda create --name wq_parsl python=3.6 conda-pack

# Activate the environment without creating a new shell
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh
conda activate wq_parsl

# Install software into the new environment.
conda install -c conda-forge parsl ndcctools

# Run Parsl application with WQ option.
# Note that it internally uses the local provider to start workers.
python parsl-test.py
exit $?
