//
//  STHomeViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STHomeViewController.h"
#import "SWRevealViewController.h"

@interface STHomeViewController ()

@end

@implementation STHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealBtn;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = @"Flux d'actualités";
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Calm down cowboy, this app is still under development!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok sry!"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
