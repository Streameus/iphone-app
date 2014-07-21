//
//  STEquipeViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 02/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STEquipeViewController.h"
#import "SWRevealViewController.h"
#import "StreameusAPI/STApiResource.h"
#import "MBProgressHUD.h"

@interface STEquipeViewController ()

@end

@implementation STEquipeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealBtn;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.animationType = MBProgressHUDAnimationZoomIn;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *request = [STApiResource getTeam];
        [self.webview loadRequest:request];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    self.shyNavBarManager.scrollView = self.webview.scrollView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
