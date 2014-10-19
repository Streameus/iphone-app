//
//  STRightMenuBarButton.m
//  Streameus
//
//  Created by Anas Ait Ali on 10/19/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STRightMenuBarButton.h"

@implementation STRightMenuBarButton

+ (UIBarButtonItem *)menuBarItemTarget:(id)target action:(SEL)action {
    UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:target action:action];    
    return revealBtn;
}

@end
