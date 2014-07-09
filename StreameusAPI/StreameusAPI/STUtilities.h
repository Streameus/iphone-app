//
//  STUtilities.h
//  Streameus
//
//  Created by Anas Ait Ali on 12/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - MD5

NSString *MMMD5FromString(NSString *string);

#pragma mark - URL Escaped Strings

NSString *MMEscapedURLString(NSString *string);
NSString *MMEscapedURLStringPlus(NSString *string);