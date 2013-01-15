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

@property (nonatomic) BOOL enableGameCenter;
@property (nonatomic, strong) NSString *mcdonaldsLeaderboard;

@end

@implementation MenuViewController

@synthesize gameCenterManager;
@synthesize enableGameCenter, mcdonaldsLeaderboard;


#pragma mark -
#pragma mark Game Center methods

- (void)setEnableGameCenter:(BOOL)newValue
{
    enableGameCenter = newValue;
//###    self.gamecenterButton.enabled = self.gamecenterButton.titleLabel.enabled = newValue;
}


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
//###        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"scorePosted: %4.2f", landingVelocity]]];
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
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
//###    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), @"showLeaderboard"]];
#endif
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
