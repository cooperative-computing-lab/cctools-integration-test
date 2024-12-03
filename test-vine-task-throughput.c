#include "taskvine.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <time.h>
#include <assert.h>
int main(int argc, char *argv[])
{
	struct vine_manager *m;
	int i;
    int tasksC = 5000;

	m = vine_create(VINE_DEFAULT_PORT);

	if(!m) {
		printf("couldn't create manager: %s\n", strerror(errno));
		return 1;
	}
	printf("TaskVine listening on %d\n", vine_port(m));

	for(i=0;i<tasksC;i++) {
		struct vine_task *t = vine_task_create(":");
		vine_task_set_cores(t, 1);

		int task_id = vine_submit(m, t);

	}
	bool start_timer = true;
	clock_t start = 0;
	while(!vine_empty(m)) {
        struct vine_task *t  = vine_wait(m, 5);
		if (start_timer){
			start = clock();
			start_timer = false;
		}
        if(t) {
            vine_task_delete(t);
        }
    }
	clock_t end = clock();
	double throughtput_time = ((double)(end - start)) / CLOCKS_PER_SEC;

	double throughput = tasksC / throughtput_time;
	
	start_timer = true;
	start = 0;
	for(i=0;i<tasksC;i++) {
		struct vine_task *t = vine_task_create(":");
		vine_task_set_cores(t, 1);
		if (start_timer){
			start = clock();
			start_timer = false;
		}
		int task_id = vine_submit(m, t);
        while(!vine_empty(m)) {
            t  = vine_wait(m, 5);
            if(t) {
                vine_task_delete(t);
            }
        }
	}
	end = clock();
	double chaining_time = ((double)(end - start)) / CLOCKS_PER_SEC;
	double chaining = tasksC / chaining_time;

	printf("Throughput was %f tasks per second\n", throughput);
	assert(throughput > 900);

	printf("Chaining was %f tasks per second\n", chaining);
	printf("all tasks complete!\n");
	assert(chaining > 1500);
	vine_delete(m);

	return 0;
}
