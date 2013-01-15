//
//  MoonlanderMenuViewController.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import "MoonlanderMenuViewController.h"
#import "DocumentViewController.h"


@interface MoonlanderMenuViewController ()

@property (nonatomic, strong) IBOutlet UIButton *bonusContentButton;
@property (nonatomic, strong) IBOutlet UIButton *moonlanderButton;
@property (nonatomic, strong) IBOutlet UIButton *controlsButton;
@property (nonatomic, strong) IBOutlet UIButton *faqButton;
@property (nonatomic, strong) IBOutlet UIButton *creditsButton;
@property (nonatomic, strong) IBOutlet UIButton *moreClassicsButton;

@end

@implementation MoonlanderMenuViewController

@synthesize menuBackground=_menuBackground;
@synthesize buildInfo=_buildInfo;


#pragma -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];

    // Load the background view controller
    UIStoryboard *storyboard = self.storyboard;
    self.menuBackground = [storyboard instantiateViewControllerWithIdentifier:@"AutoPilotSimulation"];
    
    // Hide the bouns content
    self.bonusContentButton.hidden = YES;

    // Use the custom fonts
    UIFont *displayFont = [UIFont fontWithName:@"Vector Battle" size:66];
    self.bonusContentButton.titleLabel.font = displayFont;
    self.moonlanderButton.titleLabel.font = displayFont;
    self.controlsButton.titleLabel.font = displayFont;
    self.faqButton.titleLabel.font = displayFont;
    self.creditsButton.titleLabel.font = displayFont;
    self.moreClassicsButton.titleLabel.font = displayFont;
    
    // Write the version info in menu view
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *buildString = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *versionString = [infoDict objectForKey:@"CFBundleShortVersionString"];
    int major, minor, build;
    if (3 == sscanf([versionString UTF8String], "%d.%d.%d", &major, &minor, &build)) {
        // Preferred output
        self.buildInfo.text = [NSString stringWithFormat:@"Version %d.%02d (%@)", major, minor, buildString];
    }
    else {
        // Punt, something unexpected happened
        self.buildInfo.text = [NSString stringWithFormat:@"Version %@ (%@)", versionString, buildString];
    }

    // Add to the view and notify everyone
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

    // Unlock the bonus screen
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bonusContentButton.hidden = ![defaults boolForKey:@"optionEnableBonusContent"];
    
    // Hide the navigation bar in this view
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
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

#pragma mark -
#pragma mark Button events

- (IBAction)moreClassicsButtonSelected:(id)sender
{
    NSString *iTunesLink = @"itms-apps://itunes.com/apps/paradigmsystems";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

@end
