//
//  STProfilViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface STProfilViewController : UIViewController

@property (nonatomic, strong) NSDictionary *user;

@property (weak, nonatomic) IBOutlet UILabel *pseudoLabel;
@property (weak, nonatomic) IBOutlet AsyncImageView *profilPicture;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *followActivityIndicator;

- (void)follow;
- (void)unFollow;
- (void)updateFollowBtn;
- (void)loadProfilPicture:(NSString *)userId;

@end
