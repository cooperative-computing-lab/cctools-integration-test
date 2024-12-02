#!/usr/bin/env python

import ndcctools.taskvine as vine
import time

if __name__ == "__main__":

    q = vine.Manager()
    print("listening on port", q.port)
    factory = vine.Factory("local",manager_host_port="localhost:{}".format(q.port))
    factory.max_workers=1
    factory.min_workers=1
    factory.disk = 100

    num_tasks = 1000

    with factory:
        for i in range(num_tasks):
            t = vine.Task(command=":")
            task_id = q.submit(t)

        print("waiting for tasks to complete...")
        
        start_timer = True
        while not q.empty():

            t = q.wait(5)
            if start_timer:
                start = time.time()
                start_timer = False
    
    end = time.time()
    many = end - start

    start = time.time()
    with factory:
        for i in range(num_tasks):
            while not q.empty():
                result = q.wait(5)
            t = vine.Task(command=":")
            task_id = q.submit(t)

        print("waiting for tasks to complete...")
    end = time.time()
    one = end - start
    throughput = num_tasks/many
    chaining = num_tasks/one
    print(f"Throughput was {throughput} tasks per second")
    print(f"Chaining was {chaining} tasks per second")
    print("all tasks complete!")
    assert throughput >= 190
    assert chaining >= 155
    
# vim: set sts=4 sw=4 ts=4 expandtab ft=python:

