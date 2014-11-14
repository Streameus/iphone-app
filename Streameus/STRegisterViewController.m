//
//  STRegisterViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 15/11/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STRegisterViewController.h"

@interface STRegisterViewController ()

@end

@implementation STRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.email setDelegate:self];
    [self.pseudo setDelegate:self];
    [self.password setDelegate:self];
    self.errorMessage.text = @"";
    [self.activityIndicator setHidden:true];
    
    
    // TEMP
    self.email.text = @"anas.ait-ali@epitech.eu";
    self.pseudo.text = @"aitali";
    self.password.text = @"qweasd";
    // FIN TEMP

}

- (IBAction)signin:(id)sender {
    self.errorMessage.text = @"";
    StreameusAPI *api = [StreameusAPI sharedInstance];

    if (self.email.text.length > 0 && self.password.text.length > 0 && self.pseudo.text.length > 0) {
        [self.signinBtn setEnabled:false];
        [self.activityIndicator setHidden:false];
        
        NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"username": self.email.text, @"pseudo": self.pseudo.text, @"password": self.password.text, @"confirmpassword": self.password.text} options:0 error:nil];
        NSURLRequest *request = [api createUrlController:@"account/register" withVerb:POST args:nil andBody:[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]];
        
        [api sendAsynchronousRequest:request queue:nil before:nil
                             success:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                 [self performSegueWithIdentifier:@"registerToLoginSegue" sender:nil];
                             } failure:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                 if (Json) {
                                     self.errorMessage.text = [Json objectForKey:@"error_description"]; // ERROR NOT HANDLED CORRECTLY
                                 } else {
                                     UIAlertView *alert = [[UIAlertView alloc]
                                                           initWithTitle:@"Error"
                                                           message:[connectionError localizedDescription]
                                                           delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles: nil];
                                     [alert show];
                                 }
                                 [self bounceAnimation:self.email];
                                 [self bounceAnimation:self.pseudo];
                                 [self bounceAnimation:self.password];
                             } after:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                 [self.activityIndicator setHidden:true];
                                 [self.signinBtn setEnabled:true];
                             }];
    } else {
        [self bounceAnimation:self.email];
        [self bounceAnimation:self.pseudo];
        [self bounceAnimation:self.password];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.pseudo becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self.password becomeFirstResponder];
    } else if (textField.tag == 3) {
        [textField resignFirstResponder];
        [self signin:nil];
    }
    return YES;
}

- (void)bounceAnimation:(UIView *)view {
    CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    bounceAnimation.duration = 0.1;
    bounceAnimation.fromValue = [NSNumber numberWithInt:0];
    bounceAnimation.toValue = [NSNumber numberWithInt:20];
    bounceAnimation.repeatCount = 2;
    bounceAnimation.autoreverses = YES;
    bounceAnimation.fillMode = kCAFillModeForwards;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.additive = YES;
    [view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
}

@end
