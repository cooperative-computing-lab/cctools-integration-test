#!/bin/sh

git clone https://github.com/spack/spack spack
export SPACK_ROOT=`pwd`/spack
. spack/share/spack/setup-env.sh
spack install cctools

