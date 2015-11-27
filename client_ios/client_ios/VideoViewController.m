//
//  VideoViewController.m
//  client_ios
//
//  Created by Admin on 23.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController


@synthesize imageView;
@synthesize myImage = _myImage;
@synthesize timer = _timer;
@synthesize Socket = _Socket;

@synthesize ip=_ip;
@synthesize port=_port;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self toMyServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)toMyServer{
    
    [self initNetworkCommunicationWithIp:_ip andPort:_port];
    
    //_Socket = [[MySocket alloc] initWithIp:[_ip cStringUsingEncoding:[NSString defaultCStringEncoding]] andPort:_port];
     
     //[_Socket Conection];
     _myImage = [[MyImage alloc] initWithWidth:1920   andHeigth:940];
     
     
     //_timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(update) userInfo:nil repeats:YES];
     
     
     ///  отправка сообщения на сервер
     /*
     NSString *response1  = [NSString stringWithFormat:@"MESSAGE FROM CLIENT"];
     NSData *data1 = [[NSData alloc] initWithData:[response1 dataUsingEncoding:NSASCIIStringEncoding]];
     [_outputStream write:[data1 bytes] maxLength:[data1 length]];
     */
}


-(void) update{
    [_Socket Recv:_myImage];
    
}


- (void)initNetworkCommunicationWithIp: (NSString*)ipS andPort:(int)portS {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)ipS, portS, &readStream, &writeStream);
    _inputStream = (__bridge NSInputStream *)readStream;
    _outputStream = (__bridge NSOutputStream *)writeStream;
    
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
    
}




// делегат для потока получения сообщений с сервера


// делегат для скрытия клавиатуры
/*
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 if (textField == self.ipField) {
 
 [textField resignFirstResponder];
 
 }
 if (textField == self.portField) {
 
 [textField resignFirstResponder];
 
 }
 return YES;
 }
 */


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == _inputStream)
            {
                int *rect = (int*)malloc(sizeof(int)*4);
                [_inputStream read:(unsigned char*)rect maxLength:sizeof(int)*4];
                for (int i =0; i<4; i++)
                {
                    printf("rect[%d] %d\n",i,rect[i]);
                }
                long size;
                [_inputStream read:(unsigned char*)&size maxLength:sizeof(long)];
                printf("size  %ld\n", size);
                
                unsigned char *buffer = (unsigned char*)malloc(size);
                long len=0, tmpLen=0;
                while (tmpLen<size)
                {
                    if((len = [_inputStream read:buffer+tmpLen maxLength:size-tmpLen])!=-1){
                        tmpLen+=len;
                    }
                }
                
                [_myImage setMasImage:buffer withRect:rect];
                [imageView setImage:_myImage.img];
                free(buffer);
                free(rect);
            }
            break;
            
            
        case NSStreamEventErrorOccurred:
            
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            /*
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            printf("END\n");
            //[theStream release];
            theStream = nil;
             */
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}


@end
