#!/bin/sh

set -e

TARBALL="cctools-nightly-x86_64-ubuntu20.04.tar.gz"
PREFIX=`pwd`/cctools

wget "https://github.com/cooperative-computing-lab/cctools/releases/download/nightly/${TARBALL}"

mkdir ${PREFIX}
tar -C "${PREFIX}" --strip-components=1 "${TARBALL}"

export PATH=${PREFIX}/bin:${PATH}


# Add some tests...
parrot_run -- stat /cvmfs/cms.cern.ch/releases.map

