#!/bin/sh

# Test for integration of Dask with TaskVine starting from Conda install.
. ./install-dask-cctools.sh

# Run Dask test, creating a worker internally using the factory.
python3 test-dask-vine.py
