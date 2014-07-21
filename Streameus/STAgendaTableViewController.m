//
//  STAgendaTableViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 09/07/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STAgendaTableViewController.h"
#import "SWRevealViewController.h"
#import "NSString+Common.h"
#import "AsyncImageView.h"

@interface STAgendaTableViewController () <STAgendaRepositoryDelegate>

@end

@implementation STAgendaTableViewController

- (void)configureWithRepository:(STAgendaRepository *)repository {
    self.repository = repository;
    self.repository.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.repository) {
        STAgendaRepository *repo = [[STAgendaRepository alloc] init];
        [self configureWithRepository:repo];
    }

    UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealBtn;
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.refreshControl = nil;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.repository fetch];
}

#pragma mark - refresh

- (void)didFetch:(NSArray *)items {
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView reloadData];
}

- (void)refresh {
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self.repository fetch];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.repository.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.repository.items objectAtIndex:section] objectForKey:@"Value"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.repository.items objectAtIndex:section] objectForKey:@"Key"] dateFromApiDay];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"agendaCell" forIndexPath:indexPath];
    NSDictionary *item = [[[self.repository.items objectAtIndex:indexPath.section] objectForKey:@"Value"] objectAtIndex:indexPath.row];
    
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/conference/%@", [api baseUrl], [item objectForKey:@"Id"]]];
//    [self.profilPicture setImageURL:url];
    [(AsyncImageView *)cell.imageView setImageURL:url];
    cell.textLabel.text = [item objectForKey:@"Name"];
    cell.detailTextLabel.text = [[item objectForKey:@"Date"] dateFromApi];
    
    return cell;
}



@end
