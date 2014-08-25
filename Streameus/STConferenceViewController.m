//
//  STConferenceViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 24/08/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STConferenceViewController.h"
#import "STProfilViewController.h"

@interface STConferenceViewController ()

@end

@implementation STConferenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Conference : \n %@", self.conference);
    
    self.Name.text = [self.conference objectForKey:@"Name"];
    self.Picture.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/conference/%@", [[StreameusAPI sharedInstance] baseUrl], [self.conference objectForKey:@"Id"]]];
    self.OwnerPicture.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/user/%@", [[StreameusAPI sharedInstance] baseUrl], [self.conference objectForKey:@"Owner"]]];
    self.Status.text = [[self.conference objectForKey:@"Status"] stringValue];
    self.Date.text = [[self.conference objectForKey:@"Time"] dateFromApi];
    self.Description.text = [self.conference objectForKey:@"Description"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"conferenceToProfilSegue"]) {
        STProfilViewController *destviewController = segue.destinationViewController;
        [destviewController setUserId:[self.conference objectForKey:@"Owner"]];
    }
}

@end
