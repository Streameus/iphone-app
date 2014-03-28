//
//  STApiUser.h
//  StreameusAPI
//
//  Created by Anas Ait Ali on 29/03/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STApiUser : NSObject

+ (NSURLRequest *)urlGetUser;
+ (void)getUserWithCompletionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError)) handler;

@end
