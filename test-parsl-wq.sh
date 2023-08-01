#!/bin/bash

# Test for integration of Parsl with Work Queue starting from Conda install.

# Install parsl and cctools together
source ./install-parsl-cctools.sh

# Run the test.
python3 test-parsl-wq.py
