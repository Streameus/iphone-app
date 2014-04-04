//
//  STApiOAuthViewController.h
//  StreameusAPI
//
//  Created by Anas Ait Ali on 04/04/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STApiOAuthViewController : UIViewController <UIWebViewDelegate>

- (id)initWithUrlString:(NSString *)url;

@end
