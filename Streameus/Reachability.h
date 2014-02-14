//
//  Reachability.h
//  Streameus
//
//  Created by Anas Ait Ali on 12/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reachability : NSObject

+ (BOOL) isConnected;
+ (BOOL) isOffline; // just the inverse of isConnected

@end
