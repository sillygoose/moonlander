//
//  MoonlanderAppDelegate_iPad.m
//  Moonlander
//
//  Created by Rick on 5/10/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "MoonlanderAppDelegate_iPad.h"

@implementation MoonlanderAppDelegate_iPad

@synthesize landerViewController=_landerViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // Load out view controller from a nib file (for now)
    self.landerViewController = [[LanderViewController_iPad alloc] initWithNibName:@"LanderViewController_iPad" bundle:nil];
    self.window.rootViewController = self.landerViewController;
    return YES;
}

@end
