//
//  STSuggestionConfTableViewCell.m
//  Streameus
//
//  Created by Anas Ait Ali on 13/09/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STSuggestionConfTableViewCell.h"
#import "STSuggestionCollectionViewCell.h"
#import "STProfilViewController.h"

@implementation STSuggestionConfTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        [self.collectionView registerClass:[CellClass class] forCellWithReuseIdentifier:@"classCell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        
        // Configure layout
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        [self.flowLayout setItemSize:CGSizeMake(191, 160)];
        [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.flowLayout.minimumInteritemSpacing = 0.0f;
        [self.collectionView setCollectionViewLayout:self.flowLayout];
        self.collectionView.bounces = YES;
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView setShowsVerticalScrollIndicator:NO];
    }
    return self;
}

- (void)updateSubscribeBtn:(UIButton*)btn {
    NSString *Id = [NSString stringWithFormat: @"%d", (int)btn.tag];
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"Conference/%@/Registered/me", Id] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               BOOL amIFollowing = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"true"] ? true : false;
                               NSLog(@"updateSubscribe [%ld] : %d", (long)[(NSHTTPURLResponse *)response statusCode], amIFollowing);
                               if (amIFollowing) {
                                   btn.hidden = true;
                               } else {
                                   [btn addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
                                   btn.hidden = false;
                               }
                               btn.enabled = true;
                           }];
}

- (void)subscribe:(UIButton *)btn{
    NSLog(@"subscribe");
    NSString *Id = [NSString stringWithFormat: @"%d", (int)btn.tag];
    btn.enabled = false;
    NSURLRequest *request = [[StreameusAPI sharedInstance] createUrlController:[NSString stringWithFormat:@"/Conference/%@/Subscribe/", Id] withVerb:GET];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               id JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSLog(@"follow [%ld](%@) : %@", (long)[(NSHTTPURLResponse *)response statusCode],[JSONData class], JSONData);
                               [self updateSubscribeBtn:btn];
                           }];
}


#pragma mark - Collection

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    STSuggestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"suggestionConfCellItem" forIndexPath:indexPath];
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    cell.data = item;
    cell.title.text = [item objectForKey:@"Name"];
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/conference/%@", [api baseUrl], [item objectForKey:@"Id"]]];
    [cell.picture setImageURL:url];
    cell.button.tag = [[item objectForKey:@"Id"] integerValue];
    [self updateSubscribeBtn:cell.button];
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

@end
