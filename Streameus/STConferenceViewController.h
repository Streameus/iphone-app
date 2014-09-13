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
@property (weak, nonatomic) IBOutlet UITextView *Description;
@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;
@property (weak, nonatomic) IBOutlet UIButton *participantsBtn;
@property (weak, nonatomic) IBOutlet UIButton *categorieBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingParticipants;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityRegisteredIndicator;

@property (nonatomic, strong) NSArray *participants;

- (void)getParticipantsFromConferenceWithId:(NSString *)confId;
- (void)didFetchParticipants:(NSArray *)items;
- (void)subscribe;
- (void)unsubscribe;
- (void)updateSubscribe:(BOOL)registered;

@end
