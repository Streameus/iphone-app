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

- (IBAction)connectOAuth:(id)sender {
    UIButton *btn = (UIButton *)sender;
    STApiAccount *account = [[StreameusAPI sharedInstance] account];
    STApiOAuthViewController *controller;
    
//    [STApiOAuthViewController clearCookies];
    
    if ([btn.titleLabel.text isEqualToString:@"Google"]) {
        controller = [[STApiOAuthViewController alloc] initWithUrlString:[account getProviderUrl:@"Google"] completionHandler:^(NSString *accessToken, NSString *tokenType) {
            [account connectUser:accessToken andTokenType:tokenType completionHandler:^(BOOL success) {
                [self loadNextViewOnSuccess:success];
            }];
        }];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)loadNextViewOnSuccess:(BOOL)success {
    if (success) {
        [self performSegueWithIdentifier:@"sign-inSegue" sender:nil];
    }
}

@end
