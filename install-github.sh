# Build and install ndcctools from github and activate that installation.

# Do the common setup items first.
. ./install-common.sh

PREFIX=`pwd`/cctools-install

echo =============================================
git clone https://github.com/cooperative-computing-lab/cctools github-cctools
cd github-cctools
echo =============================================
./configure --prefix $PREFIX
echo =============================================
make
echo =============================================
make install
echo =============================================
cd ..

# This gives the full path to the python directory with the version appended:
pythondir=`ls -1d $PREFIX/lib/python*`

# Activate the installation by setting PATH etc so it can be used directly.

export PATH=$PREFIX/bin:$PATH
export PYTHONPATH=${pythondir}/site-packages
export LD_LIBRARY_PATH=$PREFIX/lib

