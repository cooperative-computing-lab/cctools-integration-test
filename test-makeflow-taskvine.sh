#!/bin/sh

# This is a "smoke test" that trivially tests the major end-to-end components.
# makeflow and taskvine to execute a single job end to end.
# Just a quick test to see if an installation has the working components.

rm -f input.txt smoke.mf smoke.mf.makeflowlog smoke.mf.taskvinelog output.txt taskvine.port

cat > input.txt << EOF
This is a smoke test.
EOF

cat > smoke.mf << EOF
output.txt : input.txt
	cat input.txt > output.txt
EOF

makeflow -T taskvine -Z taskvine.port smoke.mf &

for count in 1 2 3 4 5
do
	if [ -f taskvine.port ]
	then
		echo "waiting for port file..."
		break
	fi
	sleep 1
done

if [ ! -f taskvine.port ]
then
	echo "error: makeflow didn't create taskvine.port file"
	exit 1
fi

vine_worker --single-shot localhost `cat taskvine.port`

if diff input.txt output.txt
then
	echo "smoke test success"
	echo 0
else
	echo "smoke test failure"
	exit 1
fi

