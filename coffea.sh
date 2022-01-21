#!/bin/sh

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=

# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

echo "*** Install Conda and Pip packages"
conda create -y --name coffea-env
conda activate coffea-env
conda install -y python=3.8.3 six dill
conda install -y -c conda-forge coffea ndcctools xrootd
echo "*** All packages successfully installed"

echo "*** Create the Conda-Pack tarball"
conda-pack --name coffea-env --output coffea-env.tar.gz

echo "*** Starting a single WQ worker"
work_queue_worker -d all -o worker.log localhost 9123 &

echo "*** Downloading current wq-example.py from coffea documentation"
wget https://raw.githubusercontent.com/CoffeaTeam/coffea/master/docs/source/wq-example.py -O coffea-test-downloaded.py

echo "*** Execute static Coffea Application currently located in repository"
python coffea-test.py

echo "*** Execute most recent work_queue example Coffea Application currently located in the Coffea GitHub"
python coffea-test-downloaded.py


