#!/bin/sh

# This is a "smoke test" that trivially tests the major end-to-end components.
# makeflow, work_queue, and parrot are used to execute a single job end to end.
# Just a quick test to see if an installation has the working components.

rm -f input.txt smoke.mf smoke.mf.makeflowlog smoke.mf.wqlog output.txt wq.port

cat > input.txt << EOF
This is a smoke test.
EOF

cat > smoke.mf << EOF
output.txt : input.txt
	parrot_run cat input.txt > output.txt
EOF

makeflow -T wq -Z wq.port smoke.mf &

while [ ! -f wq.port ] 
do
	sleep 1
done

work_queue_worker --single-shot localhost `cat wq.port`

if diff input.txt output.txt
then
	echo "smoke test success"
	echo 0
else
	echo "smoke test failure"
	exit 1
fi

