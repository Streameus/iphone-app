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

    self.navigationItem.leftBarButtonItem = [STLeftMenuBarButton menuBarItemTarget:self.revealViewController action:@selector(revealToggle:)];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading...", nil);
    hud.animationType = MBProgressHUDAnimationZoomIn;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURLRequest *request = [STApiResource getFaq];
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
