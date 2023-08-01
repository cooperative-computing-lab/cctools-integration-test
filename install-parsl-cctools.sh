# Install the production version of parsl and ndcctools together.

. ./install-common.sh

# Get latest ndcctools and parsl all in one go.
conda create -yq --prefix ${CONDA_ENV} -c conda-forge --strict-channel-priority python=3 ndcctools parsl
conda activate ${CONDA_ENV}
