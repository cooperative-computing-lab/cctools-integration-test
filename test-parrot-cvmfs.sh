#!/bin/sh

. ./install-tarball.sh

if parrot_run true
then
	if parrot_run --check-driver cvmfs
	then
		echo "Parrot CVMFS driver is present."
		if parrot_run -- stat /cvmfs/cms.cern.ch/releases.map
		then
			echo "Successfully accessed CMVFS!"
			exit 0
		else
			echo "Could not access CVMFS!"
			exit 1
		fi
	echo
		echo "CVMFS driver is not enabled in Parrto!"
		exit 1
	fi
else
	echo "Parrot could not run /bin/true!"
	exit 1
fi
