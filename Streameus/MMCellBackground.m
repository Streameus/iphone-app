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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 1];
    CGFloat fillColorRGBA[4];
    [fillColor getRed: &fillColorRGBA[0] green: &fillColorRGBA[1] blue: &fillColorRGBA[2] alpha: &fillColorRGBA[3]];
    
    UIColor* grisClair = [UIColor colorWithRed: (fillColorRGBA[0] * 0.1 + 0.9) green: (fillColorRGBA[1] * 0.1 + 0.9) blue: (fillColorRGBA[2] * 0.1 + 0.9) alpha: (fillColorRGBA[3] * 0.1 + 0.5)];
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.1];
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.5];
    UIColor* shadowColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.319];
    
    //// Shadow Declarations
    UIColor* shadow = strokeColor;
    CGSize shadowOffset = CGSizeMake(0.1, -0.1);
    CGFloat shadowBlurRadius = 5;
    UIColor* shadow2 = shadowColor2;
    CGSize shadow2Offset = CGSizeMake(0.1, -0.1);
    CGFloat shadow2BlurRadius = 1;
    
    //// Frames
    CGRect frame = rect;
    
    
    //// Group
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 10, CGRectGetMinY(frame) + 5, CGRectGetWidth(frame) - 20, CGRectGetHeight(frame) - 5) cornerRadius: 1];
        [grisClair setFill];
        [rectanglePath fill];
        [fillColor setStroke];
        rectanglePath.lineWidth = 0.5;
        [rectanglePath stroke];
        
        
        //// Rectangle interne Drawing
        UIBezierPath* rectangleInternePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 15, CGRectGetMinY(frame) + 10, CGRectGetWidth(frame) - 30, CGRectGetHeight(frame) - 15) cornerRadius: 1];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2.CGColor);
        [color setFill];
        [rectangleInternePath fill];
        
        ////// Rectangle interne Inner Shadow
        CGRect rectangleInterneBorderRect = CGRectInset([rectangleInternePath bounds], -shadowBlurRadius, -shadowBlurRadius);
        rectangleInterneBorderRect = CGRectOffset(rectangleInterneBorderRect, -shadowOffset.width, -shadowOffset.height);
        rectangleInterneBorderRect = CGRectInset(CGRectUnion(rectangleInterneBorderRect, [rectangleInternePath bounds]), -1, -1);
        
        UIBezierPath* rectangleInterneNegativePath = [UIBezierPath bezierPathWithRect: rectangleInterneBorderRect];
        [rectangleInterneNegativePath appendPath: rectangleInternePath];
        rectangleInterneNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = shadowOffset.width + round(rectangleInterneBorderRect.size.width);
            CGFloat yOffset = shadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        shadowBlurRadius,
                                        shadow.CGColor);
            
            [rectangleInternePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleInterneBorderRect.size.width), 0);
            [rectangleInterneNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [rectangleInterneNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
    }
    

}

@end
