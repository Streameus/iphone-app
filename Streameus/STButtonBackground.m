//
//  STButtonBackground.m
//  Streameus
//
//  Created by Anas Ait Ali on 26/08/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STButtonBackground.h"

@implementation STButtonBackground
@synthesize cornerRadius = _cornerRadius, color = _color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = [UIColor colorWithRed: 0.743 green: 0.939 blue: 0 alpha: 1];
        _cornerRadius = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// Frames
    CGRect frame = rect;
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:_cornerRadius];
    [_color setFill];
    [roundedRectanglePath fill];
}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

@end
