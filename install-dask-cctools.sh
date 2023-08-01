# Install dask and ndcctools latest version from conda

. ./install-common.sh

conda create -yq --prefix ${CONDA_ENV} -c conda-forge --strict-channel-priority ndcctools dask
conda activate ${CONDA_ENV}
