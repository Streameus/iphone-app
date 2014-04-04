//
//  STLoginViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STLoginViewController.h"
#import "STApiOAuthViewController.h"

@interface STLoginViewController ()

@end

@implementation STLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectOAuth:(id)sender {
    UIButton *btn = (UIButton *)sender;
    STApiAccount *account = [[StreameusAPI sharedInstance] account];
    STApiOAuthViewController *controller;
    if ([btn.titleLabel.text isEqualToString:@"Google"]) {
        controller = [[STApiOAuthViewController alloc] initWithUrlString:[account getProviderUrl:@"Google"]];
        [self presentViewController:controller animated:YES completion:^{
            [self performSegueWithIdentifier:@"sign-inSegue" sender:sender];
        }];
    }
}

@end
