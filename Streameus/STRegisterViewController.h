//
//  STRegisterViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 15/11/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *pseudo;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;
@property (weak, nonatomic) IBOutlet UIButton *signinBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)signin:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
