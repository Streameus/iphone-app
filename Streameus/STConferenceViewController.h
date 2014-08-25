//
//  STConferenceViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 24/08/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STConferenceViewController : UIViewController

@property (nonatomic, strong) NSDictionary *conference;

@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet AsyncImageView *Picture;
@property (weak, nonatomic) IBOutlet AsyncImageView *OwnerPicture;
@property (weak, nonatomic) IBOutlet UILabel *Status;
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UITextView *Description;

@end
