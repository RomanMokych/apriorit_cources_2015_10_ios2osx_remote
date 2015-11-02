//
//  ViewController.h
//  client_ios
//
//  Created by Admin on 21.10.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <NSStreamDelegate, UITextFieldDelegate>




@property (copy, nonatomic) NSInputStream *inputStream;
@property (copy, nonatomic) NSOutputStream *outputStream;
@property (copy, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITextField *textF;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextField *ipField;
@property (weak, nonatomic) IBOutlet UITextField *portField;

@property (copy, nonatomic) NSString *ip;
@property int port;

- (IBAction)toMyServer:(id)sender;
- (void) initNetworkCommunication:(NSString*)ipS: (int)portS;
- (void) sendMessages;
- (void) messageReceived:(NSString*) message;

@end

