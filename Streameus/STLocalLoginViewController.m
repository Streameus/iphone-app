//
//  STLocalLoginViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 01/09/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STLocalLoginViewController.h"

@interface STLocalLoginViewController ()

@end

@implementation STLocalLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.username setDelegate:self];
    [self.password setDelegate:self];
    self.errorMessage.text = @"";
    [self.activityIndicator setHidden:true];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userName = [prefs stringForKey:@"STLocalLoginUsername"];
    if (userName) {
        self.username.text = userName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signin:(id)sender {
    self.errorMessage.text = @"";
    STApiAccount *account = [[StreameusAPI sharedInstance] account];
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [self.signinBtn setEnabled:false];
    [self.activityIndicator setHidden:false];
    [prefs setObject:self.username.text forKey:@"STLocalLoginUsername"];
    
    NSURLRequest *request = [api createUrlController:@"../token" withVerb:POST args:nil andBody:[NSString stringWithFormat:@"grant_type=password&userName=%@&password=%@", self.username.text, self.password.text]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               NSLog(@"URL %@", [response URL]);
                               NSLog(@"Response status code %ld", (long)statusCode);
                               id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               if (connectionError == nil && statusCode == 200) {
                                   NSLog(@"JSONData =\n%@", JSONData);
//                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [account connectUser:[JSONData objectForKey:@"access_token"]
                                               andTokenType:[JSONData objectForKey:@"token_type"]
                                          completionHandler:^(BOOL success) {
                                              if (success) {
                                                  NSLog(@"API : %@", [[api account] accessToken]);
                                                  [self performSegueWithIdentifier:@"sign-inSegue"
                                                                            sender:nil];
                                              }
                                          }];
//                                   });
                               } else if (connectionError == nil && statusCode == 400){
                                   self.errorMessage.text = [JSONData objectForKey:@"error_description"];
                                   [self bounceAnimation:self.username];
                                   [self bounceAnimation:self.password];
                                   [self.activityIndicator setHidden:true];
                                   [self.signinBtn setEnabled:true];
                               } else if (connectionError != nil || (connectionError == nil && statusCode == 404)){
                                   NSLog(@"Error happened = %@", connectionError);
                                   UIAlertView *alert = [[UIAlertView alloc]
                                                         initWithTitle:@"Error"
                                                         message:[connectionError localizedDescription]
                                                         delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
                                   [alert show];
                                   [self.activityIndicator setHidden:true];
                                   [self.signinBtn setEnabled:true];
                               }
                           }];

    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)backgroundTouched:(id)sender {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.password becomeFirstResponder];
    } else if (textField.tag == 2) {
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
