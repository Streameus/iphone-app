//
//  StreameusAPI.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 28/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "StreameusAPI.h"
#import "STUtilities.h"

@interface StreameusAPI ()
@property (nonatomic, strong, readwrite) NSString *baseUrl;
@end

@implementation StreameusAPI

+ (StreameusAPI *)sharedInstance {
    static dispatch_once_t onceToken;
    static StreameusAPI *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.baseUrl = nil;
    }
    return self;
}

#pragma mark -

- (void)initializeWithBaseUrl:(NSString *)baseUrl {
    self.baseUrl = baseUrl;
}

- (NSURLRequest *)createUrlController:(NSString *)controller withVerb:(STHttpVerbs)verb {
    return [self createUrlController:controller withVerb:verb args:nil];
}

- (NSURLRequest *)createUrlController:(NSString *)controller withVerb:(STHttpVerbs)verb args:(NSDictionary *)args {
    return [self createUrlController:controller withVerb:verb args:args andBody:nil];
}

- (NSURLRequest *)createUrlController:(NSString *)controller withVerb:(STHttpVerbs)verb args:(NSDictionary *)args andBody:(NSString *)body {
    NSAssert(self.baseUrl, @"You must initialize with a base url");
    NSString *urlAsString = [NSString stringWithFormat:@"http://%@/%@", self.baseUrl, controller];
    
    if (args != nil && [args count] > 1) {
        NSMutableArray *argArray = [NSMutableArray array];
        for (NSString *key in args) {
            [argArray addObject:[NSString stringWithFormat:@"%@=%@", key, MMEscapedURLString(args[key])]];
        }
        NSArray *sortedArgArray = [argArray sortedArrayUsingSelector:@selector(compare:)];
        NSString *queryParams = [sortedArgArray componentsJoinedByString:@"&"];
        urlAsString = [[urlAsString stringByAppendingString:@"?"] stringByAppendingString:queryParams];
    }
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    NSString *httpverb;
    switch (verb) {
        case GET:
            httpverb = @"GET";
            break;
        case POST:
            httpverb = @"POST";
            break;
        case PUT:
            httpverb = @"PUT";
            break;
        case DELETE:
            httpverb = @"DELETE";
            break;
        case OPTIONS:
            httpverb = @"OPTIONS";
            break;
        case HEAD:
            httpverb = @"HEAD";
            break;
        default:
            httpverb = @"GET";
            break;
    }
    [urlRequest setHTTPMethod:httpverb];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    return urlRequest;
}

@end
