#!/bin/sh

# Assume we have minimal dependencies available in the build environment.
# Then get and build the sources from github.
source ./install-github.sh

# Run the basic smoke tests.
source ./test-smoke.sh
