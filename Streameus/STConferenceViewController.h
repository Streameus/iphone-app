//
//  STConferenceViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 15/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STConferenceRepository.h"

@interface STConferenceViewController : UITableViewController

- (void)configureWithRepository:(STConferenceRepository *)repository;
- (void)refresh;

@end
