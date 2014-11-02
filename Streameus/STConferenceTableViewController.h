//
//  STConferenceTableViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 15/05/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STConferenceRepository.h"

@interface STConferenceTableViewController : UITableViewController

@property (nonatomic, assign) NSString *categorieName;

- (void)configureWithRepository:(STConferenceRepository *)repository;
- (void)refresh;

@end
