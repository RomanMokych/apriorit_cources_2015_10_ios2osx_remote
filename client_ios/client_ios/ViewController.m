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
@synthesize imageView;
@synthesize myImage = _myImage;
@synthesize timer = _timer;
@synthesize Socket = _Socket;

- (void)viewDidLoad {
    [super viewDidLoad];
    // _messages = [[NSMutableArray alloc] init];
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
    
    
    _Socket = [[MySocket alloc] initWithIp:[_ip cStringUsingEncoding:[NSString defaultCStringEncoding]] andPort:_port];
    
    [_Socket Conection];
    _myImage = [[MyImage alloc] initWithWidth:1920 andHeigth:940];
    
    //[_Socket Recv:_myImage];
 
    //imageView.image= _myImage.img;

    
    
    //while(true)
    {
   
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(update) userInfo:nil repeats:YES];

    }
    
    
    ///  отправка сообщения на сервер
    /*
     NSString *response1  = [NSString stringWithFormat:@"MESSAGE FROM CLIENT"];
     NSData *data1 = [[NSData alloc] initWithData:[response1 dataUsingEncoding:NSASCIIStringEncoding]];
     [_outputStream write:[data1 bytes] maxLength:[data1 length]];
     */
}


-(void) update{
    [_Socket Recv:_myImage];
    [imageView setImage:_myImage.img];
    //imageView.image = _myImage.img;

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
    
}



// делегат для потока получения сообщений с сервера
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            break;
            
            
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
