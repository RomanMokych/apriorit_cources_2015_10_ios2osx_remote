//
//  MySocket.cpp
//  server
//
//  Created by Evgeniy on 09.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#include "MySocket.hpp"
MySocket::MySocket()
{
    mas = new double[3];
    welcomeSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    serverAddr.sin_port = htons(7891);
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    
    memset(serverAddr.sin_zero, '\0', sizeof(serverAddr.sin_zero));
    
    bind(welcomeSocket, (struct sockaddr *) &serverAddr, sizeof(serverAddr));
}
MySocket::~MySocket(){
    close(welcomeSocket);
    close(new_socket);
    delete[] mas;
}
void MySocket::Listening()
{
    if(listen(welcomeSocket,5)==0)
        printf("Listening\n");
    else
        printf("Error\n");
    
    addr_size = sizeof serverStorage;
    new_socket = accept(welcomeSocket, (struct sockaddr *) &serverStorage, &addr_size);
    Conection();
}

void MySocket::Conection()
{
    if (welcomeSocket)
    {
        if (new_socket)
            printf("We have connection!\n");
    }
}

int MySocket::Send(unsigned char* mess, long mess_len, int* rect)
{

    if (send(new_socket, rect, sizeof(int)*4, 0) == -1)
    {
        close(welcomeSocket);
        close(new_socket);
        return -1;
        
    }
    else {
        
    send(new_socket, &mess_len, sizeof(long), 0);

    send(new_socket, (unsigned char*)mess, mess_len,0);
    }
    return 0;

}

double* MySocket::Recv()
{
    recv(new_socket, mas, sizeof(double)*3, 0);
    return mas;
}



