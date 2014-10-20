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
#import "STSuggestionConfTableViewCell.h"
#import "NSString+Common.h"
#import "STProfilViewController.h"
#import "STSuggestionCollectionViewCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "STConferenceViewController.h"
#import "FXBlurView.h"

static NSString *EventCellIdentifier = @"eventCell";

@interface STHomeViewController () <STEventsRepositoryDelegate>

@property (nonatomic, assign) NSUInteger currentRow;

@end

@implementation STHomeViewController
@synthesize searchResults;

- (void)configureWithRepository:(STEventsRepository *)repository {
    self.repository = repository;
    self.repository.delegate = self;
}

- (id)init {
    if ((self = [super init])) {
        self.searchResults = [NSMutableDictionary new];
        self.searchQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.repository) {
        STEventsRepository *repo = [[STEventsRepository alloc] init];
        [self configureWithRepository:repo];
    }
    
    [self.searchBar setShowsScopeBar:false];
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    [[self tableView] setBounds:newBounds];
    
    self.navigationItem.leftBarButtonItem = [STLeftMenuBarButton menuBarItemTarget:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.rightBarButtonItem = [STRightMenuBarButton menuBarItemTarget:self action:@selector(goToSearch)];
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

    self.parentViewController.view.backgroundColor = [UIColor
                                                      colorWithPatternImage:[[UIImage imageNamed:@"night-cafe_iphone5"]
                                                                             blurredImageWithRadius:30 iterations:1 tintColor:[UIColor colorWithRed:246/255 green:241/255 blue:211/255 alpha:1]]];
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

- (void)goToSearch {
    NSLog(@"%f", self.tableView.contentOffset.y);
    [self.tableView setContentOffset:CGPointMake(0.0f, -self.tableView.contentInset.top) animated:NO];
    NSLog(@"%f", self.tableView.contentOffset.y);
    [self.searchBar becomeFirstResponder];
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

- (void)reloadTableView:(NSUInteger)startingRow;
{
    // the last row after added new items
    NSUInteger endingRow = [self.repository.items count];
    
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
        [destViewController setUser:[(STSuggestionCollectionViewCell *)sender data]];
    } else if ([segue.identifier isEqualToString:@"suggestionToConfSegue"]) {
        STConferenceViewController *destViewController = segue.destinationViewController;
        [destViewController setConference:[(STSuggestionCollectionViewCell *)sender data]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 2;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *scope = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
        if (section == 0 && ![scope isEqualToString:@"Users"]) {
            if ([self.searchResults objectForKey:@"Conferences"]) {
                return ([[self.searchResults objectForKey:@"Conferences"] count] == 0) ? nil : @"Conferences";
            }
        } else if (section == 1 && ![scope isEqualToString:@"Conferences"]) {
            if ([self.searchResults objectForKey:@"Users"]) {
                return ([[self.searchResults objectForKey:@"Users"] count] == 0) ? nil : @"Users";
            }
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *scope = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
        if (section == 0 && ![scope isEqualToString:@"Users"]) {
            if ([self.searchResults objectForKey:@"Conferences"]) {
                return [[self.searchResults objectForKey:@"Conferences"] count];
            }
        } else if (section == 1 && ![scope isEqualToString:@"Conferences"]) {
            if ([self.searchResults objectForKey:@"Users"]) {
                return [[self.searchResults objectForKey:@"Users"] count];
            }
        }
        return 0;
    }
    return [self.repository.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
        }
        NSDictionary *item;
        NSString *scope = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
        NSLog(@"section %ld scope %@", (long)indexPath.section, scope);
        if (indexPath.section == 0 && ![scope isEqualToString:@"Users"]) {
            item = [[searchResults objectForKey:@"Conferences"] objectAtIndex:indexPath.row];
            cell.textLabel.text = [item objectForKey:@"Name"];
        } else if (indexPath.section == 1 && ![scope isEqualToString:@"Conferences"]) {
            item = [[searchResults objectForKey:@"Users"] objectAtIndex:indexPath.row];
            cell.textLabel.text = [item objectForKey:@"DisplayName"];
        }
        return cell;
    }
    if ([[self.repository.items objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]]) {
        NSArray *items = [self.repository.items objectAtIndex:indexPath.row];
        if ([[items objectAtIndex:0] objectForKey:@"Pseudo"]) {
            STSuggestionTableViewCell *cell = (STSuggestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"suggestCell" forIndexPath:indexPath];
            cell.items = items;
            return cell;
        } else {
            STSuggestionConfTableViewCell *cell = (STSuggestionConfTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"suggestConfCell" forIndexPath:indexPath];
            cell.items = items;
            return cell;
        }
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 50;
    }
    if ([[self.repository.items objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]])
        return 135;
    return 115;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if  ([searchString isEqualToString:@""] == NO)
    {
        StreameusAPI *api = [StreameusAPI sharedInstance];
        [self.searchQueue cancelAllOperations];
        
        NSURLRequest *req = [api createUrlController:@"search" withVerb:GET args:@{@"query":searchString}];
        [api sendAsynchronousRequest:req
                               queue:self.searchQueue
                              before:nil
                             success:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                 self.searchResults = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                             }
                             failure:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                 [self.searchResults removeAllObjects];
                             }
                               after:^(NSURLResponse *response, NSData *data, NSError *connectionError, id Json) {
                                   [self.searchDisplayController.searchResultsTableView reloadData];
                               }];
        
        return NO;
    }
    else
    {
        [self.searchResults removeAllObjects];
        return YES;
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSLog(@"reload");
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self.searchQueue cancelAllOperations];
}

@end
