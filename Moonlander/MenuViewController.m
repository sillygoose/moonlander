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

@property (nonatomic, strong) IBOutlet UIButton *moonlanderButton;
@property (nonatomic, strong) IBOutlet UIButton *controlsButton;
@property (nonatomic, strong) IBOutlet UIButton *gameCenterButton;
@property (nonatomic, strong) IBOutlet UIButton *faqButton;
@property (nonatomic, strong) IBOutlet UIButton *creditsButton;
#ifdef ML_MORE_CLASSICS
@property (nonatomic, strong) IBOutlet UIButton *moreClassicsButton;
#endif

@property (nonatomic) BOOL enableGameCenter;
@property (nonatomic, strong) NSString *mcdonaldsLeaderboard;
@property (nonatomic, strong) NSString *remainingFuelLeaderboard;
@property (nonatomic, strong) NSString *fastestTimeLeaderboard;
@property (nonatomic, strong) NSString *distanceLeaderboard;

@end

@implementation MenuViewController

@synthesize gameCenterManager=_gameCenterManager;
@synthesize menuBackground=_menuBackground;
@synthesize buildInfo=_buildInfo;

@synthesize enableGameCenter, mcdonaldsLeaderboard, remainingFuelLeaderboard, fastestTimeLeaderboard, distanceLeaderboard;


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
        self.gameCenterButton.enabled = YES;
    }
    else {
        // No user is logged into Game Center, run without Game Center support or user interface
        self.enableGameCenter = NO;
        self.gameCenterButton.enabled = NO;
    }
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

- (void)mcdonaldsScorePosted:(NSNotification *)notification
{
    // Scale up for the Game Center display
    NSNumber *mcdonaldsScore = notification.object;
    int64_t score = [mcdonaldsScore intValue];
    
    // Post the new score
    GKScore *newScore = [[GKScore alloc] init];
    newScore.value = score;
    newScore.leaderboardIdentifier = self.mcdonaldsLeaderboard;
    NSArray *scores = [NSArray arrayWithObjects:newScore, nil];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error in reporting McDonalds score: %@", error);
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"Error reporting McDonalds score %lld: %@", score, error]]];
#endif
        }
    }];
}

- (void)fuelScorePosted:(NSNotification *)notification
{
    // Scale up for the Game Center display
    NSNumber *fuelScore = notification.object;
    int64_t score = [fuelScore intValue];
    
    // Post the new score
    GKScore *newScore = [[GKScore alloc] init];
    newScore.value = score;
    newScore.leaderboardIdentifier = self.remainingFuelLeaderboard;
    NSArray *scores = [NSArray arrayWithObjects:newScore, nil];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error in reporting fuel score: %@", error);
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"Error reporting fuel score %lld: %@", score, error]]];
#endif
        }
    }];
}

- (void)distanceScorePosted:(NSNotification *)notification
{
    // Scale up for the Game Center display
    NSNumber *distanceScore = notification.object;
    int64_t score = [distanceScore intValue];
    
    // Post the new score
    GKScore *newScore = [[GKScore alloc] init];
    newScore.value = score;
    newScore.leaderboardIdentifier = self.distanceLeaderboard;
    NSArray *scores = [NSArray arrayWithObjects:newScore, nil];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error in reporting distance score: %@", error);
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"Error reporting distance score %lld: %@", score, error]]];
#endif
        }
    }];
}

- (void)fastestScorePosted:(NSNotification *)notification
{
    // Scale up for the Game Center display
    NSNumber *timeScore = notification.object;
    float elapsedTime = [timeScore floatValue];
    int64_t score = elapsedTime * 10.0;
    
    // Post the new score
    GKScore *newScore = [[GKScore alloc] init];
    newScore.value = score;
    newScore.leaderboardIdentifier = self.fastestTimeLeaderboard;
    NSArray *scores = [NSArray arrayWithObjects:newScore, nil];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error in reporting time score: %@", error);
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"Error reporting time score %lld: %@", score, error]]];
#endif
        }
    }];
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
    
    // Access to Game Center elements
    self.mcdonaldsLeaderboard = @"moonlander.mcdonalds.leaderboard";
    self.remainingFuelLeaderboard = @"moonlander.remainingfuel.leaderboard";
    self.fastestTimeLeaderboard = @"moonlander.fastest.leaderboard";
    self.distanceLeaderboard = @"moonlander.distance.leaderboard";
    
    // Sign up to get score updates and a move to background  UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mcdonaldsScorePosted:) name:@"mcdonaldsScorePosted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fuelScorePosted:) name:@"fuelScorePosted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distanceScorePosted:) name:@"distanceScorePosted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fastestScorePosted:) name:@"fastestScorePosted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gkAuthenticationDidChange:) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
    
    // Authenticate with Game Center
    self.enableGameCenter = NO;
    self.gameCenterManager = nil;
#if 0
    if ([GameCenterManager isGameCenterAvailable]) {
        // Create the manager
		self.gameCenterManager= [[GameCenterManager alloc] init];
		[self.gameCenterManager setDelegate:self];
		[self.gameCenterManager authenticateLocalPlayer];
	}
	else {
        self.gameCenterManager = nil;
	}
#endif
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
#pragma mark Game Center button actions
    
- (IBAction)showGameCenterButtonAction:(id)event
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        [self presentViewController:gameCenterController animated:YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)viewController
{
    if ([self presentedViewController]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
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
