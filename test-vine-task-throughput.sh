#!/bin/sh

# Install conda development environment
. ./install-conda-devel.sh

# Install conda development environment
. ./install-github.sh

# Run the test case.
python test-vine-task-throughput.py
python test-vine-task-serverless.py