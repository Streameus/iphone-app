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
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) NSString *url;
@end

@implementation STApiOAuthViewController

- (id)initWithUrlString:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //@TODO : add navigation bar btn to close
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    [self.webview setBackgroundColor:[UIColor clearColor]];
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    [self.view addSubview:self.webview];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webview loadRequest:request];
}

#pragma mark - Web view delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestURLString = request.URL.absoluteString;
    
    NSLog(@"HTTPMethod: %@\n", request.HTTPMethod);
    NSLog(@"Fields: %@\n", [request.allHTTPHeaderFields description]);
    NSLog(@"URL: %@\n\n\n", request.URL.absoluteString);
    if([requestURLString rangeOfString:[NSString stringWithFormat:@"http://%@/#access_token", kSTStreameusAPIDomain]].location == 0){
		NSString *URLString = [[request URL] absoluteString];
        NSLog(@"url string = %@", URLString);
        [self dismissViewControllerAnimated:YES completion:nil];
	}
	return YES;
}

@end
