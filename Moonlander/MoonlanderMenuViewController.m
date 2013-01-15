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
@property (nonatomic, strong) IBOutlet UIButton *highScoresButton;
@property (nonatomic, strong) IBOutlet UIButton *faqButton;
@property (nonatomic, strong) IBOutlet UIButton *creditsButton;
@property (nonatomic, strong) IBOutlet UIButton *moreClassicsButton;

@property (nonatomic) BOOL enableGameCenter;
@property (nonatomic, strong) NSString *mcdonaldsLeaderboard;

@end

@implementation MoonlanderMenuViewController

@synthesize menuBackground=_menuBackground;
@synthesize buildInfo=_buildInfo;

@synthesize gameCenterManager;
@synthesize enableGameCenter, mcdonaldsLeaderboard;


#pragma mark -
#pragma mark Game Center methods

- (void)setEnableGameCenter:(BOOL)newValue
{
    enableGameCenter = newValue;
    self.highScoresButton.enabled = newValue;
}


#pragma mark -
#pragma mark GameCenterDelegateProtocol methods

- (void)processedAuthorization:(GKLocalPlayer *)localPlayer error:(NSError *)error;
{
    // If there is an error, do not assume local player is not authenticated
    if (localPlayer.isAuthenticated) {
#ifdef DEBUG
        if (error) {
            NSLog(@"%@", error);
        }
#endif
        
        // Enable Game Center functionality
        self.enableGameCenter = YES;
        
        // Send up any saved scores
        [self.gameCenterManager loadStoredScores];
    }
    else {
        // No user is logged into Game Center, run without Game Center support or user interface
        self.enableGameCenter = NO;
    }
}

- (void)scoreReported:(NSError *)error
{
}

- (void)reloadScoresComplete:(GKLeaderboard *)leaderBoard error:(NSError *)error
{
    assert(0);
}


#pragma mark -
#pragma mark Notifications

- (void)gkAuthenticationDidChange:(NSNotification *)notification
{
}

- (void)enteredBackground:(NSNotification *)notification
{
    self.enableGameCenter = NO;
}

- (void)resetAchievementsButtonPressed:(NSNotification *)notification
{
    [self.gameCenterManager resetAchievements];
}

- (void)scorePosted:(NSNotification *)notification
{
	if ([GKLocalPlayer localPlayer].authenticated == YES) {
        // Scale up for the Game Center display
        NSNumber *mcdonaldsScore = notification.object;
        int64_t score = [mcdonaldsScore intValue];
        
        // Post the score
        [self.gameCenterManager reportScore:score forCategory:self.mcdonaldsLeaderboard];
        
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"scorePosted: %lld", score]]];
#endif
        
    }
}


#pragma mark -
#pragma mark Leaderboard

- (IBAction)showGameCenterButtonAction:(id)event
{
    [self showLeaderboard:self.mcdonaldsLeaderboard];
}

- (void)showLeaderboard:(NSString *)leaderboard
{
    GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
    [leaderboardViewController setCategory:leaderboard];
    [leaderboardViewController setLeaderboardDelegate:self];
    [self presentModalViewController:leaderboardViewController animated:YES];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	[self dismissModalViewControllerAnimated:YES];
}


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
    self.highScoresButton.titleLabel.font = displayFont;
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
    
    // Access to Game Center elements
    mcdonaldsLeaderboard = @"moonlander.mcdonalds.leaderboard";
    
    // Sign up to get score updates and a move to background  UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scorePosted:) name:@"scorePosted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gkAuthenticationDidChange:) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
    
    // Authenticate with Game Center
    self.enableGameCenter = NO;
    if ([GameCenterManager isGameCenterAvailable]) {
        // Create the manager
		self.gameCenterManager= [[GameCenterManager alloc] init];
		[self.gameCenterManager setDelegate:self];
		[self.gameCenterManager authenticateLocalPlayer];
	}
	else {
        self.gameCenterManager = nil;
	}
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
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), @"More Classics"]];
#endif

    NSString *iTunesLink = @"itms-apps://itunes.com/apps/paradigmsystems";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

@end
