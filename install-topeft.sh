#!/bin/bash

. install-common.sh

# Installing fresh from conda is too slow, use micromamba instead.
curl -L micro.mamba.pm/install.sh >install-micromamba.sh
chmod 755 install-micromamba.sh
bash ./install-micromamba.sh

# Activate the shell hooks without starting a new shell.
export MAMBA_ROOT_PREFIX=$HOME/micromamba
eval "$($HOME/.local/bin/micromamba shell hook --shell bash)"

# Activate the root environment
micromamba activate
			       
CFG_DIR=$(realpath topcoffea-conf)
DATA_FILE=${CFG_DIR}/ttHJet_UL17_R1B14_NAOD-00000_10194_NDSkim.root
CFG=$(realpath ${CFG_DIR}/UL17_private_ttH_for_CI.json)

if [[ ! -f ${DATA_FILE} ]]
then
    curl -L -o ${DATA_FILE} https://ccl.cse.nd.edu/workflows/topcoffea-test-data/ttHJet_UL17_R1B14_NAOD-00000_10194_NDSkim.root
fi

git clone https://github.com/TopEFT/topeft.git
cd topeft
unset PYTHONPATH 
micromamba create -y -n coffea-env -f environment.yml
micromamba activate coffea-env
pip install -e .
cd ..

git clone https://github.com/TopEFT/topcoffea.git
cd topcoffea
unset PYTHONPATH
pip install -e .
cd ..

