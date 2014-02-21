//
//  STProfilViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STProfilViewController.h"
#import "SWRevealViewController.h"

@interface STProfilViewController ()

@end

@implementation STProfilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.user) { // Check pour pouvoir afficher back | A perfectionner
        UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealBtn;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    NSLog(@"User :\n%@", self.user);
    [self.userInfosLabel setText:[NSString stringWithFormat:@"%@", self.user]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
