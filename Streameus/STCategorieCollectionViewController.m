//
//  STCategorieCollectionViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 30/11/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STCategorieCollectionViewController.h"
#import "AWCollectionViewDialLayout.h"
#import "SWRevealViewController.h"
#import "STConferenceTableViewController.h"
#import "FXBlurView.h"

@interface STCategorieCollectionViewController () <STCategorieRepositoryDelegate>

@property (nonatomic, strong) STCategorieRepository *repository;

@end

@implementation STCategorieCollectionViewController {
    AWCollectionViewDialLayout *dialLayout;
}

static NSString * const reuseIdentifier = @"categorieCollectionCell";

- (void)configureWithRepository:(STCategorieRepository *)repository {
    self.repository = repository;
    self.repository.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =  NSLocalizedString(@"Categories", @"Browse categories title");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"night-cafe_iphone5"] blurredImageWithRadius:80 iterations:2 tintColor:[UIColor colorWithRed:246/255 green:241/255 blue:211/255 alpha:1]]]];
    
    self.navigationItem.leftBarButtonItem = [STLeftMenuBarButton menuBarItemTarget:self.revealViewController action:@selector(revealToggle:)];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.refreshControl = nil;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.collectionView addSubview:self.refreshControl];
    
    dialLayout = [[AWCollectionViewDialLayout alloc] initWithRadius:350.0  andAngularSpacing:18.0 andCellSize:CGSizeMake(300, 100) andAlignment:WHEELALIGNMENTCENTER andItemHeight:100  andXOffset:150];
    [self.collectionView setCollectionViewLayout:dialLayout];
    self.collectionView.alwaysBounceVertical = YES;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.animationType = MBProgressHUDAnimationZoomIn;
    [self.repository fetch];

}

- (void)didFetch:(NSArray *)items {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.collectionView reloadData];
}

- (void)refresh {
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self.repository fetch];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"categorieToConferenceListSegue"]) {
        STConferenceRepository *repo = [[STConferenceRepository alloc] init];
        [repo setCategorieId:[[(NSDictionary *)sender objectForKey:@"Id"] intValue]];
        STConferenceTableViewController *dest = (STConferenceTableViewController *)segue.destinationViewController;
        [dest configureWithRepository:repo];
        [dest setCategorieName:[sender objectForKey:@"Name"]];
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.repository.items count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = [self.repository.items objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/picture/category/%@", [[StreameusAPI sharedInstance] baseUrl], [item objectForKey:@"Id"]]];
    AsyncImageView *imgView = (AsyncImageView*)[cell viewWithTag:100];
    [imgView setImageURL:url];
    imgView.layer.cornerRadius = imgView.frame.size.width / 2;
    imgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:101];
    [textLabel setText:[item objectForKey:@"Name"]];
    UILabel *detailTextLabel = (UILabel *)[cell viewWithTag:102];
    [detailTextLabel setText:[item objectForKey:@"Description"]];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self.repository.items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"categorieToConferenceListSegue" sender:item];
}

@end
