//
//  STApiUser.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 29/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STApiUser.h"

@implementation STApiUser

+ (NSURLRequest *)urlGetUser {
    return [[StreameusAPI sharedInstance] createUrlController:@"user" withVerb:GET];
}

+ (void)getUserWithCompletionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler {
    [NSURLConnection sendAsynchronousRequest:[self urlGetUser]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];
}

@end
