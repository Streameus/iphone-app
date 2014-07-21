//
//  STEventTableViewCell.m
//  Streameus
//
//  Created by Anas Ait Ali on 19/06/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STEventTableViewCell.h"

@implementation STEventTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.content sizeToFit];
}

@end
