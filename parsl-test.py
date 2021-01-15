# Sample Parsl application uses Work Queue for execution.

import parsl
from parsl import python_app, bash_app
from parsl.executors import WorkQueueExecutor
import work_queue as wq

# Create the WQ executor to send tasks to workers.
# Note that the LocalProvider is used by default to start a worker.

config = parsl.config.Config(
    executors=[
        WorkQueueExecutor(
            label="wq_parsl_integration_test",
            port=9123,
            project_name="wq_parsl_integration_test",
            shared_fs=False,
            full_debug = True,
        )
    ] 
)

# This is the MapReduce example verbatim from the Parsl docs:

from parsl import python_app

parsl.load(config)

# Map function that returns double the input integer
@python_app
def app_double(x):
    return x*2

# Reduce function that returns the sum of a list
@python_app
def app_sum(inputs=[]):
    return sum(inputs)

# Create a list of integers
items = range(0,100)

# Map phase: apply the double *app* function to each item in list
mapped_results = []
for i in items:
    x = app_double(i)
    mapped_results.append(x)

# Reduce phase: apply the sum *app* function to the set of results
total = app_sum(inputs=mapped_results)

print(total.result())
