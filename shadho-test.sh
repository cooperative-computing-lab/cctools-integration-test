#!/bin/sh

export PYTHONPATH=

CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

conda create --name shadho-test-v5 -y
conda activate shadho-test-v5
conda install -c conda-forge ndcctools -y
conda install pip -y
python -m pip install shadho
python -m shadho.workers.workqueue -M sin_ex &
export SHADHO_WORKER_PID=$!
python shadho-test-files/wq_sin.py
rm results.json results.json.bak.1 
rm shadho_master.debug shadho_master.log
kill -2 $SHADHO_WORKER_PID
conda deactivate
conda remove --name shadho-test-v5 --all -y
kill -2 $$
