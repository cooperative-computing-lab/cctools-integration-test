# Install and activate a conda development environment for ndcctools.

# Do the common setup items first.
. ./install-common.sh

# Pull the environment out of the repo first:
curl https://raw.githubusercontent.com/cooperative-computing-lab/cctools/master/environment.yml > environment.yml

# Create and install an environment with all of the dependencies of cctools.
conda create -yq --prefix ${CONDA_ENV} --file environment.yml --experimental-solver=libmamba

# Activate the environment.
conda activate ${CONDA_ENV}

