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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"conferenceToProfilSegue"]) {
        STProfilViewController *destviewController = segue.destinationViewController;
        [destviewController setUserId:[self.conference objectForKey:@"Owner"]];
    }
}

@end
