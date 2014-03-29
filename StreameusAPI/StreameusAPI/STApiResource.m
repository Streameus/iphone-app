//
//  STApiResource.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 29/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STApiResource.h"

@implementation STApiResource

+ (NSURLRequest *)urlGetAbout {
    return [[StreameusAPI sharedInstance] createUrlController:@"resource/about" withVerb:GET];
}

+ (NSURLRequest *)getAboutWithReturningResponse:(NSURLResponse **)response error:(NSError **)error {
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

@end
