# Test the integration of Dask with TaskVine as an executor.
# Just generate a quick handful of functions, each one of
# them executed as a single TaskVine task.  Not efficient,
# but sufficient to see if things are working.

import ndcctools.taskvine as vine
import dask.delayed

@dask.delayed(pure=True)
def sum_d(args):
        return sum(args)

@dask.delayed(pure=True)
def add_d(a,b):
    return a+b

@dask.delayed(pure=True)
def list_d(*args):
    return list(args)

z = add_d(1,2)
w = sum_d([1,2,z])
v = list_d(sum_d([z,w]),2)
t = sum_d(v)

# Create a new manager listening on port 9123
manager = vine.DaskVine(9123)

# Create a factory to run a single worker locally.
factory = vine.Factory(manager=manager)
factory.cores = 4
factory.min_workers = 1
factory.max_workers = 1

# Then run the dag within the factory.
with factory:
    print(t.compute(scheduler=manager.get))
