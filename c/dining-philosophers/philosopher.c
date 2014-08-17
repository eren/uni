/*
Copyright (C) 2013  Eren Türkay <turkay.eren@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include "philosopher.h"

/* philosopher threads */
philosopher_t philosophers[PHILOSOPHER_NUM];

/* chopstick locks */
pthread_mutex_t chopsticks[PHILOSOPHER_NUM];

/* only one philosopher at a time can write to the screen */
pthread_mutex_t screen;

int get_random_number()
{
    /* seed random number generator */
    srand(time(NULL));

    return (1 + (rand() % 7));
}

/* 
 * Try to grab both of the chopsticks in the left and right to avoid
 * deadlock.
 *
 * If both of them available, lock them and return 0. If either
 * one of them is not available, return -1.
 */
int grab_chopsticks(philosopher_t *philosopher)
{
#if DEBUG
    mutex_printf("[%d] trying to grab chopsticks\n", philosopher->number);
#endif

    int left_chopstick = philosopher->number;
    int right_chopstick = (philosopher->number + 1) % PHILOSOPHER_NUM;

    /* try to lock right chopstick first */
    if (pthread_mutex_trylock(&chopsticks[right_chopstick]) == 0) {
        /* we got the right chopstick, now try left */
        if (pthread_mutex_trylock(&chopsticks[left_chopstick]) == 0) {
            /* ok, we now have both sticks */
            return 0;
        } else {
            /* left chopstick is in use, but we got the right
             * chopstick, drop it.
             */
            pthread_mutex_unlock(&chopsticks[right_chopstick]);
            return -1;
        }
    } else {
        /* we failed to lock right chopstick in the first place */
        return -1;
    }
}

void drop_chopsticks(philosopher_t *philosopher)
{
#if DEBUG
    mutex_printf("[%d] dropping chopsticks\n", philosopher->number);
#endif

    int left_chopstick = philosopher->number;
    int right_chopstick = (philosopher->number + 1) % PHILOSOPHER_NUM;

    pthread_mutex_unlock(&chopsticks[right_chopstick]);
    pthread_mutex_unlock(&chopsticks[left_chopstick]);
}


/* Entry function when a thread is created */
void *thread_run(void *void_function_parameter)
{
    philosopher_t *philosopher = (philosopher_t *)void_function_parameter;

#if DEBUG
    mutex_printf("Philosopher %d initialized\n", philosopher->number);
#endif

    do {
        mutex_printf("[%d] is thinking...\n", philosopher->number);
        sleep(get_random_number());
        mutex_printf("[%d] is hungry, trying to grab sticks\n", philosopher->number);

        if (grab_chopsticks(philosopher) == 0) {
            mutex_printf("[%d] is eating..\n", philosopher->number);

            sleep(get_random_number());
            drop_chopsticks(philosopher);

            mutex_printf("[%d] has done eating!\n", philosopher->number);
        } else {
#if DEBUG
            mutex_printf("[%d] grab filed!\n", philosopher->number);
#endif
        }
    } while (1);
}

int main(int argc, const char *argv[])
{
    /* initialize screen */
    if (pthread_mutex_init(&screen, NULL) == -1) {
        fprintf(stderr, "Screen mutex init failed!\n");
        
        return -1;
    }

    int i;
    for (i = 0; i < PHILOSOPHER_NUM; i++) {
        if (pthread_mutex_init(&chopsticks[i], NULL) == -1) {
            fprintf(stderr, "Chopstick mutex init failed!\n");

            return -1;
        }
    }

    /* initalize data structures and threads */
    for (i = 0; i < PHILOSOPHER_NUM; i++) {
        philosophers[i].number = i;

        if (pthread_create(&philosophers[i].pthread, NULL, thread_run, &philosophers[i])) {
            fprintf(stderr, "Thread creation failed!\n");

            return -1;
        }
    }

    mutex_printf("Main program finished creating threads!\n");

    while (1)
        ;

    return 0;
}
