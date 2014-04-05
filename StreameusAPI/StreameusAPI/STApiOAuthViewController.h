//
//  STApiOAuthViewController.h
//  StreameusAPI
//
//  Created by Anas Ait Ali on 04/04/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STApiOAuthViewController : UIViewController <UIWebViewDelegate> {
@private
    UIWebView *_webview;
    UIActivityIndicatorView *_spinner;
    NSString *_url;
    UIBarButtonItem *_backBtn;
    UIBarButtonItem *_forwardBtn;
    void (^ _block)(NSString *accessToken, NSString *tokenType);
}

- (void)updateButtons;
- (void)goBackPage;
- (void)goForwardPage;
- (void)close;

- (id)initWithUrlString:(NSString *)url completionHandler:(void (^)(NSString * accessToken, NSString *tokenType))block;

+ (void)clearCookies;

@end
