//
//  STConferenceViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 24/08/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STConferenceViewController.h"
#import "STProfilViewController.h"
#import "STConferenceRegisteredTableViewController.h"

@interface STConferenceViewController ()

@end

@implementation STConferenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Conference : \n %@", self.conference);

    [self getParticipantsFromConferenceWithId:[self.conference objectForKey:@"Id"]];
    self.Name.text = [self.conference objectForKey:@"Name"];
    self.Picture.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/conference/%@", [[StreameusAPI sharedInstance] baseUrl], [self.conference objectForKey:@"Id"]]];
    self.OwnerPicture.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/user/%@", [[StreameusAPI sharedInstance] baseUrl], [self.conference objectForKey:@"Owner"]]];
    self.Status.text = [[self.conference objectForKey:@"Status"] stringValue];
    
    NSDictionary *descContentAttrs = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Italic" size:16], NSForegroundColorAttributeName : [UIColor colorWithWhite:0.5f alpha:1.0f]};
    NSDictionary *descTitleAttrs = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:16], NSForegroundColorAttributeName : [UIColor colorWithWhite:0.5f alpha:1.0f]};
    
    NSMutableAttributedString* attributedDescText = [[NSMutableAttributedString alloc] init];
    [attributedDescText appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Title : ", @"Date conference description") attributes:descTitleAttrs]];
    [attributedDescText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", [self.conference objectForKey:@"Name"]] attributes:descContentAttrs]];
    [attributedDescText appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Date : ", @"Date conference description") attributes:descTitleAttrs]];
    [attributedDescText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", [[self.conference objectForKey:@"Time"] dateFromApi]] attributes:descContentAttrs]];
    [attributedDescText appendAttributedString:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Description : ", @"Description conference") attributes:descTitleAttrs]];
    [attributedDescText appendAttributedString:[[NSAttributedString alloc] initWithString:[self.conference objectForKey:@"Description"] attributes:descContentAttrs]];
    self.Description.attributedText = attributedDescText;
    
    [self.categorieBtn setTitle:[[self.conference objectForKey:@"Category"] objectForKey:@"Name"] forState:UIControlStateNormal];
    
    BOOL registered = [[self.conference objectForKey:@"Registered"] isEqualToString:@"true"] ? true : false;
    [self updateSubscribe:registered];
}

- (void)getParticipantsFromConferenceWithId:(NSString *)confId {
    self.participantsBtn.enabled = false;
//    [self.participantsBtn setTitle:@"" forState:UIControlStateNormal];
    self.loadingParticipants.hidden = false;
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLRequest *request;
        request = [api createUrlController:[NSString stringWithFormat:@"conference/%@/Registered", confId] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               NSLog(@"URL %@", [response URL]);
                               NSLog(@"Response status code %ld", (long)statusCode);
                               if (connectionError == nil && statusCode == 200) {
                                   id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   NSMutableArray *tmpItems = [NSMutableArray array];
                                   NSLog(@"JSONData =\n%@", JSONData);
                                   for (NSDictionary *it in JSONData) {
                                       [tmpItems addObject:it];
                                   }
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self didFetchParticipants:tmpItems];
                                   });
                               } else if (connectionError != nil){
                                   NSLog(@"Error happened = %@", connectionError);
                                   UIAlertView *alert = [[UIAlertView alloc]
                                                         initWithTitle:@"Error"
                                                         message:[connectionError localizedDescription]
                                                         delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
                                   [alert show];
                                   [self didFetchParticipants:[[NSArray alloc] init]];
                               }
                           }];
}

- (void)didFetchParticipants:(NSArray *)items {
    self.loadingParticipants.hidden = true;
    self.participants = items;
    NSInteger count = [items count];
    if (items == nil) {
        count = 0;
    }
    [self.participantsBtn setTitle:[NSString stringWithFormat:@"%ld %@", (long)count, NSLocalizedString(@"registered", nil)] forState:UIControlStateNormal];
    if (count > 0) {
        self.participantsBtn.enabled = true;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"conferenceToProfilSegue"]) {
        STProfilViewController *destviewController = segue.destinationViewController;
        [destviewController setUserId:[self.conference objectForKey:@"Owner"]];
    } else if ([segue.identifier isEqualToString:@"confToParticipantsSegue"]) {
        STConferenceRegisteredTableViewController *destViewController = segue.destinationViewController;
        [destViewController setParticipants:self.participants];
    }
}

- (void)updateSubscribe:(BOOL)registered {
    [self.activityRegisteredIndicator stopAnimating];
    if (registered) {
        [self.subscribeBtn removeTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeBtn addTarget:self action:@selector(unsubscribe) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeBtn setTitle:NSLocalizedString(@"Subscribe", @"Register to a conference") forState:UIControlStateNormal];
        [self.subscribeBtn setBackgroundColor:[UIColor colorWithRed:80/255 green:170/255 blue:56/255 alpha:1]];
    } else {
        [self.subscribeBtn removeTarget:self action:@selector(unsubscribe) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeBtn addTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeBtn setTitle:NSLocalizedString(@"Unsubscribe", @"Un-Register from a conference") forState:UIControlStateNormal];
        [self.subscribeBtn setBackgroundColor:[UIColor colorWithRed:238/255 green:77/255 blue:89/255 alpha:1]];
    }
    self.subscribeBtn.enabled = true;
}

- (void)subscribe {
    self.subscribeBtn.enabled = false;
    [self.activityRegisteredIndicator startAnimating];
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"conference/%@/suscribe", [self.conference objectForKey:@"Id"]] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               if (connectionError == nil && (statusCode <= 204)) {
                                       [self updateSubscribe:true];
                               } else {
                                   [self.activityRegisteredIndicator stopAnimating];
                                   self.subscribeBtn.enabled = true;
                               }
                           }];

}

- (void)unsubscribe {
    self.subscribeBtn.enabled = false;
    [self.activityRegisteredIndicator startAnimating];
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"conference/%@/unsuscribe", [self.conference objectForKey:@"Id"]] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                               if (connectionError == nil && (statusCode <= 204)) {
                                   [self updateSubscribe:false];
                               } else {
                                   [self.activityRegisteredIndicator stopAnimating];
                                   self.subscribeBtn.enabled = true;
                               }
                           }];
}

@end
