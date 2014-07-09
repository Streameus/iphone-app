//
//  MMCellBackground.m
//  MonitorMe
//
//  Created by Anas Ait Ali on 08/10/13.
//  Copyright (c) 2013 s3450434s3450581. All rights reserved.
//

#import "MMCellBackground.h"

@implementation MMCellBackground

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* borderCellColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.75];
    UIColor* gradientColor = [UIColor colorWithRed: 0.988 green: 0.988 blue: 0.988 alpha: 1];
    UIColor* gradientColor2 = [UIColor colorWithRed: 0.961 green: 0.961 blue: 0.961 alpha: 1];
    UIColor* shadowColor4 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.3];
    
    //// Gradient Declarations
    NSArray* fondCellGris2Colors = [NSArray arrayWithObjects:
                                    (id)gradientColor.CGColor,
                                    (id)gradientColor2.CGColor, nil];
    CGFloat fondCellGris2Locations[] = {0, 1};
    CGGradientRef fondCellGris2 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)fondCellGris2Colors, fondCellGris2Locations);
    
    //// Shadow Declarations
    UIColor* ombre = shadowColor4;
    CGSize ombreOffset = CGSizeMake(0.1, -0.1);
    CGFloat ombreBlurRadius = 1.5;
    
    //// Frames
    CGRect frame = rect;
    
    
    //// CustomCell
    {
        //// Rounded Rectangle 2 Drawing
        CGRect roundedRectangle2Rect = CGRectMake(CGRectGetMinX(frame) + 5, CGRectGetMinY(frame) + 5, CGRectGetWidth(frame) - 10, CGRectGetHeight(frame) - 5);
        UIBezierPath* roundedRectangle2Path = [UIBezierPath bezierPathWithRoundedRect: roundedRectangle2Rect cornerRadius: 2];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, ombreOffset, ombreBlurRadius, ombre.CGColor);
        CGContextBeginTransparencyLayer(context, NULL);
        [roundedRectangle2Path addClip];
        CGContextDrawLinearGradient(context, fondCellGris2,
                                    CGPointMake(CGRectGetMidX(roundedRectangle2Rect), CGRectGetMinY(roundedRectangle2Rect)),
                                    CGPointMake(CGRectGetMidX(roundedRectangle2Rect), CGRectGetMaxY(roundedRectangle2Rect)),
                                    0);
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
        
        [borderCellColor setStroke];
        roundedRectangle2Path.lineWidth = 1;
        [roundedRectangle2Path stroke];
    }
    
    
    //// Cleanup
    CGGradientRelease(fondCellGris2);
    CGColorSpaceRelease(colorSpace);
    

}

@end
