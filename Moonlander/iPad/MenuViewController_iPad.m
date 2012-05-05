//
//  MenuViewController_iPad.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import "MenuViewController_iPad.h"
#import "DocumentViewController.h"


@interface MenuViewController_iPad ()

@end

@implementation MenuViewController_iPad

@synthesize menuBackground=_menuBackground;


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
    else if ([segue.destinationViewController isKindOfClass:[LanderViewController_iPad class]]) {
        LanderViewController_iPad *lvc = segue.destinationViewController;
        lvc.playEnhancedGame = [segue.identifier isEqualToString:@"PlayModernSegue"];
    }
    NSLog(@"Seque to %@", segue.identifier);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"menuVC:viewDidLoad  %@  %@", NSStringFromCGRect(self.view.bounds), NSStringFromCGAffineTransform(self.view.transform));
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];

    UIStoryboard *storyboard = self.storyboard;
    self.menuBackground = [storyboard instantiateViewControllerWithIdentifier:@"ModernSim"];
    
    // Configure the new view controller
    self.menuBackground.playEnhancedGame = YES;
    self.menuBackground.menuSubview = YES;
    
    //[self presentViewController:self.menuBackground animated:NO completion:nil];
    [self.view addSubview:self.menuBackground.view];
    [self.view sendSubviewToBack:self.menuBackground.view];
    [self addChildViewController:self.menuBackground];
    [self.menuBackground didMoveToParentViewController:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.menuBackground = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"menuVC:viewWillAppear  %@  %@", NSStringFromCGRect(self.view.bounds), NSStringFromCGAffineTransform(self.view.transform));
    // Hide the navigation bar in this view
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    //NSLog(@"viewWillAppear  frame: %@  bounds: %@  transform: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds), NSStringFromCGAffineTransform(self.view.transform));
    
    //[self.menuBackground setupTimers];
   // [self.menuBackground viewWillAppear:animated];
    //self.menuBackground.view.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"menuVC:viewDidAppear  %@  %@", NSStringFromCGRect(self.view.bounds), NSStringFromCGAffineTransform(self.view.transform));
    // Hide the navigation bar in this view
    ///###[[self navigationController] setNavigationBarHidden:YES animated:NO];
    //NSLog(@"viewWillAppear  frame: %@  bounds: %@  transform: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds), NSStringFromCGAffineTransform(self.view.transform));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    NSLog(@"menuVC:didRotateFromInterfaceOrientation  %@  %@  %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds), NSStringFromCGAffineTransform(self.view.transform));
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    NSLog(@"menuVC:willRotateToInterfaceOrientation  %@  %@  %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds), NSStringFromCGAffineTransform(self.view.transform));
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
