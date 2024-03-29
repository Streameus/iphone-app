//
//  STAppDelegate.m
//  Streameus
//
//  Created by Anas Ait Ali on 15/01/2014.
//  Copyright (c) 2014 Streameus. All rights reserved.
//

#import "STAppDelegate.h"
#import "StreameusAPI/STApiConstants.h"
#import "FXBlurView.h"

@implementation STAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x203543)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UISearchBar appearance] setBarTintColor:UIColorFromRGB(0x203543)];
    [[UISearchBar appearance] setTintColor:UIColorFromRGB(0xEFEFEF)];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = UIColorFromRGBandAlpha(0xE1E1E1, 0.5);
    pageControl.currentPageIndicatorTintColor = UIColorFromRGBandAlpha(0xFEFEFE, 0.8);
    pageControl.backgroundColor = [UIColor clearColor];
    
//    [self.window setBackgroundColor:UIColorFromRGB(0xFAF3D5)];
    [self.window setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"night-cafe_iphone5"] blurredImageWithRadius:80 iterations:2 tintColor:[UIColor colorWithRed:246/255 green:241/255 blue:211/255 alpha:1]]]];
    
    [[StreameusAPI sharedInstance] initializeWithBaseUrl:kSTStreameusAPIURL];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
