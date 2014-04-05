//
//  STSidebarViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STSidebarViewController.h"
#import "SWRevealViewController.h"
#import "STSearchViewController.h"
#import "STApiOAuthViewController.h"

@interface STSidebarViewController ()

@end

@implementation STSidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[[[self.tableView cellForRowAtIndexPath:indexPath] textLabel] text] capitalizedString];
    
    if ([segue.identifier isEqualToString:@"searchSegue"]) {
        STUserRepository *repo = [[STUserRepository alloc] init];
        [(STSearchViewController *)destViewController configureWithRepository:repo];
    } else if ([segue.identifier isEqualToString:@"logoutSegue"]) {
        [STApiOAuthViewController clearCookies];
    }

    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}

@end
