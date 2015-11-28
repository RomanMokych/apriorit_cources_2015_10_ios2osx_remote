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
    /*---- Create the socket. The three arguments are: ----*/
    /* 1) Internet domain 2) Stream socket 3) Default protocol (TCP in this case) */
    welcomeSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    /*---- Configure settings of the server address struct ----*/
    /* Address family = Internet */
    //serverAddr.sin_family = AF_INET;
    /* Set port number, using htons function to use proper byte order */
    serverAddr.sin_port = htons(7891);
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    
    /* Set all bits of the padding field to 0 */
    memset(serverAddr.sin_zero, '\0', sizeof(serverAddr.sin_zero));
    
    /*---- Bind the address struct to the socket ----*/
    bind(welcomeSocket, (struct sockaddr *) &serverAddr, sizeof(serverAddr));
}
MySocket::~MySocket(){
    close(welcomeSocket);
    close(new_socket);
}
void MySocket::Listening()
{
    /*---- Listen on the socket, with 5 max connection requests queued ----*/
    if(listen(welcomeSocket,5)==0)
        printf("Listening\n");
    else
        printf("Error\n");
    
    
    /*---- Accept call creates a new socket for the incoming connection ----*/
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







