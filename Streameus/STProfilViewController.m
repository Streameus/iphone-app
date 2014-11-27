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
#import "STSubscriptionsTableViewController.h"
#import "STConferenceTableViewController.h"
#import "STHomeViewController.h"
#import "FXBlurView.h"

@interface STProfilViewController ()

@property (nonatomic, strong) STHomeViewController *eventsViewController;

@end

@implementation STProfilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tmpIBBackground.hidden = true; // Background set to help while in IB not needed after
    
    self.profilPicture.layer.cornerRadius = self.profilPicture.frame.size.width / 2;
    self.profilPicture.clipsToBounds = true;
    self.profilPicture.layer.borderWidth = 4.0f;
    self.profilPicture.layer.borderColor = [UIColor  colorWithWhite:1 alpha:0.95].CGColor;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"night-cafe_iphone5"] blurredImageWithRadius:70 iterations:2 tintColor:[UIColor colorWithRed:246/255 green:241/255 blue:211/255 alpha:1]]];
    
    self.followBtn.enabled = false;
    [self.followBtn setTitle:NSLocalizedString(@"Follow", nil) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.8
                          delay:1
         usingSpringWithDamping:0.3
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.followBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
                     } completion:nil];
    
    if (!self.user || self.userId) { // Check pour pouvoir afficher back | A perfectionner
        if (!self.userId) {
            self.navigationItem.leftBarButtonItem = [STLeftMenuBarButton menuBarItemTarget:self.revealViewController action:@selector(revealToggle:)];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        hud.animationType = MBProgressHUDAnimationZoomIn;
        
        NSURLRequest *urlRequest;
        if (self.userId) {
            urlRequest = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"user/%@", self.userId] withVerb:GET];
        } else {
            urlRequest = [[StreameusAPI sharedInstance] createUrlController:@"user/me" withVerb:GET];
        }
        
        
        [self.followBtn setHidden:YES];
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSLog(@"URL %@", [response URL]);
                                   NSLog(@"Response status code %ld", (long)statusCode);
                                   if (connectionError == nil && statusCode == 200) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.user = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                           NSLog(@"User :\n%@", self.user);
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           [self.pseudoLabel setText:[NSString stringWithFormat:@"%@ %@",
                                                                      [self.user objectForKey:@"FirstName"],
                                                                      [self.user objectForKey:@"LastName"]]];
                                           [self.pseudoLabelSubtitle setText:[NSString stringWithFormat:@"@%@", [self.user objectForKey:@"Pseudo"]]];
                                           [self loadProfilPicture:[self.user objectForKey:@"Id"]];
                                           [self.conferencesButton setTitle:[NSString stringWithFormat:@"%@\nConferences", [self.user objectForKey:@"Conferences"]] forState:UIControlStateNormal];
                                           [self.followersButton setTitle:[NSString stringWithFormat:@"%@\nFollowers", [self.user objectForKey:@"Followers"]] forState:UIControlStateNormal];
                                           [self.followingButton setTitle:[NSString stringWithFormat:@"%@\nFollowing", [self.user objectForKey:@"Followings"]] forState:UIControlStateNormal];
                                           [[self.eventsViewController repository] setDontLoad:false];
                                           [[self.eventsViewController repository] setAuthorId:[[self.user objectForKey:@"Id"] intValue]];
                                           [self.eventsViewController refresh];
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
        [self.pseudoLabel setText:[NSString stringWithFormat:@"%@ %@",
                                   [self.user objectForKey:@"FirstName"],
                                   [self.user objectForKey:@"LastName"]]];
        [self.pseudoLabelSubtitle setText:[NSString stringWithFormat:@"@%@", [self.user objectForKey:@"Pseudo"]]];
        [self loadProfilPicture:[self.user objectForKey:@"Id"]];
        [self.conferencesButton setTitle:[NSString stringWithFormat:@"%@\nConferences", [self.user objectForKey:@"Conferences"]] forState:UIControlStateNormal];
        [self.followersButton setTitle:[NSString stringWithFormat:@"%@\nFollowers", [self.user objectForKey:@"Followers"]] forState:UIControlStateNormal];
        [self.followingButton setTitle:[NSString stringWithFormat:@"%@\nFollowing", [self.user objectForKey:@"Followings"]] forState:UIControlStateNormal];
        [[self.eventsViewController repository] setDontLoad:false];
        [[self.eventsViewController repository] setAuthorId:[[self.user objectForKey:@"Id"] intValue]];
        [self.eventsViewController refresh];
        [self updateFollowBtn];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profilAboutSegue"]) {
        STProfilAboutViewController *destViewController = segue.destinationViewController;
        destViewController.user = self.user;
    }
    if ([segue.identifier isEqualToString:@"subscriptionsSegue"]) {
        STSubscriptionsTableViewController *destViewController = segue.destinationViewController;
        destViewController.user = self.user;
    }
    if ([segue.identifier isEqualToString:@"profilConferenceSegue"]) {
        STConferenceRepository *confRepo = [[STConferenceRepository alloc] init];
        [confRepo setUserId:[[self.user objectForKey:@"Id"] intValue]];
        [(STConferenceTableViewController *)segue.destinationViewController configureWithRepository:confRepo];
    }
    if ([segue.identifier isEqualToString:@"embedEventProfil"]) {
        int userId = [[self.user objectForKey:@"Id"] intValue];
        STEventsRepository *repo = [[STEventsRepository alloc] init];
        repo.authorId = userId;
        if (![self.user objectForKey:@"Id"]) {
            repo.dontLoad = true;
        }
        self.eventsViewController = segue.destinationViewController;
        [self.eventsViewController configureWithRepository:repo];
        self.eventsViewController.hideSearchBar = true;
    }
}

- (void)updateFollowBtn {
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"user/amIfollowing/%@", [self.user objectForKey:@"Id"]] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               BOOL amIFollowing = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"true"] ? true : false;
                               NSLog(@"updateFollow [%ld] : %d", (long)[(NSHTTPURLResponse *)response statusCode], amIFollowing);
                               if (amIFollowing) {
                                   [self.followBtn removeTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchUpInside];
                                   [self.followBtn addTarget:self action:@selector(unFollow) forControlEvents:UIControlEventTouchUpInside];
                                   [self.followBtn setTitle:NSLocalizedString(@"unFollow", nil) forState:UIControlStateNormal];
                               } else {
                                   [self.followBtn removeTarget:self action:@selector(unFollow) forControlEvents:UIControlEventTouchUpInside];
                                   [self.followBtn addTarget:self action:@selector(follow) forControlEvents:UIControlEventTouchUpInside];
                                   [self.followBtn setTitle:NSLocalizedString(@"Follow", nil) forState:UIControlStateNormal];
                               }
                               [self.followActivityIndicator stopAnimating];
                               self.followBtn.enabled = true;
                           }];
}

- (void)unFollow {
    NSLog(@"unfollow");
    self.followBtn.enabled = false;
    [self.followActivityIndicator startAnimating];
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"following/%@", [self.user objectForKey:@"Id"]] withVerb:DELETE];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSLog(@"unfollow [%ld](%@) : %@", (long)[(NSHTTPURLResponse *)response statusCode],[JSONData class], JSONData);
                               [self updateFollowBtn];
                           }];
}

- (void)follow {
    NSLog(@"follow");
    self.followBtn.enabled = false;
    [self.followActivityIndicator startAnimating];
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"following/%@", [self.user objectForKey:@"Id"]] withVerb:POST];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSLog(@"follow [%ld](%@) : %@", (long)[(NSHTTPURLResponse *)response statusCode],[JSONData class], JSONData);
                               [self updateFollowBtn];
                           }];
}

- (void)loadProfilPicture:(NSString *)userId {
    if (userId) {
        StreameusAPI *api = [StreameusAPI sharedInstance];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/user/%@", [api baseUrl], userId]];
        [self.profilPicture setImageURL:url];
    }
}

@end
