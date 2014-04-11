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
    // @TODO : Make everything async below and under the same nsoperation queue
    StreameusAPI *api = [StreameusAPI sharedInstance];
    BOOL success = false;
    
    NSLog(@"access_token : \n%@", accessToken);
    [self setAccessToken:accessToken];
    [self setTokenType:tokenType];
    
    NSURLRequest *userInfoRequest = [api createUrlController:@"account/userinfo" withVerb:GET];
    NSURLResponse *response;
    NSError *error;
    NSData *userInfoData = [NSURLConnection sendSynchronousRequest:userInfoRequest
                                         returningResponse:&response
                                                     error:&error];
    if (error || [(NSHTTPURLResponse *)response statusCode] != 200 || !userInfoData) {
        [[[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                    message:[error localizedFailureReason]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    } else {
        NSDictionary *userInfoJson = [NSJSONSerialization JSONObjectWithData:userInfoData options:0 error:nil];
        NSLog(@"UserInfo :\n %@", userInfoJson);
        if (![[userInfoJson objectForKey:@"HasRegistered"] boolValue]) {
            NSLog(@"User not registered");
            // @FIXME : Fake email temporaire sinon ca passe pas l'API
            NSData *jsonBody = [NSJSONSerialization dataWithJSONObject:@{@"UserName": [userInfoJson objectForKey:@"UserName"],
                                                                         @"Email" : [NSString stringWithFormat:@"streameus%@@yopmail.com", [[userInfoJson objectForKey:@"UserName"] stringByReplacingOccurrencesOfString:@" " withString:@""]]}
                                                               options:0
                                                                 error:nil];
            NSString *jsonStringBody = [[NSString alloc] initWithData:jsonBody encoding:NSUTF8StringEncoding];
            NSLog(@"jsonString : \n%@", jsonStringBody);
            NSURLRequest *registerRequest = [api createUrlController:@"account/registerexternal" withVerb:POST args:nil andBody:jsonStringBody];
            response = nil;
            error = nil;
            NSData *registerData = [NSURLConnection sendSynchronousRequest:registerRequest
                                                         returningResponse:&response
                                                                     error:&error];
            if ([(NSHTTPURLResponse *)response statusCode] != 200 || !registerData) {
                NSDictionary *registerErrorJson = [NSJSONSerialization JSONObjectWithData:registerData options:0 error:nil];
                if (error && !registerData) {
                    [[[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                message:[error localizedFailureReason]
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                      otherButtonTitles:nil] show];
                } else {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                message:[registerErrorJson objectForKey:@"Message"]
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                      otherButtonTitles:nil] show];
                    NSLog(@"registerJson :\n %@", registerErrorJson);
                }
            } else {
                NSLog(@"RegisterExternal : %@", [NSJSONSerialization JSONObjectWithData:registerData options:0 error:nil]);
                NSData *tmpData = [NSURLConnection sendSynchronousRequest:userInfoRequest
                                                             returningResponse:&response
                                                                         error:&error];
                NSLog(@"userInfo : %@", [NSJSONSerialization JSONObjectWithData:tmpData options:0 error:nil]);
                success = true;
            }
        } else {
            NSLog(@"User already registered");
            success = true;
        }
    }
    block(success);
}

@end
