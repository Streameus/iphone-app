//
//  STUtilities.m
//  Streameus
//
//  Created by Anas Ait Ali on 12/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STUtilities.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#pragma mark - MD5

NSString *MMMD5FromString(NSString *string) {
	const char *cStr = [string UTF8String];
	unsigned char result[16];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

#pragma mark - URL Escaped Strings

NSString *MMEscapedURLString(NSString *string) {
	return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

NSString *MMEscapedURLStringPlus(NSString *string) {
	CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, (CFStringRef)@"`~!@#$^&*()=+[]\\{}|;':\",/<>?", kCFStringEncodingUTF8);
	return (__bridge_transfer NSString *)escaped;
}
