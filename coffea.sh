#!/bin/sh

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=

# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

echo "*** Install Conda and Pip packages"
conda create -y --name coffea-env -c conda-forge --strict-channel-priority python=3.9 six dill coffea ndcctools xrootd
conda activate coffea-env

echo "*** Create the Conda-Pack tarball"
conda-pack --name coffea-env --output coffea-env.tar.gz

echo "*** Starting a single WQ worker"
work_queue_worker -d all -o worker.log localhost 9123 &
# acquire PID of worker to kill it later
STATIC_WORKER_PID=$!

echo "*** Downloading current wq-example.py from coffea documentation"
wget https://raw.githubusercontent.com/CoffeaTeam/coffea/master/docs/source/wq-example.py -O coffea-test-downloaded.py

echo "*** Execute static Coffea Application currently located in repository"
python coffea-test.py

echo "*** Killing old worker and starting new one to run downloaded Coffea example. Also deletes the wq-factory folder to avoid a fatal error"
kill $STATIC_WORKER_PID
rm -rfd wq-factory-*

echo "*** Starting a single WQ worker"
work_queue_worker -d all -o worker.log localhost 9123 &

sleep 5
echo "*** Execute most recent work_queue example Coffea Application currently located in the Coffea GitHub"
python coffea-test-downloaded.py

