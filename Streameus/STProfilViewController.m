//
//  STProfilViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STProfilViewController.h"
#import "SWRevealViewController.h"
#import "STProfilAboutViewController.h"

@interface STProfilViewController ()

@end

@implementation STProfilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // @TODO : Afficher bouton follow que si on est sur le profil d'un autre
    if (!self.user) { // Check pour pouvoir afficher back | A perfectionner
        UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.revealViewController action:@selector(revealToggle:)];
        self.navigationItem.leftBarButtonItem = revealBtn;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        hud.animationType = MBProgressHUDAnimationZoomIn;
        NSURLRequest *urlRequest = [[StreameusAPI sharedInstance] createUrlController:@"user/me"
                                                                          withVerb:GET];
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSLog(@"URL %@", [response URL]);
                                   NSLog(@"Response status code %ld", (long)statusCode);
                                   if (connectionError == nil && statusCode == 200) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.user = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           [self.pseudoLabel setText:[NSString stringWithFormat:@"%@ (%@ %@)",
                                                                      [self.user objectForKey:@"Pseudo"],
                                                                      [self.user objectForKey:@"FirstName"],
                                                                      [self.user objectForKey:@"LastName"]]];
                                           [self loadProfilPicture:[self.user objectForKey:@"Id"]];
                                       });
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
        [self.pseudoLabel setText:[NSString stringWithFormat:@"%@ (%@ %@)",
                                   [self.user objectForKey:@"Pseudo"],
                                   [self.user objectForKey:@"FirstName"],
                                   [self.user objectForKey:@"LastName"]]];
        [self loadProfilPicture:[self.user objectForKey:@"Id"]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profilAboutSegue"]) {
        STProfilAboutViewController *destViewController = segue.destinationViewController;
        destViewController.user = self.user;
    }
}

- (void)loadProfilPicture:(NSString *)userId {
    if (userId) {
        StreameusAPI *api = [StreameusAPI sharedInstance];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/%@", [api baseUrl], userId]];
        [self.profilPicture setImageURL:url];
    }
}

@end
