//
//  MenuViewController_iPad.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import "MenuViewController_iPad.h"
#import "DocumentViewController.h"
#import "WebPageViewController.h"


@interface MenuViewController_iPad ()

@end

@implementation MenuViewController_iPad


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // If the destination view is the name pass the segue name as the content to display
    if ([segue.destinationViewController isKindOfClass:[DocumentViewController class]]) {
        DocumentViewController *dvc = segue.destinationViewController;
        dvc.documentName = segue.identifier;
    }
    if ([segue.destinationViewController isKindOfClass:[WebPageViewController class]]) {
        WebPageViewController *wpvc = segue.destinationViewController;
        wpvc.urlName = segue.identifier;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Hide the navigation bar in this view
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
