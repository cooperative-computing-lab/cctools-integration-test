#!/usr/bin/env python
import ndcctools.taskvine as vine
import json
import sys

def divide(dividend, divisor):
    import math
    return dividend/math.sqrt(divisor)

def double(x):
    return x*2

def main():
    print("Creating TaskVine manager...")
    q = vine.Manager(port=0)

    print("Creating Library from functions...")
    function_lib = q.create_library_from_functions('test-library', divide, double)
    q.install_library(function_lib)

    print("Starting worker factory for port {}...".format(q.port))
    factory = vine.Factory("local",manager_host_port="localhost:{}".format(q.port))
    factory.max_workers=1
    factory.min_workers=1
    
    with factory:
        print("Submitting tasks...")
        s_task = vine.FunctionCall('test-library', 'divide', 2, 2**2)
        q.submit(s_task)
    
        s_task = vine.FunctionCall('test-library', 'double', 3)
        q.submit(s_task)

        total_sum = 0
        x = 0

        print("Waiting for tasks to complete...")
        while not q.empty():
            t = q.wait(5)
            if t:
                x = t.output
                total_sum += x
                
    assert total_sum == divide(2, 2**2) + double(3)

if __name__ == '__main__':
    main()
