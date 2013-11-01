//
//  MenuViewController.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import "MenuViewController.h"
#import "DocumentViewController.h"


@interface MenuViewController ()

@end


@implementation MenuViewController


#pragma mark -
#pragma mark Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // If the destination view is the name pass the segue name as the content to display
    if ([segue.destinationViewController isKindOfClass:[DocumentViewController class]]) {
        NSURL *url = [NSURL fileURLWithPath:segue.identifier];
        NSURL *urlSansExtension = [url URLByDeletingPathExtension];
        DocumentViewController *dvc = segue.destinationViewController;
        dvc.documentType = [url pathExtension];
        dvc.documentName = [urlSansExtension relativePath];
    }
}


#pragma -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
