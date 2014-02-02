//
//  STIntroViewController.m
//  Streameus
//
//  Created by Anas Ait Ali on 02/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STIntroViewController.h"

@interface STIntroViewController ()

@end

@implementation STIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.indexLabel setText:[NSString stringWithFormat:@"PAGE NUMERO %ld", (long)self.index]];
    switch (self.index) {
        case 0:
            [self.view setBackgroundColor:UIColorFromRGBandAlpha(0x273d4e, 0.6)];
            break;
        case 1:
            [self.view setBackgroundColor:UIColorFromRGBandAlpha(0x66bbd7, 0.6)];
            break;
        case 2:
            [self.view setBackgroundColor:UIColorFromRGBandAlpha(0xFAF3D5, 0.6)];
            break;
        case 3:
            [self.view setBackgroundColor:UIColorFromRGBandAlpha(0xee4d59, 0.6)];
            break;
        default:
            [self.view setBackgroundColor:[UIColor clearColor]];
            break;
    }
}

@end
