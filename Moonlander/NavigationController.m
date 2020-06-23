//
//  NavigationController.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Rick Naroe. All rights reserved.
//

#import "NavigationController.h"


@interface NavigationController ()

@end

@implementation NavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hide the navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

@end
