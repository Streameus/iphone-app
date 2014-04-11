//
//  STSubscriptionsTableViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 11/04/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STSubscriptionsTableViewController.h"
#import "STProfilViewController.h"

@interface STSubscriptionsTableViewController ()
@property (nonatomic, strong, readwrite) NSArray *items;
@property (nonatomic, strong, readwrite) NSArray *following;
@property (nonatomic, strong, readwrite) NSArray *followers;
@property (nonatomic) int loaded;
@end

@implementation STSubscriptionsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loaded = 0;
    [self.followSegment addTarget:self
                           action:@selector(segmentFollowAction:)
                 forControlEvents:UIControlEventValueChanged];
    StreameusAPI *api = [StreameusAPI sharedInstance];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Loading...", nil);
    hud.animationType = MBProgressHUDAnimationZoomIn;

    NSURLRequest *request = [api createUrlController:[NSString stringWithFormat:@"following/%@", [self.user objectForKey:@"Id"]] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([(NSHTTPURLResponse *)response statusCode] == 200 && data) {
                                   NSArray *JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   self.following = JSONData;
                                   self.items = self.following;
                                   [self.tableView reloadData];
                               }
                               self.loaded++;
                               if (self.loaded == 2) {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                               }
                           }];
    NSURLRequest *request2 = [api createUrlController:[NSString stringWithFormat:@"follower/%@", [self.user objectForKey:@"Id"]] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request2
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ([(NSHTTPURLResponse *)response statusCode] == 200 && data) {
                                   NSArray *JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   self.followers = JSONData;
                               }
                               self.loaded++;
                               if (self.loaded == 2) {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                               }
                           }];
}

- (void)segmentFollowAction:(id)sender {
    UISegmentedControl *segment = sender;
    if (segment.selectedSegmentIndex == 0) {
        self.items = self.following;
    } else if (segment.selectedSegmentIndex == 1) {
        self.items = self.followers;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SubscriptionsSimpleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[self.items objectAtIndex:indexPath.row] objectForKey:@"Pseudo"];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"followerSegue"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        STProfilViewController *destController = [segue destinationViewController];
        destController.user = [self.items objectAtIndex:path.row];
    }
}


@end
