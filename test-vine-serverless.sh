#!/bin/sh

# Install conda development environment
source ./install-conda-devel.sh

# Install conda development environment
source ./install-github.sh

# Run the serverless test case.
python3 test-vine-serverless.py
