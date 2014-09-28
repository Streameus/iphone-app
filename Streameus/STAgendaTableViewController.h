//
//  STAgendaTableViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 09/07/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAgendaRepository.h"

@interface STAgendaTableViewController : UITableViewController

@property (nonatomic, strong) STAgendaRepository *repository;
@property (nonatomic, assign) STAgendaType agendaType;

- (IBAction)segmentChanged:(UISegmentedControl *)sender;

- (void)configureWithRepository:(STAgendaRepository *)repository;
- (void)refresh;

@end
