#include "taskvine.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <time.h>

int main(int argc, char *argv[])
{
	struct vine_manager *m;
	int i;
    int tasksC = 5000;

	//Create the manager. All tasks and files will be declared with respect to
	//this manager.
	m = vine_create(VINE_DEFAULT_PORT);
	if(!m) {
		printf("couldn't create manager: %s\n", strerror(errno));
		return 1;
	}
	printf("TaskVine listening on %d\n", vine_port(m));

	printf("Declaring tasks...");
	bool start_timer = true
	for(i=0;i<tasksC;i++) {
		struct vine_task *t = vine_task_create(":");
		vine_task_set_cores(t, 1);

		int task_id = vine_submit(m, t);
        while(!vine_empty(m)) {
			if (start_timer):
				clock_t start = clock();
            t  = vine_wait(m, 5);
            if(t) {
                vine_task_delete(t);
            }
        }
	}
	clock_t end = clock();
	double time = ((double)(end - start)) / CLOCKS_PER_SEC;
	double throughput = tasksC / time;
	printf("all tasks complete!\n");
	printf("Time was %f seconds\n", time);
	printf("Throughput was %f tasks per second\n", throughput);

	//Free the manager structure, and release all the workers.
	vine_delete(m);

	return 0;
}
