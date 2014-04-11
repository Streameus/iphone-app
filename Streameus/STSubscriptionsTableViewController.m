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
@end

@implementation STSubscriptionsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
                                   self.items = JSONData;
                                   [self.tableView reloadData];
                               }
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                           }];
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
