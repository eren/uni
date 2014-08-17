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

#include <pthread.h>

#define DEBUG 0

#define PHILOSOPHER_NUM 5

#define mutex_printf(...) \
    { \
    pthread_mutex_lock(&screen); \
    printf(__VA_ARGS__); \
    pthread_mutex_unlock(&screen); \
    }

typedef struct {
    // number of the philosopher
    int number;

    // pthread structure used to create thread
    pthread_t pthread;
} philosopher_t;

void *thread_run(void *void_function_parameter);
int get_random_number();
