
#!/bin/sh

# Build the sources from github
. ./install-github.sh

# Compile C API test using environment 
gcc test-vine-task-throughput.c -o test-vine-task-throughput -I $PREFIX/include/cctools/ -L $PREFIX/lib -ltaskvine -ldttools -lm -lcrypto -lssl -lz

./test-vine-task-throughput & 

vine_worker localhost 9123 --single-shot