//
//  MySocket.hpp
//  server
//
//  Created by Evgeniy on 09.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#ifndef MySocket_hpp
#define MySocket_hpp

#define DEFAULT_BUFLEN 3000

#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <iostream>


#endif /* MySocket_hpp */

class MySocket
{
private:
    int welcomeSocket, new_socket;
    struct sockaddr_in serverAddr;
    struct sockaddr_storage serverStorage;
    socklen_t addr_size;
    double *mas;
public:
    MySocket();
    ~MySocket();
    void Listening();
    void Conection();
    int Send(unsigned char*, long,int*);
    double* Recv();
    
    
    
};