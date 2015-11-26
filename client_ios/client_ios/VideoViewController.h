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


@interface VideoViewController : UIViewController


@property (nonatomic, strong) NSString* ip;
@property int port;


@property MyImage* myImage;
@property NSTimer* timer;
@property MySocket* Socket;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
