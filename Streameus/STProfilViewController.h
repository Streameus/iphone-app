//
//  STProfilViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STProfilViewController : UIViewController

@property (nonatomic, strong) NSDictionary *user;

@property (weak, nonatomic) IBOutlet UILabel *userInfosLabel;

@end
