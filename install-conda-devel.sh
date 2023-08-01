# Install and activate a conda development environment for ndcctools.

# Do the common setup items first.
. ./install-common.sh

# Create and install an environment with all of the dependencies of cctools.
conda create -yq --prefix ${CONDA_ENV} -c conda-forge --strict-channel-priority python=3 gcc_linux-64 gxx_linux-64 gdb m4 perl swig make zlib libopenssl-static openssl conda-pack cloudpickle packaging

# Activate the environment.
conda activate ${CONDA_ENV}

