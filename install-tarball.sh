# Install a binary from the tarball distribution into $PREFIX

# Get the common install setup
.install-common.sh

# Choose the Ubuntu distribution
TARBALL="cctools-nightly-x86_64-ubuntu20.04.tar.gz"
PREFIX=`pwd`/cctools-install

# Fetch the tarball
wget "https://github.com/cooperative-computing-lab/cctools/releases/download/nightly/${TARBALL}"

# Unpack into prefix
mkdir -p ${PREFIX}
tar -C "${PREFIX}" --strip-components=1 -xf "${TARBALL}"

# Activate the path to the tarball
export PATH=${PREFIX}/bin:${PATH}

