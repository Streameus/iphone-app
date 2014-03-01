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
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        hud.animationType = MBProgressHUDAnimationZoomIn;
        NSURLRequest *urlRequest = [[Streameus sharedInstance] createUrlController:@"user"
                                                                          withVerb:GET];
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSLog(@"URL %@", [response URL]);
                                   NSLog(@"Response status code %ld", (long)statusCode);
                                   if (connectionError == nil && statusCode == 200) {
                                       id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                       NSMutableArray *tmpItems = [NSMutableArray array];
                                       NSLog(@"JSONData =\n%@", JSONData);
                                       for (NSDictionary *it in [JSONData objectForKey:@"data"]) {
                                           [tmpItems addObject:it];
                                           break;
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.user = [tmpItems objectAtIndex:0];
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           [self.userInfosLabel setText:[NSString stringWithFormat:@"%@", self.user]];
                                           [self.pseudoLabel setText:[NSString stringWithFormat:@"%@ (%@ %@)",
                                                                      [self.user objectForKey:@"pseudo"],
                                                                      [self.user objectForKey:@"firstName"],
                                                                      [self.user objectForKey:@"lastName"]]];
                                       });
                                   } else if (connectionError == nil && statusCode == 204){
                                       NSLog(@"No user found");
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   } else if (connectionError != nil){
                                       NSLog(@"Error happened = %@", connectionError);
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       UIAlertView *alert = [[UIAlertView alloc]
                                                             initWithTitle:@"Error"
                                                             message:[connectionError localizedDescription]
                                                             delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles: nil];
                                       [alert show];
                                   }
                               }];
    } else {
        NSLog(@"User :\n%@", self.user);
        [self.userInfosLabel setText:[NSString stringWithFormat:@"%@", self.user]];
        [self.pseudoLabel setText:[NSString stringWithFormat:@"%@ (%@ %@)",
                                   [self.user objectForKey:@"pseudo"],
                                   [self.user objectForKey:@"firstName"],
                                   [self.user objectForKey:@"lastName"]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
