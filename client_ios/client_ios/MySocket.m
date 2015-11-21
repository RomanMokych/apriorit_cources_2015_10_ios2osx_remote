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
@synthesize width = _width;
@synthesize height = _height;

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

-(void)Recv:(MyImage*)img;
{
    long tmpSize;
    
    long result=0;
    
    int *rect = (int*)malloc(sizeof(int)*4);
    int tmp;
    recv(_welcome_socket, rect, sizeof(int)*4, 0);
    
    
    recv(_welcome_socket, &tmpSize, sizeof(long), 0);
    
    
    
    recv(_welcome_socket, &tmp, 4, 0);
    unsigned char *buffer = (unsigned char*)malloc(tmpSize);

    long DEFAULT_BUFLEN=512;
    long chunk_count = tmpSize/ DEFAULT_BUFLEN;
    long last_chunk_size = tmpSize-(chunk_count*DEFAULT_BUFLEN);
    long file_off_set = 0;
    
    
    while (chunk_count>0)
    {
        recv(_welcome_socket, (unsigned char*)(buffer+(file_off_set*DEFAULT_BUFLEN)), DEFAULT_BUFLEN, 0);
        file_off_set++;
        chunk_count--;
    }
    send(_welcome_socket, buffer+(file_off_set*DEFAULT_BUFLEN), last_chunk_size, 0);
    
    for (int i=0; i<4; i++) {
        printf("rect[%d] %d\n", i,rect[i]);
    }
    
    for (int i =0; i<result; i++)
    {
        printf("%d %c\n",i,buffer[i]);
    }
    
    [img setMasImage:buffer withRect:rect];
    
    
    
    
}

@end
