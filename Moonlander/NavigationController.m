//
//  NavigationController.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import "NavigationController.h"


@interface NavigationController ()

@end

@implementation NavigationController


- (void)viewDidLoad
{
    // Hide the navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    // iOS7 support
  //###  self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
