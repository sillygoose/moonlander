//
//  MoonlanderAppDelegate_iPad.m
//  Moonlander
//
//  Created by Rick on 5/10/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "MoonlanderAppDelegate_iPad.h"

@implementation MoonlanderAppDelegate_iPad

@synthesize iPadNavagationController=_iPadNavagationController;
@synthesize menuViewController=_menuViewController;
@synthesize landerViewController=_landerViewController;
@synthesize documentViewController=_documentViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL result = [super application:application didFinishLaunchingWithOptions:launchOptions];
    return result;
}

@end
