//
//  VideoViewController.h
//  client_ios
//
//  Created by Admin on 23.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MyImage.h"


@interface VideoViewController : UIViewController <NSStreamDelegate, UIAlertViewDelegate>
{
    dispatch_queue_t recvQueue, sendQueue;
    
    UITouch *touch;
    CGPoint pointScr;
    CGFloat pointX;
    CGFloat pointY;
    
    double xx;
    double yy;
    
    double point[3];
    bool doubleTap;
    bool doubleTapDo;
    int doubleTapSqr;
    int doubleTapMove;
}

@property (nonatomic, strong) NSString* ip;
@property int port;

@property (copy, nonatomic) NSInputStream *inputStream;
@property (copy, nonatomic) NSOutputStream *outputStream;


@property MyImage* myImage;



@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@property (strong, nonatomic) UIAlertView* alert;
@property (strong, nonatomic) UIAlertView* alertErr;



-(IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;

-(void)closeSocket;


@end
