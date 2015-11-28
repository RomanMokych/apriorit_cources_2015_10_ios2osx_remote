//
//  ViewController.m
//  client_ios
//
//  Created by Admin on 21.10.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

static int _port;
static NSString *_ip;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue {
    
}


- (IBAction)info:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Enter PC IP address which screen you want to display and number of port. By default this number is 7891. "
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
}

- (IBAction)toMyServer:(id)sender {
    self.ipField.text = @"10.0.0.207";
    //self.portField.text = @"7891";
    _port = 7891;
    
    [self performSegueWithIdentifier:@"showVideoController" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVideoController"])
    {
        NSString* ip = [self.ipField text];
        //int port = [self.portField.text intValue];
        int port = _port;
        VideoViewController *dest = segue.destinationViewController;
        dest.ip = ip;
        dest.port = port;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.ipField)
    {
        [textField resignFirstResponder];
    }
    if (textField == self.portField)
    {
       [textField resignFirstResponder];
    }
    return YES;
}



@end
