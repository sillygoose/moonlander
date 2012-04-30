//
//  DocumentViewController.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "DocumentViewController.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

@synthesize documentName=_documentName;
@synthesize documentType=_documentType;
@synthesize documentContent=_documentContent;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup the content for our document view
    NSString *path = [[NSBundle mainBundle] pathForResource:self.documentName ofType:self.documentType];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.documentContent loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Allow scrolling/zooming in a document
    self.documentContent.scalesPageToFit = YES;
    
    // Add the document to the navigation bar
    self.title = self.documentName;
    
    // Show the navagation bar in this view so we can get back
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; 
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
