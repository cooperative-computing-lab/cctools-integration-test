# Sample Parsl application uses Work Queue and TaskVine for execution.
# Work Queue is tested first and then Parsl.

import parsl
from parsl import python_app, bash_app
from parsl.executors import WorkQueueExecutor
from parsl.executors import TaskVineExecutor
import work_queue as wq
import taskvine as vine

# Create the WQ executor to send tasks to workers.
# Note that the LocalProvider is used by default to start a worker.
wq_config = parsl.config.Config(
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

# Create the WQ executor to send tasks to workers.
vine_config = parsl.config.Config(
    executors=[
        TaskVineExecutor(
            label="vine_parsl_integration_test",
            port=9124,
            project_name="vine_parsl_integration_test",
            shared_fs=False,
            full_debug = True,
        )
    ] 
)

# Test functions to be used in the MapReduce paradigm
# Map function that returns double the input integer
@python_app
def app_double(x):
    return x*2

# Reduce function that returns the sum of a list
@python_app
def app_sum(inputs=[]):
    return sum(inputs)

# Start the executor to execute functions
def run(config, exec_name):

    # Load the executor config file
    parsl.load(config)

    # Create a list of integers
    items = range(0,100)

    # Map phase: apply the double *app* function to each item in list
    mapped_results = []
    for i in items:
        x = app_double(i)
        mapped_results.append(x)

    # Reduce phase: apply the sum *app* function to the set of results
    total = app_sum(inputs=mapped_results)

    print(f'{exec_name}: {total.result()}')

if __name__ == '__main__':

    #test Work Queue
    run(wq_config, 'WorkQueue')

    #test TaskVine
    run(vine_config, 'TaskVine')




