//
//  LunarLanderMenuViewController.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import "LunarLanderMenuViewController.h"
#import "DocumentViewController.h"


@interface LunarLanderMenuViewController ()

@property (nonatomic, strong) IBOutlet UIButton *lunarlanderButton;
@property (nonatomic, strong) IBOutlet UIButton *controlsButton;
@property (nonatomic, strong) IBOutlet UIButton *faqButton;
@property (nonatomic, strong) IBOutlet UILabel *backgroundSource;

@end

@implementation LunarLanderMenuViewController


#pragma -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Use the custom fonts
    UIFont *displayFont = [UIFont fontWithName:@"Teleprinter-Bold" size:48];
    self.lunarlanderButton.titleLabel.font = displayFont;
    self.controlsButton.titleLabel.font = displayFont;
    self.faqButton.titleLabel.font = displayFont;

    UIFont *sourceFont = [UIFont fontWithName:@"Teleprinter-Bold" size:14];
    self.backgroundSource.font = sourceFont;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the navagation bar in this view so we can get back
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
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
