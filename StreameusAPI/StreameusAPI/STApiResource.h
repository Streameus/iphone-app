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
//+ (NSURLRequest *)urlGetFaq;
//+ (NSURLRequest *)urlGetTeam;
+ (NSURLRequest *)getAboutWithReturningResponse:(NSURLResponse **)response error:(NSError **)error;
//+ (NSData *)getFaqWithReturningResponse:(NSURLResponse **)response error:(NSError **)error;
//+ (NSData *)getTeamWithReturningResponse:(NSURLResponse **)response error:(NSError **)error;

@end
