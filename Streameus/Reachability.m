//
//  Reachability.m
//  Streameus
//
//  Created by Anas Ait Ali on 12/02/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "Reachability.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation Reachability

+ (BOOL) isOffline {
	return ![self isConnected];
}

+ (BOOL) isConnected {
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
	
	if(reachability != NULL) {
		//NetworkStatus retVal = NotReachable;
		SCNetworkReachabilityFlags flags;
		
		if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
			
			BOOL isConnected = NO;
			
			if (0 == (flags & kSCNetworkReachabilityFlagsReachable)) {
				// if target host is not reachable
				isConnected = NO;
			} else if (0 == (flags & kSCNetworkReachabilityFlagsConnectionRequired)) {
				// if target host is reachable and no connection is required
				//  then we'll assume (for now) that your on Wi-Fi
				isConnected = YES;
			} else if ( (0 != (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ) ||
                       (0 != (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ) ) {
				// ... and the connection is on-demand (or on-traffic) if the
				//     calling application is using the CFSocketStream or higher APIs
				
				if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
					// ... and no [user] intervention is needed
					isConnected = YES;
				}
			} else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
				// ... but WWAN connections are OK if the calling application
				//     is using the CFNetwork (CFSocketStream?) APIs.
				isConnected = YES;
			}
			
			CFRelease(reachability);
			return isConnected;
		}
		
	}
	return NO;
}

@end
