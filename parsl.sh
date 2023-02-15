#!/bin/bash

# Test for integration of Parsl with Work Queue and TaskVine starting from Conda install.

# Fix for local environment at ND: unset PYTHONPATH to ignore existing python installs.
export PYTHONPATH=
export CONDA_ENV=./wq_vine_parsl
export LOCAL_PARSL=./parsl
export LOCAL_CCTOOLS_SRC=./cctools-src

#trap cleanup EXIT

cleanup() {
    rm -rf ${CONDA_ENV}
    rm -rf ${LOCAL_PARSL}
    rm -rf {$LOCAL_CCTOOLS_SRC}
}


# Activate the Conda shell hooks without starting a new shell.
CONDA_BASE=$(conda info --base)
. $CONDA_BASE/etc/profile.d/conda.sh


# Create local conda environment that can compile and install CCTools on the master branch,
# this listing of packages can be found on CCTools installation webpage (install from GitHub):
conda create --yes --prefix ${CONDA_ENV} -c conda-forge --strict-channel-priority python=3.9 gcc_linux-64 gxx_linux-64 gdb m4 perl swig make zlib libopenssl-static openssl conda-pack

#Install CCTools on master branch
git clone git@github.com:cooperative-computing-lab/cctools.git ${LOCAL_CCTOOLS_SRC}
git checkout master
${LOCAL_CCTOOLS_SRC}/configure --with-base-dir ${CONDA_ENV} --prefix ${CONDA_ENV}
cd ${LOCAL_CCTOOLS_SRC}
make install
cd -

# Install Parsl manually from tphung's PR
git clone git@github.com:tphung3/parsl.git parsl
git checkout taskvine-integration
pip install ${LOCAL_PARSL}

# Run Parsl application with WQ option.
# Note that it internally uses the local provider to start workers.
conda run --prefix ${CONDA_ENV} python parsl-test.py
status=$?

exit $status
