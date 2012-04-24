//
//  MoonlanderAppDelegate_iPad.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "MoonlanderAppDelegate_iPad.h"

@implementation MoonlanderAppDelegate_iPad

@synthesize landerViewController=_landerViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // Create the application UI
    [self.window addSubview:self.landerViewController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
