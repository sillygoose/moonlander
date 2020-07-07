//
//  MenuViewController.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//

#import "MenuViewController.h"
#import "DocumentViewController.h"


@interface MenuViewController ()

@property (nonatomic, strong) IBOutlet UIButton *moonlanderButton;
@property (nonatomic, strong) IBOutlet UIButton *controlsButton;
@property (nonatomic, strong) IBOutlet UIButton *faqButton;
@property (nonatomic, strong) IBOutlet UIButton *creditsButton;
#ifdef ML_MORE_CLASSICS
@property (nonatomic, strong) IBOutlet UIButton *moreClassicsButton;
#endif

@end

@implementation MenuViewController

@synthesize menuBackground=_menuBackground;
@synthesize buildInfo=_buildInfo;


#pragma mark -
#pragma mark View lifecycle
    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // If the destination view is the name pass the segue name as the content to display
    if ([segue.destinationViewController isKindOfClass:[DocumentViewController class]]) {
        DocumentViewController *dvc = segue.destinationViewController;
        dvc.documentName = segue.identifier;
    }
}

    

#pragma -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Write the version info in menu view
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *buildString = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *versionString = [infoDict objectForKey:@"CFBundleShortVersionString"];
    int major, minor, build;
    if (3 == sscanf([versionString UTF8String], "%d.%d.%d", &major, &minor, &build)) {
        // Preferred output
        self.buildInfo.text = [NSString stringWithFormat:@"Version %d.%d.%d (%@)", major, minor, build, buildString];
    }
    else {
        // Punt, something unexpected happened
        self.buildInfo.text = [NSString stringWithFormat:@"Version %@ (%@)", versionString, buildString];
    }

    // Load the background simulation view controller
    UIStoryboard *storyboard = self.storyboard;
    self.menuBackground = [storyboard instantiateViewControllerWithIdentifier:@"AutoPilotSimulation"];
    
    // Add to the view and notify everyone
    [self.view addSubview:self.menuBackground.view];
    [self.view sendSubviewToBack:self.menuBackground.view];
    [self addChildViewController:self.menuBackground];
    [self.menuBackground didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



#pragma mark -
#pragma mark Button events

#ifdef ML_MORE_CLASSICS
- (IBAction)moreClassicsButtonSelected:(id)sender
{
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), @"More Classics"]];
#endif

    NSString *iTunesLink = @"itms-apps://itunes.com/apps/paradigmsystems";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
#endif

@end
