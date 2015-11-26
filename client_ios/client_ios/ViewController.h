//
//  ViewController.h
//  client_ios
//
//  Created by Admin on 21.10.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySocket.h"
#import "MyImage.h"
#import "VideoViewController.h";



@interface ViewController : UIViewController <NSStreamDelegate, UITextFieldDelegate>

@property (copy, nonatomic) NSInputStream *inputStream;
@property (copy, nonatomic) NSOutputStream *outputStream;
@property (copy, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property MyImage* myImage;
@property NSTimer* timer;
@property MySocket* Socket;


//@property (weak, nonatomic) NSString *ip;
//@property int port;

@property (weak, nonatomic) IBOutlet UITextField *ipField;
@property (weak, nonatomic) IBOutlet UITextField *portField;

- (IBAction)toMyServer:(id)sender;
- (void) initNetworkCommunicationWithIp:(NSString*)ipS andPort: (int)portS;
- (void) sendMessages;
- (void) messageReceived:(NSString*) message;


+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;


@end

