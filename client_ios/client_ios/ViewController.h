//
//  ViewController.h
//  client_ios
//
//  Created by Admin on 21.10.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoViewController.h"

@interface ViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textF;

//@property (weak, nonatomic) NSString *ip;
//@property int port;

@property (weak, nonatomic) IBOutlet UITextField *ipField;
@property (weak, nonatomic) IBOutlet UITextField *portField;

- (IBAction)info:(id)sender;
- (IBAction)toMyServer:(id)sender;

@end

