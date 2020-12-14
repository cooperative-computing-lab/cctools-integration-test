#!/bin/sh

#curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > conda-install.sh
#bash conda-install.sh -p `pwd`/miniconda -b
export PATH=`pwd`/miniconda/bin:$PATH
conda install -y -c conda-forge ndcctools


