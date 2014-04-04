//
//  STApiAccount.h
//  StreameusAPI
//
//  Created by Anas Ait Ali on 04/04/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STApiAccount : NSObject

@property (nonatomic, strong, readonly) NSDictionary *providers;

- (BOOL)externalLogins;
- (NSString *)getProviderUrl:(NSString *)provider;

@end
