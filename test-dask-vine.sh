#!/bin/sh

# Test for integration of Dask with TaskVine starting from Conda install.
source ./install-dask-cctools.sh

# Run Dask test, creating a worker internally using the factory.
python3 test-vine-dask.py
