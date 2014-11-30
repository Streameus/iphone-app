//
//  STCategorieCollectionViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 30/11/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCategorieRepository.h"

@interface STCategorieCollectionViewController : UICollectionViewController

- (void)configureWithRepository:(STCategorieRepository *)repository;
- (void)refresh;

@property (nonatomic,retain) UIRefreshControl *refreshControl;

@end
