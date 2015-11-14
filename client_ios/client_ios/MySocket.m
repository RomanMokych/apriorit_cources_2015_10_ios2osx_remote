//
//  MySocket.m
//  client_ios
//
//  Created by Evgeniy on 12.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "MySocket.h"

@implementation MySocket

@synthesize welcome_socket=_welcome_socket;
@synthesize  server_addr=_server_addr;
@synthesize server_storage=_server_storage;
@synthesize addr_size=_addr_size;

-(id)initWithIp:(const char*)ip andPort:(int)port
{
    if (self=[super init])
    {
        _welcome_socket = socket(PF_INET, SOCK_STREAM, 0);
        
        /*---- Configure settings of the server address struct ----*/
        /* Address family = Internet */
        _server_addr.sin_family = AF_INET;
        /* Set port number, using htons function to use proper byte order */
        _server_addr.sin_port = htons(port);
        /* Set IP address to localhost */
        _server_addr.sin_addr.s_addr = inet_addr(ip);
        memset(_server_addr.sin_zero, '\0', sizeof _server_addr.sin_zero);

    }
    return self;
}
-(void)Listening
{
    
}
-(void)dealloc
{
    close(_welcome_socket);
}

-(void)Conection
{
    /*---- Connect the socket to the server using the address struct ----*/
    _addr_size = sizeof _server_addr;
    if(connect(_welcome_socket, (struct sockaddr *)&_server_addr, _addr_size) < 0)
    {
        printf("\n Error : Connect Failed \n");
        exit(100);
    }
    else
        NSLog(@"Conection");
    
}

-( char*)Recv
{
    long size;
    recv(_welcome_socket, &size, sizeof(size), 0);
    
    int iResult;
    long tmp;
    long receiveBuffer = 0;
    long desireRecBuffer = 512;//size;
    unsigned char *buffer = (char*)malloc(size*sizeof(*buffer));
    //unsigned char buffer[size];
    
    
    
    
    int DEFAULT_BUFLEN=512;
    
    
    long chunk_count = size/ DEFAULT_BUFLEN;
    long last_chunk_size = size-(chunk_count*DEFAULT_BUFLEN);
    long file_off_set = 0;
    recv(_welcome_socket, &tmp, 4, 0);
    while (chunk_count>0)
    {
        iResult = recv(_welcome_socket, (unsigned char*)(buffer + (file_off_set*DEFAULT_BUFLEN)), DEFAULT_BUFLEN, 0);
        //iResult = read(_welcome_socket, buffer+(file_off_set*DEFAULT_BUFLEN), DEFAULT_BUFLEN);
        file_off_set++;
        chunk_count--;
    }
    recv(_welcome_socket, buffer + (file_off_set*DEFAULT_BUFLEN), last_chunk_size, 0);
    
    
     
     
     /*
    recv(_welcome_socket, &tmp, 4, 0);
    while (desireRecBuffer > 0)
    {
        //iResult = recv(_welcome_socket, buffer + receiveBuffer, desireRecBuffer, 0);
        iResult = read(_welcome_socket, buffer+receiveBuffer, desireRecBuffer);
        if (iResult < 1)
            break;
        else
        {
            receiveBuffer += iResult;
            desireRecBuffer = size - receiveBuffer;
        }
    }
    */
    
    for (int i =0; i<size; i++)
    {
        printf("%d %c\n",i,buffer[i]);
        //NSLog(@"%d %c\n",i,buffer[i]);
    }
    
    return buffer;
}

@end
