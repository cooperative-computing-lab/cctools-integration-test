#!/bin/sh

export MINIDIR=`pwd`/miniconda

# Download Miniconda
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > conda-install.sh 

# Bootstrap Conda and install into shell
bash conda-install.sh -p `pwd`/miniconda -b
export PATH=${MINIDIR}/bin:$PATH
source ${MINIDIR}/etc/profile.d/conda.sh

#################################################################
# NOTE: The current Coffea-WQ instructions do not work.
# Once these are figured out and working, we need to update
# the instructions in the Coffea project:
# https://coffeateam.github.io/coffea/wq.html#intro-coffea-wq
#################################################################

conda create --name conda-coffea-wq-env
conda activate conda-coffea-wq-env

# Now do the software install
conda install python=3.8.3 six dill
conda install -c conda-forge ndcctools conda-pack
pip install --no-input coffea

# Now build the desired software tarball
conda-pack --name conda-coffea-wq-env --output=conda-coffea-wa-env.tar.gz

#################################################################

# CAREFUL:
# These are the old instructions, and don't work:
# 1 - conda-pack doesn't work in python 3.8.5 for some reason.  Use python 3.8.3
# 2 - Use the conda-pack package and command line tool directly for clarity.
# 3 - Let coffea pull its own dependencies for xrootd.

#conda create --name conda-coffea-wq-env python=3.8 six dill
#conda activate conda-coffea-wq-env
#conda install -c conda-forge xrootd ndcctools
#pip install --no-input coffea
#conda activate base

#pip install --no-input conda-pack
#python -c 'import conda_pack; conda_pack.pack(name="conda-coffea-wq-env", output="conda-coffea-wq-env.tar.gz")'
