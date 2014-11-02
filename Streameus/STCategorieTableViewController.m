//
//  STCategorieTableViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 02/11/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STCategorieTableViewController.h"
#import "SWRevealViewController.h"
#import "STConferenceTableViewController.h"

@interface STCategorieTableViewController () <STCategorieRepositoryDelegate>

@property (nonatomic, strong) STCategorieRepository *repository;

@end

@implementation STCategorieTableViewController

- (void)configureWithRepository:(STCategorieRepository *)repository {
    self.repository = repository;
    self.repository.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =  NSLocalizedString(@"Categories", @"Browse categories title");
    
    self.navigationItem.leftBarButtonItem = [STLeftMenuBarButton menuBarItemTarget:self.revealViewController action:@selector(revealToggle:)];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.repository.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categorieCell" forIndexPath:indexPath];
    
    NSDictionary *item = [self.repository.items objectAtIndex:indexPath.row];
    [cell.textLabel setText:[item objectForKey:@"Name"]];
    [cell.detailTextLabel setText:[item objectForKey:@"Description"]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/category/%@", [[StreameusAPI sharedInstance] baseUrl], [item objectForKey:@"Id"]]];
    [cell.imageView setImageURL:url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self.repository.items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"categorieToConferenceListSegue" sender:item];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"categorieToConferenceListSegue"]) {
        STConferenceRepository *repo = [[STConferenceRepository alloc] init];
        [repo setCategorieId:[[(NSDictionary *)sender objectForKey:@"Id"] intValue]];
        STConferenceTableViewController *dest = (STConferenceTableViewController *)segue.destinationViewController;
        [dest configureWithRepository:repo];
        [dest setCategorieName:[sender objectForKey:@"Name"]];
    }
}

@end
