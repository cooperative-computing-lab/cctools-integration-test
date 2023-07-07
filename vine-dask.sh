#!/bin/sh

export PYTHONPATH=

# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

conda create --yes --prefix ${CONDA_ENV} -c conda-forge --strict-channel-priority ndcctools dask

conda run --prefix ${CONDA_ENV} python vine-dask-test.py

status=$?

exit $status
