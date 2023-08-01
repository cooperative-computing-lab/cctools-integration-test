#!/bin/sh

# Install all the development dependencies from conda.
source ./install-conda-devel.sh

# Then get and build the sources from github.
source ./install-github.sh

# Run the basic smoke tests.
source ./test-smoke.sh
