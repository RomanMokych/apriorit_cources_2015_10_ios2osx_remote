//
//  ViewController.m
//  client_ios
//
//  Created by Admin on 21.10.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize messages = _messages;
@synthesize ip = _ip;
@synthesize port = _port;
@synthesize MyImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    _messages = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toMyServer:(id)sender {
    self.ipField.text = @"127.0.0.1";
    self.portField.text = @"7891";
    _ip = self.ipField.text;
    _port = [self.portField.text intValue];
    
    
    MySocket *Socket = [[MySocket alloc] initWithIp:[_ip cStringUsingEncoding:[NSString defaultCStringEncoding]] andPort:_port];
    
    [Socket Conection];
     char* buf=[Socket Recv];
    
    UIImage *img = [self imageFromArray:buf width:480 height:235];
    
    [MyImage setImage:img];
    
    
    
    ///  отправка сообщения на сервер
  /*
   NSString *response1  = [NSString stringWithFormat:@"MESSAGE FROM CLIENT"];
    NSData *data1 = [[NSData alloc] initWithData:[response1 dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data1 bytes] maxLength:[data1 length]];
   */
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
 

    // метод для отображения полученного сообщения
- (void) messageReceived:(NSString *)message {
    [self.messages addObject:message];
    self.label.text = message;
}
 

-(UIImage *)imageFromArray:(unsigned char*)array width:(NSUInteger)width height:(NSUInteger)height {
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        NSLog(@"Error 2");
    }
    NSData *data = [[NSData alloc] initWithBytes:array length:sizeof(array)];
    Byte* bytes = (Byte*)data.bytes;
    CGContextRef context = CGBitmapContextCreate(bytes, width, height, 8, 4*width, colorSpace, (CGBitmapInfo)/*kCGImageAlphaPremultipliedFirst);*/kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    if (context == NULL)
    {
        NSLog(@"Error3");
        //return nil;
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    return [UIImage imageWithCGImage:imageRef];
}




      // делегат для потока получения сообщений с сервера
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        /*case NSStreamEventHasBytesAvailable:
            
            if (theStream == _inputStream) {
                
                unsigned char *buffer;
                long len;
                uint8_t tmp;
                long sz;
                
                [_inputStream read:sz maxLength:sizeof(sz)];
                //sz = atol(tmp);
                       NSLog(@"%ld",sz);
                buffer = (unsigned char*) malloc(sz*sizeof(unsigned char));//[[unsigned char alloc][sz];
                
                while ([_inputStream hasBytesAvailable])
                {
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        
                        
                        
                        
                        
                        unsigned char* output = (unsigned char*)buffer;// length:len encoding:NSASCIIStringEncoding];
                        UIImage *img = [self imageFromArray:output width:480 height:235];
                        
                        if (nil != output) {
                        
                            NSLog(@"server said: %@", output);
                            [self messageReceived:output];
                        }
                        
                        
                    }
                }
                NSLog(@"%ld",len);
            }
            break;*/
            
            
        case NSStreamEventErrorOccurred:
            
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            //[theStream release];
            theStream = nil;
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}



    // делегат для скрытия клавиатуры

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



@end
