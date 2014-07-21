//
//  NSString+Common.m
//  StreameusAPI
//
//  Created by Anas Ait Ali on 09/07/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

- (NSString *)dateFromApi {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[self componentsSeparatedByString:@"."][0]];   
    NSDateFormatter *finalDate = [[NSDateFormatter alloc] init];
    [finalDate setDateFormat:NSLocalizedString(@"E d 'at' HH:mm", @"date")];
    return [finalDate stringFromDate:date];
}

- (NSString *)dateFromApiDay {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[self componentsSeparatedByString:@"."][0]];
    NSDateFormatter *finalDate = [[NSDateFormatter alloc] init];
    [finalDate setDateFormat:NSLocalizedString(@"EEEE d Y", @"date")];
    return [finalDate stringFromDate:date];
}

@end
