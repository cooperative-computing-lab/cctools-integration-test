# Install the production version of parsl and ndcctools together.

source ./install-common.sh

# Get latest ndcctools and parsl all in one go.
conda create -yq --prefix cctools-test -c conda-forge --strict-channel-priority python=3 ndcctools parsl
conda activate cctools-test
