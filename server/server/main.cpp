#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <iostream>
#include <semaphore.h>
#include <CoreGraphics/CoreGraphics.h>
#include <OpenGL/OpenGL.h>
#include <GLUT/glut.h>
#include <fcntl.h>


#include "MyScreenStream.hpp"
//#include "MySocket.hpp"


int main(){
    
    MyScreenStream *MSS = new MyScreenStream();
    MSS->StartScreenStream();
    
    usleep(5000000000000);
    
    printf("Done!\n");
    
    
    
    //for(;;);
    return 0;
}