//
//  STHomeViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STEventsRepository.h"

@interface STHomeViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) STEventsRepository *repository;
@property (nonatomic, strong) NSMutableDictionary *searchResults;
@property (nonatomic, retain) NSOperationQueue *searchQueue;

@property IBOutlet UISearchBar *searchBar;

- (void)goToSearch;

- (void)configureWithRepository:(STEventsRepository *)repository;
- (void)refresh;

@end
