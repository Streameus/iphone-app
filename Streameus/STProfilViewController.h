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
@property (weak, nonatomic) IBOutlet UIImageView *tmpIBBackground;

@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSString *userId;

@property (weak, nonatomic) IBOutlet UILabel *pseudoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pseudoLabelSubtitle;
@property (weak, nonatomic) IBOutlet AsyncImageView *profilPicture;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *followActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *conferencesButton;

- (void)follow;
- (void)unFollow;
- (void)updateFollowBtn;
- (void)loadProfilPicture:(NSString *)userId;

@end
