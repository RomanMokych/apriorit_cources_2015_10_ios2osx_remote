//
//  ViewController.m
//  client_ios
//
//  Created by Admin on 21.10.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize messages = _messages;
static int _port;
static NSString *_ip;
- (void)viewDidLoad {
    [super viewDidLoad];
    // _messages = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(NSString*)Ip
{
    return _ip;
}

+(int)Port
{
    return _port;
}




- (IBAction)toMyServer:(id)sender {
    self.ipField.text = @"10.0.0.176";//169.254.203.72";//192.168.48.128";//10.0.0.177";
    self.portField.text = @"7891";
    
    [self performSegueWithIdentifier:@"showVideoController" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVideoController"])
    {
        NSString* ip = [self.ipField text];
        int port = [self.portField.text intValue];
        VideoViewController *dest = segue.destinationViewController;
        dest.ip = ip;
        dest.port = port;
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
