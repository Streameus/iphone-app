//
//  STProfilAboutViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 08/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STProfilAboutViewController : UIViewController

@property (nonatomic, strong) NSDictionary *user;

@property (weak, nonatomic) IBOutlet UILabel *userInfos;

@end
