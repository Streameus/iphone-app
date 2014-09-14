//
//  STSuggestionConfTableViewCell.h
//  Streameus
//
//  Created by Anas Ait Ali on 13/09/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSuggestionConfTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray *items;

@end
