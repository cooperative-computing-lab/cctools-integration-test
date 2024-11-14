#!/bin/sh

# Install conda development environment
. ./install-conda-devel.sh

# Install conda development environment
source ./install-github.sh

conda create -yq --prefix ${CONDA_ENV} -c conda-forge --strict-channel-priority ndcctools dask
conda activate ${CONDA_ENV}

# Run the serverless test case.
python3 test-vine-task-throughput.py
python3 test-vine-task-serverless.py