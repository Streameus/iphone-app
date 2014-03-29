//
//  STAideViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 02/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STAideViewController.h"
#import "SWRevealViewController.h"
#import "StreameusAPI/STApiResource.h"
#import "MBProgressHUD.h"

@interface STAideViewController ()

@end

@implementation STAideViewController

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
        NSURLResponse *response;
        NSError *error;
        [self.webview loadRequest:[STApiResource getFaqWithReturningResponse:&response error:&error]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
