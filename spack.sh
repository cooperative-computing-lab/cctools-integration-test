#!/bin/sh

git clone https://github.com/spack/spack spack
#git clone -b cctools-packaging-test --single-branch https://github.com/btovar/spack

export SPACK_ROOT=`pwd`/spack
. spack/share/spack/setup-env.sh

if spack install --test root cctools
then
    echo "spack install succeeded"
else
    cat /tmp/runner/spack-stage/spack-stage-cctools-*/spack-build-out.txt
    echo "========================================================"
    echo "spack install failed"
    echo "========================================================"
    exit 1
fi
