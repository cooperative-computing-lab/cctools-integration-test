#! /bin/bash

set -ex

# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

echo "*** Install Conda and Pip packages"

CFG_DIR=$(realpath topcoffea-conf)
DATA_FILE=${CFG_DIR}/ttHJet_UL17_R1B14_NAOD-00000_10194_NDSkim.root

CFG=$(realpath ${CFG_DIR}/UL17_private_ttH_for_CI.json)
if [[ ! -f ${DATA_FILE} ]]
then
    curl -o ${DATA_FILE} https://ccl.cse.nd.edu/workflows/topcoffea-test-data/ttHJet_UL17_R1B14_NAOD-00000_10194_NDSkim.root
fi

if [[ ! -d topcoffea-env ]]
then
    conda create -y -q --prefix topcoffea-env -c conda-forge --strict-channel-priority --experimental-solver=libmamba python=3 coffea xrootd ndcctools dill conda conda-pack git
fi

conda activate ./topcoffea-env

if [[ ! -d topcoffea ]]
then
    git clone https://github.com/TopEFT/topcoffea.git
fi

cd topcoffea

unset PYTHONPATH
pip install -e .

cd analysis/topEFT

echo "*** Starting a single WQ worker"
work_queue_worker -d all -o worker.log --single-shot -t 300 localhost 9123 &

echo "*** Execute TopCoffea Application"
python run_topeft.py --executor work_queue ${CFG}\
    -o output_check_yields_wq\
    -p histos\
    --prefix ${CFG_DIR}/\
    --port 9123-9124\
    --chunksize 25000

echo "*** Extract results for comparison"
python get_yield_json.py -f histos/output_check_yields_wq.pkl.gz  -n output_check_yields_wq

echo "*** Compare results with ground truth"
python comp_yields.py output_check_yields_wq.json ${CFG_DIR}/ground_truth_yield.json -t1 'New yields' -t2 'Ref yields' --tolerance 1.00



