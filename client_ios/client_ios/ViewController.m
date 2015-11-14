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
   // _messages = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) ConvertBetweenBGRAandRGBA:(unsigned char*)input width: (int)pixel_width height:
                               (int) pixel_height
{
    unsigned char tmp;
    int offset=0;
    for (int y = 0; y < pixel_height; y++) {
        for (int x = 0; x < pixel_width; x++) {
            tmp = input[offset];
            input[offset] = input[offset+2];
            input[offset+2]=tmp;
            offset += 4;
        }
    }
}




-(UIImage *) imageFromTexturePixels:(unsigned char*)rawImageData width:(int)width height:(int)height
{
    [self ConvertBetweenBGRAandRGBA:rawImageData width:width height:height];
    UIImage *newImage = nil;
    int nrOfColorComponents = 4; //RGBA
    int bitsPerColorComponent = 8;
    int rawImageDataLength = width * height * nrOfColorComponents;
    BOOL interpolateAndSmoothPixels = NO;
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;//kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGDataProviderRef dataProviderRef;
    CGColorSpaceRef colorSpaceRef;
    CGImageRef imageRef;
    
    @try
    {
        GLubyte *rawImageDataBuffer = rawImageData;
        
        dataProviderRef = CGDataProviderCreateWithData(NULL, rawImageDataBuffer, rawImageDataLength, nil);
        colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        imageRef = CGImageCreate(width, height, bitsPerColorComponent, bitsPerColorComponent * nrOfColorComponents, width * nrOfColorComponents, colorSpaceRef, bitmapInfo, dataProviderRef, NULL, interpolateAndSmoothPixels, renderingIntent);
        newImage = [[UIImage alloc] initWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
    }
    @finally
    {
        CGDataProviderRelease(dataProviderRef);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
    }
    
    return newImage;
}
- (IBAction)toMyServer:(id)sender {
    self.ipField.text = @"127.0.0.1";
    self.portField.text = @"7891";
    _ip = self.ipField.text;
    _port = [self.portField.text intValue];
    
    
    MySocket *Socket = [[MySocket alloc] initWithIp:[_ip cStringUsingEncoding:[NSString defaultCStringEncoding]] andPort:_port];
    
    [Socket Conection];
    //for(;;)
    {
        unsigned char* buf=[Socket Recv];
        UIImage *img = [self imageFromTexturePixels:buf width:1920/*Socket.width*/ height:940/*Socket.height*/];
        [MyImage setImage:img];
    }
    
    
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
