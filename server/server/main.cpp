#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <iostream>
#include <semaphore.h>

#include "MyScreenStream.hpp"



int main(){
sem_t *sem = sem_open("/my_sem", O_CREAT, 0644, 1);
    MyScreenStream *MSS = new MyScreenStream();
    MSS->StartScreenStream();
    sem_wait(sem);
    //for(;;);
    return 0;
}