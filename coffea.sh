#!/bin/sh

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=

export MINIDIR=`pwd`/miniconda

echo "*** Download Miniconda"
#curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > conda-install.sh 

echo "*** Bootstrap miniconda"
bash conda-install.sh -p `pwd`/miniconda -b
export PATH=${MINIDIR}/bin:$PATH
source ${MINIDIR}/etc/profile.d/conda.sh

#################################################################
# NOTE: The current Coffea-WQ instructions do not work.
# Once these are figured out and working, we need to update
# the instructions in the Coffea project:
# https://coffeateam.github.io/coffea/wq.html#intro-coffea-wq
#################################################################

echo "*** Install Conda and Pip packages"
conda create --name conda-coffea-wq-env
conda activate conda-coffea-wq-env
conda install -y python=3.8.3 six dill
conda install -y -c conda-forge ndcctools conda-pack xrootd
pip install --no-input coffea

echo "*** Create the Conda-Pack tarball"
conda-pack --name conda-coffea-wq-env --output conda-coffea-wq-env.tar.gz

echo "*** Starting a single WQ worker"
work_queue_worker -d all -o worker.log localhost 9123 &

echo "*** Execute Coffea Application"
python coffea-test.py

