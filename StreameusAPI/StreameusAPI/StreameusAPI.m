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
        self.account = [[STApiAccount alloc] init];
        self.baseUrl = nil;
        self.aboutUrl = nil;
        self.faqUrl = nil;
        self.teamUrl = nil;
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
    // @TODO : Remplacer tous les http par une variable
    NSString *urlAsString = [NSString stringWithFormat:@"http://%@/%@", self.baseUrl, controller];
    
    if (args != nil && [args count] > 0) {
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
    if ([self.account accessToken] && [self.account tokenType]) {
        [urlRequest addValue:[NSString stringWithFormat:@"%@ %@", [self.account tokenType], [self.account accessToken]] forHTTPHeaderField:@"Authorization"];
    }
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:httpverb];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    return urlRequest;
}

- (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue*)queue
                         before:(void (^)()) before
                        success:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError, id Json)) success
                        failure:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError, id Json)) failure
                        after:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError, id Json)) after {
    
    if (!queue) {
        queue = [NSOperationQueue mainQueue];
    }
    if (before) {
        before();
    }
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id jsonResult;
        NSHTTPURLResponse *responseStatus = (NSHTTPURLResponse *)response;
        NSLog(@"\nCODE : %ld\nURL : [%@]%@\nREQUEST BODY:%@", (long)responseStatus.statusCode, request.HTTPMethod, request.URL, [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
        if ([data length] > 0) {
            jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        if ([data length] > 0 && connectionError == nil) {
            NSLog(@"RESPONSE : \n%@", jsonResult);
            if (responseStatus.statusCode >= 200 && responseStatus.statusCode <= 300) {
                success(response, data, connectionError, jsonResult);
            } else {
                failure(response, data, connectionError, jsonResult);
            }
        } else if ([data length] == 0 && connectionError == nil) {
            NSLog(@"Nothing was downloaded");
            success(response, data, connectionError, jsonResult);
        } else if (connectionError != nil) {
            if ([data length] > 0) {
                failure(response, data, connectionError, jsonResult);
            } else {
                failure(response, data, connectionError, nil);
            }
        }
        if (data.length > 0) {
            after(response, data, connectionError, jsonResult);
        } else {
            after(response, data, connectionError, nil);
        }
    }];
}

@end
