//
//  UIButton+Streameus.h
//  Streameus
//
//  Created by Anas Ait Ali on 14/09/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (Streameus)

-(void)bootstrapStyle;
-(void)defaultStyle;
-(void)primaryStyle;
-(void)successStyle;
-(void)infoStyle;
-(void)warningStyle;
-(void)dangerStyle;
- (UIImage *) buttonImageFromColor:(UIColor *)color;
    
@end
