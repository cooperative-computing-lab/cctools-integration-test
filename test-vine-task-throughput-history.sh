#!/bin/sh

# Repository URL and directory setup
REPO_URL="https://github.com/cooperative-computing-lab/cctools"
REPO_DIR="github-cctools"

. ./install-common.sh

# Log file for results
LOG_FILE="./test_results.log"
printf "%-40s %-20s %-20s %-25s %-25s %-20s %-20s\n" \
    "Version" "Python Throughput" "Python Chaining" \
    "Serverless Throughput" "Serverless Chaining" \
    "C Throughput" "C Chaining" > $LOG_FILE

# Clone the repository
git clone "$REPO_URL" "$REPO_DIR"

# Navigate to the repository
cd $REPO_DIR

# COMMITS=($(git log -n 1000 --format="%H" | awk 'NR % 10 == 1'))

COMMITS=($(git log --format="%H" | awk 'NR % 10 == 1'))

if [ ${#COMMITS[@]} -eq 0 ]; then
    echo "Error: No commits found or repository history is empty."
    exit 1
fi

echo "Selected commits:"
printf "%s\n" "${COMMITS[@]}"

# Activate the conda environment
conda activate cctools-dev

PREFIX=$CONDA_PREFIX

# Function to sanitize and format results
sanitize_and_format() {
    echo "$1" | grep -Eo "^[0-9.]+$" | head -n 1
}

# Iterate through each commit
for COMMIT in "${COMMITS[@]}"; do
    

    echo "Testing commit: $COMMIT"
    git checkout -b temp_branch_$COMMIT $COMMIT
    


    # Build TaskVine
    ./configure --prefix="$PREFIX" --with-base-dir="$PREFIX"
    make clean && make install -j8

    # Set environment variables
    export PATH="$PREFIX/bin:$PATH"
    export PYTHONPATH="${PREFIX}/lib/python3.*/site-packages"
    export LD_LIBRARY_PATH="$PREFIX/lib"
    cd ..

    # Run the Python test
    echo "Running Python test..."
    PYTHON_OUTPUT=$(python3 test-vine-task-throughput.py)
    PYTHON_THROUGHPUT_RESULT=$(sanitize_and_format "$(echo "$PYTHON_OUTPUT" | grep -Eo "Throughput was [0-9.]+ tasks per second" | grep -Eo "[0-9.]+")")
    PYTHON_CHAINING_RESULT=$(sanitize_and_format "$(echo "$PYTHON_OUTPUT" | grep -Eo "Chaining was [0-9.]+ tasks per second" | grep -Eo "[0-9.]+")")
    SERVERLESS_THROUGHPUT_RESULT=$(sanitize_and_format "$(echo "$PYTHON_OUTPUT" | grep -Eo "Serverless Throughput was [0-9.]+ tasks per second" | grep -Eo "[0-9.]+")")
    SERVERLESS_CHAINING_RESULT=$(sanitize_and_format "$(echo "$PYTHON_OUTPUT" | grep -Eo "Serverless Chaining was [0-9.]+ tasks per second" | grep -Eo "[0-9.]+")")

    # Compile and run the C test
    echo "Compiling and running C test..."
    ${CC:-gcc} test-vine-task-throughput.c -o test-vine-task-throughput -I "$PREFIX/include/cctools/" -L "$PREFIX/lib" -ltaskvine -ldttools -lm -lcrypto -lssl -lz
    ./test-vine-task-throughput > c_output.log 2>&1 &

    # Run the worker command immediately
    vine_worker localhost 9123 --single-shot

    # Wait for the background process to complete
    wait

    # Capture the output from the file
    C_OUTPUT=$(cat c_output.log)
    C_THROUGHPUT_RESULT=$(sanitize_and_format "$(echo "$C_OUTPUT" | grep -Eo "Throughput was [0-9.]+ tasks per second" | grep -Eo "[0-9.]+")")
    C_CHAINING_RESULT=$(sanitize_and_format "$(echo "$C_OUTPUT" | grep -Eo "Chaining was [0-9.]+ tasks per second" | grep -Eo "[0-9.]+")")

    # Append results to the log
    printf "%-40s %-20s %-20s %-25s %-25s %-20s %-20s\n" \
        "$COMMIT" "$PYTHON_THROUGHPUT_RESULT" "$PYTHON_CHAINING_RESULT" \
        "$SERVERLESS_THROUGHPUT_RESULT" "$SERVERLESS_CHAINING_RESULT" \
        "$C_THROUGHPUT_RESULT" "$C_CHAINING_RESULT" >> $LOG_FILE
    cd $REPO_DIR
    git branch -D temp_branch_$COMMIT || echo "Branch temp_branch_$COMMIT already deleted or not found"
done

# Display the test results
echo "Testing complete. Results saved to $LOG_FILE."
cat $LOG_FILE
