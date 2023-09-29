#!/bin/bash

. install-common.sh

CFG_DIR=$(realpath topcoffea-conf)
DATA_FILE=${CFG_DIR}/ttHJet_UL17_R1B14_NAOD-00000_10194_NDSkim.root

CFG=$(realpath ${CFG_DIR}/UL17_private_ttH_for_CI.json)
if [[ ! -f ${DATA_FILE} ]]
then
    curl -o ${DATA_FILE} http://ccl.cse.nd.edu/workflows/topcoffea-test-data/ttHJet_UL17_R1B14_NAOD-00000_10194_NDSkim.root
fi

conda create -y -q -p ${CONDA_ENV} -c conda-forge --strict-channel-priority --experimental-solver=libmamba python=3 coffea xrootd ndcctools dill conda conda-pack git

conda activate ${CONDA_ENV}

git clone https://github.com/TopEFT/topcoffea.git

cd topcoffea

unset PYTHONPATH
pip install -e .

cd ..




