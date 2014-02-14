//
//  STSearchViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 12/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUserRepository.h"

@interface STSearchViewController : UITableViewController

- (void)configureWithRepository:(STUserRepository *)repository;
- (void)refresh;

@end
