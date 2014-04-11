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

@end
