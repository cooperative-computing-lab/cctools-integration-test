#!/bin/bash

# Test for integration of Parsl with TaskVine starting from Conda install.
. ./install-parsl-cctools.sh

# Run Parsl application with TaskVine. Note that it internally uses the local provider to start 1 worker.
python3 test-parsl-vine.py
