//
//  STApiEvent.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 12/06/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STApiEvent.h"

@implementation STApiEvent

+ (NSString *)getContentString:(NSDictionary *)obj {
    NSString *content = [obj objectForKey:@"Content"];
    NSArray *items = [obj objectForKey:@"Items"];
    return [self replacePlaceholders:content withItems:items];
}

+ (NSString *)replacePlaceholders:(NSString *)content withItems:(NSArray *)items {
    NSString *result = [content copy];
    NSString *placeholder;
    for (int i = 0; i < [items count]; i++) {
        NSDictionary *it = [items objectAtIndex:i];
        placeholder = [NSString stringWithFormat:@"{%d}", i];
        result = [result stringByReplacingOccurrencesOfString:placeholder withString:[it objectForKey:@"Content"]];
    }
    return result;
}

@end
