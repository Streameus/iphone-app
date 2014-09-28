//
//  STLeftMenuBarButton.m
//  Streameus
//
//  Created by Anas Ait Ali on 9/28/14.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STLeftMenuBarButton.h"

@implementation STLeftMenuBarButton

+ (UIBarButtonItem *)menuBarItemTarget:(id)target action:(SEL)action {
    UIBarButtonItem *revealBtn = [[UIBarButtonItem alloc]
                                  initWithImage:[UIImage imageNamed:@"menu_icon"]
                                  style:UIBarButtonItemStylePlain
                                  target:target
                                  action:action];
    return revealBtn;
}

@end
