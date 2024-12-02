#!/bin/sh

# Install conda development environment
. ./install-conda-devel.sh

# Install conda development environment
. ./install-github.sh

# Run the test case.
python3 test-vine-task-throughput.py
python3 test-vine-task-serverless.py