//
//  STHomeViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STEventsRepository.h"

@interface STHomeViewController : UITableViewController

- (void)configureWithRepository:(STEventsRepository *)repository;
- (void)refresh;

@end
