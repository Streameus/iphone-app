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
#import "STConferenceTableViewController.h"
#import "UIButton+Streameus.h"

@interface STConferenceViewController ()

@end

@implementation STConferenceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    if (self.conference) {
        NSLog(@"Conference : \n %@", self.conference);
        [self initialLoad];
    } else if (self.conferenceId) {
        StreameusAPI *api = [StreameusAPI sharedInstance];
        NSURLRequest *urlRequest = [api createUrlController:[NSString stringWithFormat:@"conference/%@", self.conferenceId] withVerb:GET];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        hud.animationType = MBProgressHUDAnimationZoomIn;
        [api sendAsynchronousRequest:urlRequest
                               queue:nil
                              before:nil
                             success:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                 self.conference = Json;
                             }
                             failure:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                 UIAlertView *alert = [[UIAlertView alloc]
                                                       initWithTitle:@"Oops!"
                                                       message:[connectionError localizedDescription]
                                                       delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                                 [alert show];
                             }
                               after:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   [self initialLoad];
                               }];
    }
}

- (void)initialLoad {
    [self getParticipantsFromConferenceWithId:[self.conference objectForKey:@"Id"]];
    self.Name.text = [self.conference objectForKey:@"Name"];
    self.Picture.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/conference/%@", [[StreameusAPI sharedInstance] baseUrl], [self.conference objectForKey:@"Id"]]];
    self.OwnerPicture.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/user/%@", [[StreameusAPI sharedInstance] baseUrl], [self.conference objectForKey:@"Owner"]]];
    NSString* confStatus = [[self.conference objectForKey:@"Status"] stringValue];
    if ([confStatus isEqualToString:@"1"]) {
        self.Status.text = NSLocalizedString(@"On going", "CONF STATUS");
    } else if ([confStatus isEqualToString:@"2"]) {
        self.Status.text = NSLocalizedString(@"Starting soon", "CONF STATUS");
    } else {
        self.Status.text = NSLocalizedString(@"Done", "CONF STATUS");
    }
    
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
    
    //    BOOL registered = [[self.conference objectForKey:@"Registered"] isEqualToString:@"true"] ? true : false;
    //    [self updateSubscribe:registered];
    [self tmpUpdateRegistered];
}

- (void)tmpUpdateRegistered {
    NSString *Id = [self.conference objectForKey:@"Id"];
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"Conference/%@/Registered/me", Id] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               BOOL amIRegistered = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"true"] ? true : false;
                               NSLog(@"tmpUpdateRegistered [%ld] : %d", (long)[(NSHTTPURLResponse *)response statusCode], amIRegistered);
                               if (amIRegistered) {
                                   [self updateSubscribe:true];
                               } else {
                                   [self updateSubscribe:false];
                               }
                           }];

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
    } else if ([segue.identifier isEqualToString:@"categorieToConferenceSegue"]) {
        STConferenceRepository *confRepo = [[STConferenceRepository alloc] init];
        [confRepo setCategorieId:[[[self.conference objectForKey:@"Category"] objectForKey:@"Id"] intValue]];
        [(STConferenceTableViewController *)segue.destinationViewController configureWithRepository:confRepo];
    }
}

- (void)updateSubscribe:(BOOL)registered {
    [self.activityRegisteredIndicator stopAnimating];
    if (registered) {
        [self.subscribeBtn removeTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeBtn addTarget:self action:@selector(unsubscribe) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeBtn setTitle:NSLocalizedString(@"Unsubscribe", @"Un-Register from a conference") forState:UIControlStateNormal];
        [self.subscribeBtn dangerStyle];
    } else {
        [self.subscribeBtn removeTarget:self action:@selector(unsubscribe) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeBtn addTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
        [self.subscribeBtn setTitle:NSLocalizedString(@"Subscribe", @"Register to a conference") forState:UIControlStateNormal];
        [self.subscribeBtn successStyle];
    }
    self.subscribeBtn.enabled = true;
}

- (void)subscribe {
    self.subscribeBtn.enabled = false;
    [self.activityRegisteredIndicator startAnimating];
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"conference/%@/subscribe", [self.conference objectForKey:@"Id"]] withVerb:GET];
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
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"conference/%@/unsubscribe", [self.conference objectForKey:@"Id"]] withVerb:GET];
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
