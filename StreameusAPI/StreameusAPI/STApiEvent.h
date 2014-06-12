//
//  STApiEvent.h
//  StreameusAPI
//
//  Created by Anas Ait Ali on 12/06/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STApiEvent : NSObject

+ (NSString *)getContentString:(NSDictionary *)obj;
+ (NSString *)replacePlaceholders:(NSString *)content withItems:(NSArray *)items;

@end
