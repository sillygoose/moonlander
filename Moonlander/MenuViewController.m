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

@property (nonatomic, strong) IBOutlet UIButton *bonusContent;

@end

@implementation MenuViewController

@synthesize menuBackground=_menuBackground;
@synthesize buildInfo=_buildInfo;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];

    // Load the background view controller
    UIStoryboard *storyboard = self.storyboard;
    self.menuBackground = [storyboard instantiateViewControllerWithIdentifier:@"AutoPilotSimulation"];
    
    // Hide the bouns content
    self.bonusContent.hidden = YES;
    
    // Add to the view and notify everyone
    [self.view addSubview:self.menuBackground.view];
    [self.view sendSubviewToBack:self.menuBackground.view];
    [self addChildViewController:self.menuBackground];
    [self.menuBackground didMoveToParentViewController:self];
    
    // Add the software build info to the menu scene
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    self.buildInfo.text = [NSString stringWithFormat:@"Build %@", [infoDict objectForKey:@"CFBundleVersion"]];
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
    self.bonusContent.hidden = ![defaults boolForKey:@"optionEnableBonusContent"];
    
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

@end
