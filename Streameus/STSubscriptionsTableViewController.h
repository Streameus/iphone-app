//
//  STSubscriptionsTableViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 11/04/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSubscriptionsTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, strong, readonly) NSArray *following;
@property (nonatomic, strong, readonly) NSArray *followers;

@property (weak, nonatomic) IBOutlet UISegmentedControl *followSegment;

- (void)segmentFollowAction:(id)sender;

@end
