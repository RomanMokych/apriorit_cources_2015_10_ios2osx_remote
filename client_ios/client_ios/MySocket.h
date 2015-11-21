//
//  MySocket.h
//  client_ios
//
//  Created by Evgeniy on 12.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/types.h>
#include <arpa/inet.h>
#import "MyImage.h"

@interface MySocket : NSObject

@property int welcome_socket;
@property struct sockaddr_in server_addr;
@property struct sockaddr_storage server_storage;
@property socklen_t addr_size;
@property int width, height;

-(void)Listening;
-(void)Conection;
-(void)Recv:(MyImage*)img;
-(id)initWithIp:(const char*)ip andPort:(int)port;


@end
