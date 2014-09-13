//
//  STProfilAboutViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 08/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STProfilAboutViewController.h"

@interface STProfilAboutViewController ()

@end

@implementation STProfilAboutViewController

- (NSString *)replaceNil:(id)obj {
    NSLog(@"obj[%@] : %@", [obj class], obj);
    if ([NSNull null] != obj) {
        NSString *str = obj;
        if (str && [str length] > 0) {
            return str;
        }
    }
    return @"n/a";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    dataArray = [[NSMutableArray alloc] init];
    
    [dataArray addObject:@[@[@"Pseudo", [self replaceNil:[self.user objectForKey:@"Pseudo"]]],
                           @[@"Email", [self replaceNil:[self.user objectForKey:@"Email"]]],
                           @[@"FirstName", [self replaceNil:[self.user objectForKey:@"FirstName"]]],
                           @[@"LastName", [self replaceNil:[self.user objectForKey:@"LastName"]]]]];
    [dataArray addObject:@[@[@"Gender", [self replaceNil:[self.user objectForKey:@"Gender"]]],
                           @[@"BirthDay", [self replaceNil:[self.user objectForKey:@"BirthDay"]]]]];
    [dataArray addObject:@[@[@"Phone", [self replaceNil:[self.user objectForKey:@"Phone"]]],
                           @[@"Address", [self replaceNil:[self.user objectForKey:@"Address"]]],
                           @[@"City", [self replaceNil:[self.user objectForKey:@"City"]]],
                           @[@"Country", [self replaceNil:[self.user objectForKey:@"Country"]]]]];
    [dataArray addObject:@[@[@"Website", [self replaceNil:[self.user objectForKey:@"Website"]]],
                           @[@"Profession", [self replaceNil:[self.user objectForKey:@"Profession"]]],
                           @[@"Description", [self replaceNil:[self.user objectForKey:@"Description"]]]]];
}

#pragma mark - tablebiew delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[dataArray objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Personal details", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"", nil);
    } else if (section == 2) {
        return NSLocalizedString(@"Contact details", nil);
    } else if (section == 3) {
        return NSLocalizedString(@"Others", nil);
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"aboutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSArray *array = [dataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectAtIndex:1];
    cell.detailTextLabel.text = [[array objectAtIndex:indexPath.row] objectAtIndex:0];
    return cell;
}

@end
