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
if ! make test
then
    echo === Contents of cctools.test.fail ===
    cat cctools.test.fail
    exit 1
else
    exit 0
fi
echo =============================================
make install
echo =============================================
cd ..
export PATH=${PREFIX}/bin:${PATH}
exec ./smoke.sh
echo =============================================
