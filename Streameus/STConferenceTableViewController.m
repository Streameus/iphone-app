//
//  STConferenceTableViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 15/05/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STConferenceTableViewController.h"
#import "STConferenceViewController.h"
#import "AsyncImageView.h"

@interface STConferenceTableViewController () <STConferenceRepositoryDelegate>

@property (nonatomic, strong) STConferenceRepository *repository;

@end

@implementation STConferenceTableViewController

- (void)configureWithRepository:(STConferenceRepository *)repository {
    self.repository = repository;
    self.repository.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.categorieName) {
        self.title = self.categorieName;
    }
    self.refreshControl = nil;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.animationType = MBProgressHUDAnimationZoomIn;
    [self.repository fetch];
}

#pragma mark - refresh

- (void)didFetch:(NSArray *)items {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView reloadData];
}

- (void)refresh {
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self.repository fetch];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repository.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conferenceCell" forIndexPath:indexPath];
    
    NSDictionary *item = [self.repository.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"Name"];
    cell.detailTextLabel.text = [item objectForKey:@"Description"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/conference/%@", [[StreameusAPI sharedInstance] baseUrl], [item objectForKey:@"Id"]]];
    [cell.imageView setImageURL:url];

    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"conferenceViewSegue"]) {
        STConferenceViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [destViewController setConference:[self.repository.items objectAtIndex:indexPath.row]];
    }
}

@end
