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
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
