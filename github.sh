#!/bin/sh

PREFIX=`pwd`/cctools
git clone https://github.com/cooperative-computing-lab/cctools github-cctools
cd github-cctools
./configure --prefix $PREFIX
make install
