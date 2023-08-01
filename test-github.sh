#!/bin/sh

# Assume we have minimal dependencies available in the build environment.
# Then get and build the sources from github.
. ./install-github.sh

# Run the basic smoke tests.
../test-smoke.sh
