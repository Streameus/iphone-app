//
//  STProfilAboutViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 08/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STProfilAboutViewController.h"

@interface STProfilAboutViewController ()

@end

@implementation STProfilAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.userInfos setText:[NSString stringWithFormat:@"%@", self.user]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
