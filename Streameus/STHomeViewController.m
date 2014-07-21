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
#import "STSuggestionTableViewCell.h"
#import "NSString+Common.h"
#import "STProfilViewController.h"
#import "STSuggestionCollectionViewCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"

static NSString *EventCellIdentifier = @"eventCell";

@interface STHomeViewController () <STEventsRepositoryDelegate>

@property (nonatomic, assign) int currentRow;

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
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 5, 0);
    self.tableView.contentInset = inset;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.currentRow = [weakSelf.repository.items count];
        [weakSelf.repository fetchMore];
    }];
    
    [self.repository fetch];
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
//    [self.repository fetch];
}

#pragma mark - refresh

- (void)didFetch:(NSArray *)items {
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView reloadData];
}

- (void)didFetchMore:(NSArray *)items {
    [self.tableView.infiniteScrollingView stopAnimating];
    [self reloadTableView:self.currentRow];
}

- (void)reloadTableView:(int)startingRow;
{
    // the last row after added new items
    int endingRow = [self.repository.items count];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (; startingRow < endingRow; startingRow++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:startingRow inSection:0]];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)refresh {
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self.repository clear];
    [self.tableView reloadData];
    [self.repository fetch];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"suggestionToProfilSegue"]) {
        STProfilViewController *destViewController = segue.destinationViewController;
        [destViewController setUser:[(STSuggestionCollectionViewCell *)sender user]];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repository.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.repository.items objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]]) {
        STSuggestionTableViewCell *cell = (STSuggestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"suggestCell" forIndexPath:indexPath];
        cell.items = [self.repository.items objectAtIndex:indexPath.row];
        return cell;
    }
    STEventTableViewCell *cell = (STEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:EventCellIdentifier forIndexPath:indexPath];
    NSDictionary *item = [self.repository.items objectAtIndex:indexPath.row];

    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/user/%@", [api baseUrl], [item objectForKey:@"AuthorId"]]];
    [cell.picture setImageURL:url];
    cell.content.text = [STApiEvent getContentString:item];
    cell.date.text = [[item objectForKey:@"Date"] dateFromApi];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.repository.items objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]])
        return 135;
    return 115;
}

@end
