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
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *tokenType;

- (BOOL)externalLogins;
- (NSString *)getProviderUrl:(NSString *)provider;
- (void)connectUser:(NSString *)accessToken andTokenType:(NSString *)tokenType completionHandler:(void (^)(BOOL success))block;

@end
