//
//  STHomeViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STHomeViewController.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "STApiEvent.h"
#import "STEventTableViewCell.h"

static NSString *EventCellIdentifier = @"eventCell";

@interface STHomeViewController () <STEventsRepositoryDelegate>

@end

@implementation STHomeViewController

- (void)configureWithRepository:(STEventsRepository *)repository {
    self.repository = repository;
    self.repository.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    if (!self.repository) {
        STEventsRepository *repo = [[STEventsRepository alloc] init];
        [self configureWithRepository:repo];
    }
    
//    [self.tableView registerClass:[STEventTableViewCell class] forCellReuseIdentifier:EventCellIdentifier];
    
    UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealBtn;
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = NSLocalizedString(@"News feed", @"Title navigation bar home view");
    
    self.refreshControl = nil;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Assign our own backgroud for the view
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Add padding to the top of the table view
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:@"user/me" withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"User me : \n%@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
                           }];

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Calm down cowboy, this app is still under development!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok sry!"
                                          otherButtonTitles:nil];
    [alert show];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repository.items count];
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STEventTableViewCell *cell = (STEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:EventCellIdentifier forIndexPath:indexPath];
    NSDictionary *item = [self.repository.items objectAtIndex:indexPath.row];

    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/%@", [api baseUrl], [item objectForKey:@"AuthorId"]]];
    [cell.picture setImageURL:url];
    cell.content.text = [STApiEvent getContentString:item];
    cell.date.text = [item objectForKey:@"Date"];
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

@end
