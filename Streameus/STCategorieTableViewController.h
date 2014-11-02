//
//  STCategorieTableViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 02/11/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCategorieRepository.h"

@interface STCategorieTableViewController : UITableViewController

- (void)configureWithRepository:(STCategorieRepository *)repository;
- (void)refresh;

@end
