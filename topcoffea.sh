#! /bin/bash

# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

echo "*** Install Conda and Pip packages"

CFG_DIR=$(realpath topcoffea-conf)
DATA_FILE=${CFG_DIR}/ttHJet_UL17_R1B14_NAOD-00000_10194_NDSkim.root

CFG=$(realpath ${CFG_DIR}/UL17_private_ttH_for_CI.json)
if [[ ! ${DATA_FILE} ]]
then
    curl -o ${DATA_FILE} http://www.crc.nd.edu/~kmohrman/files/root_files/for_ci/ttHJet_UL17_R1B14_NAOD-00000_10194_NDSkim.root
fi

if [[ ! -d topcoffea-env ]]
then
    conda create -y --prefix topcoffea-env -c conda-forge --strict-channel-priority python=3.9 coffea xrootd ndcctools dill conda conda-pack git
fi

conda activate ./topcoffea-env

git clone https://github.com/TopEFT/topcoffea.git
cd topcoffea

unset PYTHONPATH
pip install -e .

cd analysis/topEFT

echo "*** Starting a single WQ worker"
work_queue_worker -d all -o worker.log --single-shot -t 300 localhost 9123 &

echo "*** Execute TopCoffea Application"
python work_queue_run.py ${CFG}\
    -o output_check_yields_wq\
    -p histos\
    --prefix ${CFG_DIR}/\
    --port 9123-9124\
    --chunksize 25000
