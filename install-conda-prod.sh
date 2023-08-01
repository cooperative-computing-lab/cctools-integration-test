# Install the production version of ndcctools from conda

# Do the common setup items first.
.. ./install-common.sh

# Create and install a new environment.
conda create -y --name ${CONDA_ENV} -c conda-forge --strict-channel-priority python=3 ndcctools

# Activate the environment
conda activate ${CONDA_ENV}

