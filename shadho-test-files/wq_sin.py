"""This script runs the hyperparameter search on remote workers.
"""

# These are imported, same as before
from shadho import Shadho, spaces

import math


# The space is also defined exactly the same.
space = {
	'x': spaces.uniform(0.0, 2.0 * math.pi)
	}


if __name__ == '__main__':
	# This time, instead of configuring shadho to run locally,
	# we direct it to the input files that run the optimization task.

	# Instead of the objective function, shadho is given a command that gets
	# run on the remote worker.
	opt = Shadho('sin_ex', 'bash run_sin.sh', space, timeout=60)

	# Two input files are also added: the first is run directly by the worker
	# and can be used to set up your runtime environment (module load, anyone?)
	# The second is the script we're trying to optimize.
	opt.add_input_file('run_sin.sh')
	opt.add_input_file('sin.py')
	opt.run()
