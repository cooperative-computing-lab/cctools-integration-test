# Sample Parsl application uses TaskVine for execution.

import parsl
from parsl import python_app, bash_app
from parsl.executors.taskvine import TaskVineExecutor
from parsl.executors.taskvine import TaskVineManagerConfig
from parsl.executors.taskvine import TaskVineFactoryConfig
import sys

# Create the TaskVine executor to send tasks to workers.
vine_config = parsl.config.Config(
    executors=[
        TaskVineExecutor(
            label="vine_parsl_integration_test",
            factory_config=TaskVineFactoryConfig(
                batch_type="local",
                min_workers=1,
                max_workers=1),
            manager_config=TaskVineManagerConfig(
                port=9124,
                project_name='vine_parsl_integration_test')
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

    print("Initializaing Parsl")
    # Load the executor config file
    parsl.clear()
    with parsl.load(config=config) as dfk:
        assert isinstance(dfk, DataFlowKernel)
        
        print("Creating Workflow")
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
                print(f"Got expected value of {value}")
                sys.exit(0)
        else:
                print(f"Got incorrect value of {value}!")
                sys.exit(1)

if __name__ == '__main__':

    #test TaskVine
    run(vine_config, 'TaskVine')
