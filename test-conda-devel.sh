#!/bin/sh

# Install all the development dependencies from conda.
. ./install-conda-devel.sh

# Then get and build the sources from github.
. ./install-github.sh

# Run the basic smoke tests.
../test-smoke.sh
