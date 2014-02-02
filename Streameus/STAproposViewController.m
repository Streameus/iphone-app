//
//  STAproposViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 02/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STAproposViewController.h"
#import "SWRevealViewController.h"

@interface STAproposViewController ()

@end

@implementation STAproposViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealBtn;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
