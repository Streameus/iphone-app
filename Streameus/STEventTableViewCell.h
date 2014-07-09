//
//  STEventTableViewCell.h
//  Streameus
//
//  Created by Anas Ait Ali on 19/06/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface STEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet AsyncImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *date;


@end
