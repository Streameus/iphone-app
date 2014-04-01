//
//  STApiResource.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 29/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STApiResource.h"

@implementation STApiResource

#pragma mark - get url

+ (NSURLRequest *)urlGetAbout {
    return [[StreameusAPI sharedInstance] createUrlController:@"resource/about" withVerb:GET];
}

+ (NSURLRequest *)urlGetTeam {
    return [[StreameusAPI sharedInstance] createUrlController:@"resource/team" withVerb:GET];
}

+ (NSURLRequest *)urlGetFaq {
    return [[StreameusAPI sharedInstance] createUrlController:@"resource/faq" withVerb:GET];
}

#pragma mark - get url content

+ (void)getAllResource
{
    StreameusAPI *api = [StreameusAPI sharedInstance];
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection
                    sendSynchronousRequest:[[StreameusAPI sharedInstance] createUrlController:@"resource" withVerb:GET]
                    returningResponse:&response
                    error:&error];
    if (error || [(NSHTTPURLResponse *)response statusCode] != 200 || !data) {
        return;
    }
    NSDictionary *JSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [api setAboutUrl:[NSURL URLWithString:[JSONData objectForKey:@"about"]]];
    [api setFaqUrl:[NSURL URLWithString:[JSONData objectForKey:@"faq"]]];
    [api setTeamUrl:[NSURL URLWithString:[JSONData objectForKey:@"team"]]];
}

+ (NSURLRequest *)getAbout {
    StreameusAPI *api = [StreameusAPI sharedInstance];
    if (![api aboutUrl]) {
        [self getAllResource];
    }
    return [NSURLRequest requestWithURL:[api aboutUrl]];
}

+ (NSURLRequest *)getTeam {
    StreameusAPI *api = [StreameusAPI sharedInstance];
    if (![api teamUrl]) {
        [self getAllResource];
    }
    return [NSURLRequest requestWithURL:[api teamUrl]];
}

+(NSURLRequest *)getFaq {
    StreameusAPI *api = [StreameusAPI sharedInstance];
    if (![api faqUrl]) {
        [self getAllResource];
    }
    return [NSURLRequest requestWithURL:[api faqUrl]];
}

+ (NSURLRequest *)getAboutWithReturningResponse:(NSURLResponse *__autoreleasing *)response error:(NSError *__autoreleasing *)error{
    NSData *data = [NSURLConnection sendSynchronousRequest:[self urlGetAbout]
                          returningResponse:response
                                      error:error];
    if (*error || [(NSHTTPURLResponse *)*response statusCode] != 200 || !data) {
        return nil;
    }
    NSString *urlString = [[NSString stringWithUTF8String:[data bytes]]
                           stringByReplacingOccurrencesOfString:@"\""
                           withString:@""];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

+ (NSURLRequest *)getTeamWithReturningResponse:(NSURLResponse *__autoreleasing *)response error:(NSError *__autoreleasing *)error {
    NSData *data = [NSURLConnection sendSynchronousRequest:[self urlGetTeam]
                                         returningResponse:response
                                                     error:error];
    if (*error || [(NSHTTPURLResponse *)*response statusCode] != 200 || !data) {
        return nil;
    }
    NSString *urlString = [[NSString stringWithUTF8String:[data bytes]]
                           stringByReplacingOccurrencesOfString:@"\""
                           withString:@""];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

+ (NSURLRequest *)getFaqWithReturningResponse:(NSURLResponse *__autoreleasing *)response error:(NSError *__autoreleasing *)error {
    NSData *data = [NSURLConnection sendSynchronousRequest:[self urlGetFaq]
                                         returningResponse:response
                                                     error:error];
    if (*error || [(NSHTTPURLResponse *)*response statusCode] != 200 || !data) {
        return nil;
    }
    NSString *urlString = [[NSString stringWithUTF8String:[data bytes]]
                           stringByReplacingOccurrencesOfString:@"\""
                           withString:@""];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}


@end
