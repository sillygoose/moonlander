//
//  WebPageViewController.m
//  Moonlander
//
//  Created by Rick Naro on 4/30/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "WebPageViewController.h"

@interface WebPageViewController ()

@end

@implementation WebPageViewController

@synthesize urlName=_urlName;
@synthesize urlContent=_urlContent;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a URL object.
    NSURL *url = [NSURL URLWithString:self.urlName];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.urlContent loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Allow scrolling/zooming in a document
    self.urlContent.scalesPageToFit = YES;
    
    // Show the navagation bar in this view so we can get back
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; 
    //###self.title = self.urlName;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
