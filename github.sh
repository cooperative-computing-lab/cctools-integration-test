#!/bin/sh

set -xe

PREFIX=`pwd`/cctools
git clone https://github.com/cooperative-computing-lab/cctools github-cctools
cd github-cctools
echo =============================================
./configure --prefix $PREFIX
echo =============================================
make
echo =============================================
make test
echo =============================================
make install
echo =============================================
cd ..
export PATH=${PREFIX}/bin:${PATH}
exec ./smoke.sh
echo =============================================
