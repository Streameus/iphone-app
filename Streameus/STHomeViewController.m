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
@property (nonatomic, assign) CGFloat currentOffset;
@property (nonatomic, strong) STEventTableViewCell *prototypeCell;

@end

@implementation STHomeViewController
@synthesize searchResults;

- (void)configureWithRepository:(STEventsRepository *)repository {
    self.repository = repository;
    self.repository.delegate = self;
}

- (STEventTableViewCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:EventCellIdentifier];
    }
    return _prototypeCell;
}

- (id)init {
    if ((self = [super init])) {
        self.searchResults = [NSMutableDictionary new];
        self.searchQueue = [NSOperationQueue new];
        self.hideSearchBar = false;
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
    
    if (self.hideSearchBar == false) {
        [self.searchBar setShowsScopeBar:false];
        [self.searchBar sizeToFit];
        [self.searchBar setBackgroundColor:[UIColor clearColor]];
        self.searchBar.delegate = self;
        CGRect newBounds = [[self tableView] bounds];
        newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
        [[self tableView] setBounds:newBounds];
    } else {
        [self.searchBar removeFromSuperview];
        self.tableView.tableHeaderView = nil;
    }
    
    self.navigationItem.leftBarButtonItem = [STLeftMenuBarButton menuBarItemTarget:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.rightBarButtonItem = [STRightMenuBarButton menuBarItemTarget:self action:@selector(goToSearch)];
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.title = NSLocalizedString(@"News feed", @"Title navigation bar home view");
    
    self.refreshControl = nil;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl setBackgroundColor:[UIColor clearColor]];
    
    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.navigationController.navigationBar setTranslucent:true];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *scope = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
        if (indexPath.section == 0 && ![scope isEqualToString:@"Users"]) {
            [self performSegueWithIdentifier:@"searchConfSegue" sender:[[searchResults objectForKey:@"Conferences"] objectAtIndex:indexPath.row]];
        } else if (indexPath.section == 1 && ![scope isEqualToString:@"Conferences"]) {
            [self performSegueWithIdentifier:@"searchUserSegue" sender:[[searchResults objectForKey:@"Users"] objectAtIndex:indexPath.row]];
        }
    } else {
        if ([self.repository.items count] > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Calm down cowboy, this app is still under development!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok sry!"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.repository fetch];
}

- (void)goToSearch {
    self.currentOffset = self.tableView.contentOffset.y;
    [self.tableView setContentOffset:CGPointMake(0.0f, -self.tableView.contentInset.top) animated:NO];
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
    } else if ([segue.identifier isEqualToString:@"searchConfSegue"]) {
        STConferenceViewController *destViewController = segue.destinationViewController;
        [destViewController setConference:sender];
    } else if ([segue.identifier isEqualToString:@"searchUserSegue"]) {
        STProfilViewController *destViewController = segue.destinationViewController;
        [destViewController setUser:sender];
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
    return ([self.repository.items count] > 0)? [self.repository.items count] : 1;
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
        if (indexPath.section == 0 && ![scope isEqualToString:@"Users"]) {
            UITableViewCell *searchConfCell = [tableView dequeueReusableCellWithIdentifier:@"searchConfCell"];
            if (searchConfCell == nil) {
                searchConfCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchConfCell"];
            }
            item = [[searchResults objectForKey:@"Conferences"] objectAtIndex:indexPath.row];
            searchConfCell.textLabel.text = [item objectForKey:@"Name"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/conference/%@", [[StreameusAPI sharedInstance] baseUrl], [item objectForKey:@"Id"]]];
            [searchConfCell.imageView setImageURL:url];
            return searchConfCell;
        } else if (indexPath.section == 1 && ![scope isEqualToString:@"Conferences"]) {
            UITableViewCell *searchUserCell = [tableView dequeueReusableCellWithIdentifier:@"searchUserCell"];
            if (searchUserCell == nil) {
                searchUserCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchUserCell"];
            }
            item = [[searchResults objectForKey:@"Users"] objectAtIndex:indexPath.row];
            searchUserCell.textLabel.text = [item objectForKey:@"DisplayName"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/user/%@", [[StreameusAPI sharedInstance] baseUrl], [item objectForKey:@"Id"]]];
            [searchUserCell.imageView setImageURL:url];
            return searchUserCell;
        }
        return cell;
    }
    if ([self.repository.items count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
        }
        cell.textLabel.text = NSLocalizedString(@"It seems that there is no content available.", nil);
        cell.textLabel.textColor = UIColorFromRGB(0xDDDDDD);
        cell.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:18];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor clearColor];
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
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[STEventTableViewCell class]])
    {
        STEventTableViewCell *aCell = (STEventTableViewCell *)cell;
        NSDictionary *item = [self.repository.items objectAtIndex:indexPath.row];
        
        StreameusAPI *api = [StreameusAPI sharedInstance];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/user/%@", [api baseUrl], [item objectForKey:@"AuthorId"]]];
        [aCell.picture setImageURL:url];
        aCell.picture.layer.masksToBounds = YES;
        aCell.picture.layer.cornerRadius = aCell.picture.frame.size.width / 2;
        
        NSString* content = [STApiEvent getContentString:item];
        aCell.content.text = [NSString stringWithFormat:@"%@", content];
        aCell.date.text = [[item objectForKey:@"Date"] dateFromApi];
        
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 50;
    }
    if ([self.repository.items count] == 0) {
        return 150;
    }
    if ([[self.repository.items objectAtIndex:indexPath.row] isKindOfClass:[NSArray class]])
        return 135;
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return (size.height >= 120) ? size.height : 120;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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
        self.searchResults = nil;
//        [(NSMutableDictionary *)self.searchResults removeAllObjects];
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

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.tableView setContentOffset:CGPointMake(0.0f, self.currentOffset) animated:NO];
}

@end
