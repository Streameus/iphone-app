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
#import "STConferenceViewController.h"

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
    self.agendaType = AGENDA;
    if (!self.repository) {
        STAgendaRepository *repo = [[STAgendaRepository alloc] init];
        [self configureWithRepository:repo];
    }

    self.navigationItem.leftBarButtonItem = [STLeftMenuBarButton menuBarItemTarget:self.revealViewController action:@selector(revealToggle:)];
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
    [self.repository fetch:self.agendaType];
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 1:
            self.agendaType = LIVE;
            if (![self.repository.live count]) {
                [self refresh];
            } else {
                [self.tableView reloadData];
            }
            break;
        case 2:
            self.agendaType = SOON;
            if (![self.repository.soon count]) {
                [self refresh];
            } else {
                [self.tableView reloadData];
            }
            break;
        default:
            self.agendaType = AGENDA;
            if (![self.repository.agenda count]) {
                [self refresh];
            } else {
                [self.tableView reloadData];
            }
            break;
    }
}

#pragma mark - refresh

- (void)didFetch:(NSArray *)items forType:(STAgendaType)type {
    self.agendaType = type;
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView reloadData];
}

- (void)refresh {
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self.repository fetch:self.agendaType];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.agendaType == AGENDA) {
        return [self.repository.agenda count];
    } else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.agendaType) {
        case LIVE:
            return [self.repository.live count];
        case SOON:
            return [self.repository.soon count];
        default:
            return [[[self.repository.agenda objectAtIndex:section] objectForKey:@"Value"] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.agendaType == AGENDA) {
        return [[[self.repository.agenda objectAtIndex:section] objectForKey:@"Key"] dateFromApiDay];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"agendaCell" forIndexPath:indexPath];
    NSDictionary *item;
    
    switch (self.agendaType) {
        case LIVE:
            item = [self.repository.live objectAtIndex:indexPath.row];
            break;
        case SOON:
            item = [self.repository.soon objectAtIndex:indexPath.row];
            break;
        default:
            item = [[[self.repository.agenda objectAtIndex:indexPath.section] objectForKey:@"Value"] objectAtIndex:indexPath.row];
            break;
    }
    
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/conference/%@", [api baseUrl], [item objectForKey:@"Id"]]];
//    [self.profilPicture setImageURL:url];
    [(AsyncImageView *)cell.imageView setImageURL:url];
    cell.textLabel.text = [item objectForKey:@"Name"];
    cell.detailTextLabel.text = [[item objectForKey:@"Date"] dateFromApi];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item;
    
    switch (self.agendaType) {
        case LIVE:
            item = [self.repository.live objectAtIndex:indexPath.row];
            break;
        case SOON:
            item = [self.repository.soon objectAtIndex:indexPath.row];
            break;
        default:
            item = [[[self.repository.agenda objectAtIndex:indexPath.section] objectForKey:@"Value"] objectAtIndex:indexPath.row];
            break;
    }
    [self performSegueWithIdentifier:@"agendaToConferenceSegue" sender:item];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"agendaToConferenceSegue"]) {
        STConferenceViewController *dest = (STConferenceViewController *)segue.destinationViewController;
        [dest setConference:nil];
        [dest setConferenceId:[sender objectForKey:@"Id"]];
    }
}


@end
