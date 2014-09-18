//
//  STConferenceRegisteredTableViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 26/08/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STConferenceRegisteredTableViewController.h"
#import "STProfilViewController.h"

@interface STConferenceRegisteredTableViewController ()

@end

@implementation STConferenceRegisteredTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.participants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[self.participants objectAtIndex:indexPath.row] objectForKey:@"Pseudo"];
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/user/%@", [api baseUrl], [[self.participants objectAtIndex:indexPath.row] objectForKey:@"Id"]]];
    [cell.imageView setImageURL:url];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"registeredToProfilSegue"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        STProfilViewController *destController = [segue destinationViewController];
        destController.user = [self.participants objectAtIndex:path.row];
    }
}

@end
