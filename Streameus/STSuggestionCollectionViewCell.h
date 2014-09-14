//
//  STSuggestionCollectionViewCell.h
//  Streameus
//
//  Created by Anas Ait Ali on 21/07/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface STSuggestionCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *data;

@property (weak, nonatomic) IBOutlet AsyncImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end
