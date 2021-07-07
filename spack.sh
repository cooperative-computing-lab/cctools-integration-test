#!/bin/sh

#git clone https://github.com/spack/spack spack
git clone -b cctools-packaging-test --single-branch https://github.com/btovar/spack

export SPACK_ROOT=`pwd`/spack
. spack/share/spack/setup-env.sh

if spack install --test root cctools
then
    echo "spack install succeeded"
else
    echo "spack install failed"
    cat /tmp/runner/spack-stage/spack-stage-cctools-*/spack-build-out.txt
fi
