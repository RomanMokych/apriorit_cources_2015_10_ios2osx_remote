#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController


@synthesize imageView;
@synthesize myImage = _myImage;
@synthesize Socket = _Socket;

@synthesize ip=_ip;
@synthesize port=_port;

@synthesize alert = _alert;
@synthesize alertErr = _alertErr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self toMyServer];
    
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.longPressGestureRecognizer.numberOfTouchesRequired = 1;
    self.longPressGestureRecognizer.allowableMovement = 100.0f;
    self.longPressGestureRecognizer.minimumPressDuration = 1.0;
    
    [self.view addGestureRecognizer:self.longPressGestureRecognizer];
    
    _alert = [[UIAlertView alloc] initWithTitle:@""
                                        message:@"Choose some action"
                                       delegate:self
                              cancelButtonTitle:@"Home"
                              otherButtonTitles:@"Exit", @"Cancel", nil];
    
    _alertErr = [[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Can not connect to the host. Try again."
                                       delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
}



- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender
{
    if ([paramSender isEqual:self.longPressGestureRecognizer])
    {
        if (paramSender.numberOfTouchesRequired == 1)
        {
            /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
             message:@"Exit?"
             delegate:self
             cancelButtonTitle:@"Ok"
             otherButtonTitles:@"Cancel", nil];*/
            [_alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [_inputStream close];
        [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        printf("END\n");
        
        _inputStream = nil;
        [_outputStream close];
        [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _outputStream = nil;
        [self performSegueWithIdentifier:@"returnToStepOne" sender:self];
    }
    if (buttonIndex == 1)
    {
        [_inputStream close];
        [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        printf("END\n");
        
        _inputStream = nil;
        [_outputStream close];
        [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _outputStream = nil;
        exit(0);
    }
    if (buttonIndex == 2)
    {
        [alertView dismissWithClickedButtonIndex:1 animated:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)toMyServer
{
    
    recvQueue = dispatch_queue_create("RECV_QUEUE", DISPATCH_QUEUE_SERIAL);
    [self initNetworkCommunicationWithIp:_ip andPort:_port];
    
    _myImage = [[MyImage alloc] initWithWidth:1920   andHeigth:940];
}


-(void) update{
    [_Socket Recv:_myImage];
}


- (void)initNetworkCommunicationWithIp: (NSString*)ipS andPort:(int)portS
{
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


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == _inputStream)
            {
                
                
                dispatch_async(recvQueue, ^(void){
                    int *rect = (int*)malloc(sizeof(int)*4);
                    [_inputStream read:(unsigned char*)rect maxLength:sizeof(int)*4];
                    for (int i =0; i<4; i++)
                    {
                        printf("rect[%d] %d\n",i,rect[i]);
                    }
                    long size;
                    [_inputStream read:(unsigned char*)&size maxLength:sizeof(long)];
                    printf("size  %ld\n", size);
                    
                    
                    //НЕ УДАЛЯТЬ(КОММЕНТИРОВАТЬ), НУЖНО ДЛЯ РАБОТЫ НА КОМПЬЮТЕРЕ ЖЕНИ!
                    ////////
                    /*int k;
                    [_inputStream read:&k maxLength:4];*/
                    ////////
                    
                    
                    unsigned char *buffer = (unsigned char*)malloc(size);
                    long len=0;
                    long tmpLen=0;
                    while (tmpLen<size)
                    {
                        if((len = [_inputStream read:buffer+tmpLen maxLength:size-tmpLen])!=-1){
                            tmpLen+=len;
                        }
                    }
                                        [_myImage setMasImage:buffer withRect:rect];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [imageView setImage:_myImage.img];
                    });
                    free(buffer);
                    free(rect);
                });
            }
            break;
            
        case NSStreamEventErrorOccurred:
            
            NSLog(@"Can not connect to the host!");
            [_alertErr show];
            break;
            
        case NSStreamEventEndEncountered:
            
             [theStream close];
             [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
             printf("END\n");
             //[theStream release];
             theStream = nil;
             
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}

@end
