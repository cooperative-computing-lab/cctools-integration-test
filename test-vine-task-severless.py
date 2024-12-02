#!/usr/bin/env python
import ndcctools.taskvine as vine
import time

def func():
    return 

def main():
    print("Creating TaskVine manager...")
    q = vine.Manager()
    num_tasks = 1000
    print("Creating Library from functions...")
    function_lib = q.create_library_from_functions('test-library', func, add_env=False)
    q.install_library(function_lib)

    print("Starting worker factory for port {}...".format(q.port))
    factory = vine.Factory("local",manager_host_port="localhost:{}".format(q.port))
    factory.max_workers=1
    factory.min_workers=1
    
    with factory:
        print("Submitting tasks...")
        for i in range (num_tasks):
            t = vine.FunctionCall('test-library', 'func')
            task_id = q.submit(t)

        print("Waiting for tasks to complete...")
        start_timer = True
        while not q.empty():
            t = q.wait(5)
            if start_timer:
                start = time.time()
                start_timer = False
        end = time.time()
        many = end - start

        start = time.time()
        for i in range(num_tasks):
            while not q.empty():
                result = q.wait(5)
            t = vine.FunctionCall('test-library', 'func')
            task_id = q.submit(t)
        end = time.time()
        one = end-start
    throughput = num_tasks/many
    chaining = num_tasks/one

    print(f"Throughput was {throughput} tasks per second")
    print(f"Chaining was {chaining} tasks per second")
    print("all tasks complete!")
    assert throughput >= 110
    assert chaining >= 50

if __name__ == '__main__':
    main()
