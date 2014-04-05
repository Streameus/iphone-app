//
//  STApiOAuthViewController.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 04/04/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STApiOAuthViewController.h"
#import "STApiConstants.h"

@interface STApiOAuthViewController ()
@end

@implementation STApiOAuthViewController

- (id)initWithUrlString:(NSString *)url completionHandler:(void (^)(NSString *, NSString *))block{
    self = [super init];
    if (self) {
        _url = url;
        _block = block;
    }
    return self;
}

- (void)updateButtons {
    _backBtn.enabled = _webview.canGoBack;
    _forwardBtn.enabled = _webview.canGoForward;
}

- (void)goBackPage {
    if (_webview.canGoBack) {
        [_webview goBack];
    }
}

- (void)goForwardPage {
    if (_webview.canGoForward) {
        [_webview goForward];
    }
}

- (void)close {
    if (![[self presentedViewController] isBeingDismissed])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - View lifecycle

- (void)loadView {
    _webview = [[UIWebView alloc] init];
    _webview.delegate = self;
    _webview.scalesPageToFit = YES;
    self.view = _webview;
    
    self.title = NSLocalizedString(@"Sign-in", @"Sign-in OAuth navigation bar title");
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    
    _backBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBackPage)];
    _backBtn.enabled = false;
    
    _forwardBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForwardPage)];
    _forwardBtn.enabled = false;
    
    UIBarButtonItem *spinner = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:_backBtn, _forwardBtn, spinner, nil];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:cancel, nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webview loadRequest:request];
}

#pragma mark - Web view delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestURLString = request.URL.absoluteString;
    
//    NSLog(@"URL: %@\n\n\n", request.URL.absoluteString);
    if([requestURLString rangeOfString:[NSString stringWithFormat:@"%@/#access_token", kSTStreameusAPIDomain]].length > 0){
        NSDictionary *params = [self queryStringForUrl:request.URL];
//        NSLog(@"queryParams = \n%@", params);
        NSString *access_token = [params objectForKey:@"access_token"];
        NSString *token_type = [params objectForKey:@"token_type"];
        [self dismissViewControllerAnimated:YES completion:^{
            _block(access_token, token_type);
        }];
        return NO;
	}
    
    [_spinner startAnimating];
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateButtons];
    [_spinner stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateButtons];
}

- (NSDictionary*)queryStringForUrl:(NSURL*)URL
{
    NSString *queryString = [URL query] ?: [URL fragment];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *parameters = [queryString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters) {
        NSArray *parts = [parameter componentsSeparatedByString:@"="];
        NSString *key = [[parts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([parts count] > 1) {
            id value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [result setObject:value forKey:key];
        }
    }
    return result;
}

+ (void)clearCookies
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

@end
