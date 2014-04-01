//
//  STApiResource.h
//  StreameusAPI
//
//  Created by Anas Ait Ali on 29/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STApiResource : NSObject

+ (NSURLRequest *)urlGetAbout;
+ (NSURLRequest *)urlGetTeam;
+ (NSURLRequest *)urlGetFaq;

+ (void)getAllResource;
+ (NSURLRequest *)getAbout;
+ (NSURLRequest *)getTeam;
+ (NSURLRequest *)getFaq;
+ (NSURLRequest *)getAboutWithReturningResponse:(NSURLResponse **)response error:(NSError **)error;
+ (NSURLRequest *)getTeamWithReturningResponse:(NSURLResponse **)response error:(NSError **)error;
+ (NSURLRequest *)getFaqWithReturningResponse:(NSURLResponse **)response error:(NSError **)error;

@end
