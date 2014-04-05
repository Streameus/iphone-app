//
//  STLoginViewController.h
//  Streameus
//
//  Created by Anas Ait Ali on 01/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STLoginViewController : UIViewController

- (IBAction)connectOAuth:(id)sender;
- (void)loadNextViewOnSuccess:(BOOL)success;

@end
