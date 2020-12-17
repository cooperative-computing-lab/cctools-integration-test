#!/bin/sh

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=

export MINIDIR=`pwd`/miniconda

echo "*** Download Miniconda"
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > conda-install.sh 

echo "*** Bootstrap miniconda"
bash conda-install.sh -p `pwd`/miniconda -b
export PATH=${MINIDIR}/bin:$PATH
. ${MINIDIR}/etc/profile.d/conda.sh

echo "*** Install Conda and Pip packages"
conda create --name coffea-env
conda activate coffea-env
conda install -y python=3.8.3 six dill
conda install -y -c conda-forge coffea ndcctools conda-pack xrootd

echo "*** Create the Conda-Pack tarball"
conda-pack --name coffea-env --output coffea-env.tar.gz

echo "*** Starting a single WQ worker"
work_queue_worker -d all -o worker.log localhost 9123 &

echo "*** Execute Coffea Application"
python coffea-test.py

