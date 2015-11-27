//
//  VideoViewController.h
//  client_ios
//
//  Created by Admin on 23.11.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MySocket.h"
#import "MyImage.h"


@interface VideoViewController : UIViewController <NSStreamDelegate, UIAlertViewDelegate>
{dispatch_queue_t recvQueue;}

@property (nonatomic, strong) NSString* ip;
@property int port;

@property (copy, nonatomic) NSInputStream *inputStream;
@property (copy, nonatomic) NSOutputStream *outputStream;


@property MyImage* myImage;
//@property NSTimer* timer;
@property MySocket* Socket;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@property (strong, nonatomic) UIAlertView* alert;


@end
