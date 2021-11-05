# shadho sends a small module along with every worker that can wrap the
# objective function. Start by importing this module.
import shadho_worker

# shadho_run_task automatically loads hyperparameter values and saves
# the resulting output in a format that shadho knows to look for. All
# you have to do is write a function that takes the parameters as
# an argument.

import math

# The objective function is defined here (same code as in ex1)
def opt(params):
	return math.sin(params['x'])

if __name__ == '__main__':
	# To run the worker, just pass the objective function to shadho_worker.run
	shadho_worker.run(opt)
