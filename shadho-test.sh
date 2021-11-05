#!/bin/sh

#unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=

#activate the conda shell hooks without starting a new shell
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh

#create conda environment for shadho
conda create --name shadho-test -y
conda activate shadho-test

#install ndcctools and shadho
conda install -c conda-forge ndcctools -y
conda install pip -y	#shadho is installed through pip
python -m pip install shadho

#run work_queue_worker. This command is heuristic and based on shadho code.
$CONDA_PREFIX/bin/work_queue_worker -M sin_ex-tphung --cores 1 --single-shot &

#get worker pid to kill later
export SHADHO_WORKER_PID=$!

#run manager with simple application
python wq_sin.py

#remove resulting files from shadho application
rm results.json results.json.bak.1 
rm shadho_master.debug shadho_master.log

#kill the worker, to be sure
kill -2 $SHADHO_WORKER_PID

#deactivate and remove the created environment
conda deactivate
conda remove --name shadho-test --all -y

#kill the shell that runs this script
kill -2 $$
