# Sample Parsl application uses Work Queue for execution.

import parsl
from parsl import python_app, bash_app
from parsl.executors import WorkQueueExecutor
import work_queue as wq

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
    parsl.clear()
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

    print("Executing Workflow")
    value = total.result()
    expected = 9900
    
    if value==expected:
            print(f("Got expected value of {value}"))
            sys.exit(0)
    else:
            print(f("Got incorrect value of {value}!"))
            sys.exit(1)

if __name__ == '__main__':

    #test Work Queue
    run(wq_config, 'WorkQueue')
