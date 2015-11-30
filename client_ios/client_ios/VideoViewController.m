#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController


@synthesize imageView;
@synthesize myImage = _myImage;


@synthesize ip=_ip;
@synthesize port=_port;

@synthesize alert = _alert;
@synthesize alertErr = _alertErr;
//@synthesize tapGesture = _tapGesture;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self toMyServer];
    
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
    
    
   // _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
   // _tapGesture.numberOfTapsRequired = 2;
  //  [self.view addGestureRecognizer:_tapGesture];
    //[tapGesture release];
    
    doubleTap = false;
    doubleTapDo = false;
    doubleTapSqr = 0;
    doubleTapMove = 0;
}

/*- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"double tap\n");
        doubleTap = true;
        
        if (_tapGesture.state == UIGestureRecognizerStateEnded)
        {
            doubleTapDo = true;
            NSLog(@"end double taaaaaaaaaaaap\n\n");
            
            
            if (doubleTapDo)
            {
                NSLog(@"gggggggggggggggggggg\n");
        
                doubleTapDo = false;
            }
            
            //
            //doubleTapSqr++;

        }
    }
}*/


-(IBAction) handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.scale = 1.0;
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1.0;
    [_alert show];
}



/*- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender
 {
 paramSender.minimumPressDuration = 2.0;
 if ([paramSender isEqual:self.longPressGestureRecognizer])
 {
 if (paramSender.numberOfTouchesRequired == 2)
 {
 
 //[_alert show];
 }
 }
 }*/

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [self closeSocket];
        [self performSegueWithIdentifier:@"returnToStepOne" sender:self];
    }
    if (buttonIndex == 1)
    {
        [self closeSocket];
        exit(0);
    }
    if (buttonIndex == 2)
    {
        [alertView dismissWithClickedButtonIndex:1 animated:NO];
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    touch = [touches anyObject];
    pointScr = [touch locationInView:self.view];
    pointX = pointScr.x;
    pointY = pointScr.y;
    
    NSLog(@"x: %f  y: %f\n", pointX, pointY);
    /*if (doubleTap)
    {
        point[0] = 4;
        point[1] = pointX;
        point[2] = pointY;
        
        [_outputStream write:(unsigned char*)point maxLength:sizeof(double)*3];
        doubleTap = false;
        doubleTapDo = false;
    }
    else
    {*/
        point[0] = 1;
        point[1] = pointX;
        point[2] = pointY;
        [_outputStream write:(unsigned char*)point maxLength:sizeof(double)*3];
    //}
    
    doubleTapSqr++;
    doubleTapMove++;
    if (doubleTapSqr == 1 || doubleTapMove == 1)
    {
        xx  = pointX;
        yy = pointY;
        //doubleTapSqr++;
    }
    
    if (doubleTapSqr == 2 || doubleTapMove == 2)
    {
        if (((pointX <= (xx+15))&& (pointX >= (xx-15))) && ((pointY <= (yy + 15)) && (pointY >= (yy - 15))) )
        {
            doubleTapSqr++;
            doubleTapMove++;
        }
        else
        {
            doubleTapSqr = 0;
            doubleTapMove = 0;
        }
    }
   

    
}
- (void) touchesMoved:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    touch = [touches anyObject];
    pointScr = [touch locationInView:self.view];
    pointX = pointScr.x;
    pointY = pointScr.y;
    
    printf("move   x: %f  y: %f\n", pointX, pointY);
    
    
    
    if (doubleTapMove == 3)
    {
        point[0] = 4;
        point[1] = pointX;
        point[2] = pointY;
        
        [_outputStream write:(unsigned char*)point maxLength:sizeof(double)*3];
        doubleTapMove = 0;
        doubleTapSqr=0;
        printf("douubletap and move\n");
    }
    point[0] = 2;
    point[1] = pointX;
    point[2] = pointY;
    
    [_outputStream write:(unsigned char*)point maxLength:sizeof(double)*3];
    
    
}
- (void) touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    touch = [touches anyObject];
    pointScr = [touch locationInView:self.view];
    pointX = pointScr.x;
    pointY = pointScr.y;
    
    
    
    NSLog(@"end   x: %f  y: %f\n", pointX, pointY);
    if (doubleTapSqr == 3)
    {
        point[0] = 5;
        point[1] = pointX;
        point[2] = pointY;
        [_outputStream write:(unsigned char*)point maxLength:sizeof(double)*3];
        doubleTapSqr = 0;
        
    }
    else
    {
        point[0] = 3;
        point[1] = pointX;
        point[2] = pointY;
        [_outputStream write:(unsigned char*)point maxLength:sizeof(double)*3];
        
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


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {
    
    __block NSStream *theStream = stream;
    //NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    switch (streamEvent)
    {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == _inputStream)
            {
                
                dispatch_async(recvQueue,
                               ^(void)                                                  {
                                   int *rect = (int*)malloc(sizeof(int)*4);
                                   [_inputStream read:(unsigned char*)rect maxLength:sizeof(int)*4];
                                   /*for (int i =0; i<4; i++)
                                    {
                                    printf("rect[%d] %d\n",i,rect[i]);
                                    }*/
                                   long size;
                                   [_inputStream read:(unsigned char*)&size maxLength:sizeof(long)];
                                   //printf("size  %ld\n", size);
                                   
                                   
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
                                       if((len = [_inputStream read:buffer+tmpLen maxLength:size-tmpLen])!=-1)
                                       {
                                           tmpLen+=len;
                                       }
                                   }
                                   [_myImage setMasImage:buffer withRect:rect];
                                   dispatch_async(dispatch_get_main_queue(), ^(void)
                                                  {
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
            theStream = nil;
            [_alertErr show];
            break;
        default:
            NSLog(@" ");
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self closeSocket];
}

-(void)closeSocket
{
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    printf("ENDclose\n");
    _inputStream = nil;
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _outputStream = nil;
}

@end
