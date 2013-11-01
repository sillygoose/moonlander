//
//  MoonlanderAppDelegate.m
//  Moonlander
//
//  Created by Rick on 5/10/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import "MoonlanderAppDelegate.h"

@implementation MoonlanderAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
#if 0
    // Set default font, size, and color for navigation bar items
    CGFloat fontSize = 24;
    const CGFloat DefaultRed = 0.026;
    const CGFloat DefaultGreen = 1.0;
    const CGFloat DefaultBlue = 0.00121;
    const CGFloat DefaultAlpha = 1.0;
    UIColor *moonlanderColor = [[UIColor alloc] initWithRed:DefaultRed green:DefaultGreen blue:DefaultBlue alpha:DefaultAlpha];
    UIFont *displayFont = [UIFont fontWithName:@"Vector Battle" size:fontSize];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName:moonlanderColor,
       NSFontAttributeName:displayFont
       } forState:UIControlStateNormal];
    
    // Set default font, size, and color for navigation titles
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName:moonlanderColor,
       NSFontAttributeName:displayFont
       }];
#endif
    
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    // TeamFlight registration
    [TestFlight takeOff:@"93c8cc3f61a45f39e4d60a044f9f5f44_OTQzMTIyMDEyLTA1LTI4IDEwOjI5OjA1LjExMzk3NA"];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an incoming phone call
    // or SMS message) or when the user quits the application and it begins the transition to the
    // background state.
    //
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
    // Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough application state information to restore your application to its
    // current state in case it is terminated later.
    //
    // If your application supports background execution, this method is called instead
    // of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate.
    // Save data if appropriate.
    // See also applicationDidEnterBackground:.
}


@end
