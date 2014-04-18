//
//  STApiAccount.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 04/04/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STApiAccount.h"
#import "STApiOAuthViewController.h"
#import "STApiConstants.h"

@interface STApiAccount ()
@property (nonatomic, strong, readwrite) NSDictionary *providers;
@end

@implementation STApiAccount

- (id)init {
    self = [super init];
    if (self) {
        self.accessToken = nil;
        self.tokenType = nil;
    }
    return self;
}

- (BOOL)externalLogins {
    NSURLRequest *resquest = [[StreameusAPI sharedInstance] createUrlController:@"account/externallogins" withVerb:GET args:@{@"returnUrl": @"/", @"generateState" : @"true"}];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:resquest returningResponse:&response error:&error];
    if (error || [(NSHTTPURLResponse *)response statusCode] != 200 || !data) {
        return false;
    }
    NSArray *JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *it in JSONData) {
        [dict setObject:it forKey:[it objectForKey:@"Name"]];
    }
    self.providers = dict;
    return true;
}

- (NSString *)getProviderUrl:(NSString *)provider {
    [self externalLogins];
    NSString *urlpart = [[self.providers objectForKey:provider] objectForKey:@"Url"];
    return [NSString stringWithFormat:@"http://%@/%@", kSTStreameusAPIDomain, urlpart];
}

- (void)connectUser:(NSString *)accessToken andTokenType:(NSString *)tokenType completionHandler:(void (^)(BOOL))block{
    NSLog(@"access_token : \n%@", accessToken);
    [self setAccessToken:accessToken];
    [self setTokenType:tokenType];
    block(true);
}

@end
