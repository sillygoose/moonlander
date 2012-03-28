//
//  MoonlanderAppDelegate_iPad.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "MoonlanderAppDelegate_iPad.h"

@implementation MoonlanderAppDelegate_iPad

@synthesize landerViewController=_landerViewController;
@synthesize splashView=_splashView;
@synthesize moonSplashView=_moonSplashView;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //###
    [super application:application didFinishLaunchingWithOptions:launchOptions];
  
    
    // Let's animate the splash screen
    self.splashView = [[VGView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    self.splashView.userInteractionEnabled = NO;
    self.splashView.backgroundColor = [UIColor blackColor];

    // We need to change the coordinate space to (0,0) in the lower left
    //self.splashView.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
    //self.splashView.image = [UIImage imageNamed:@"Default1.png"];
    self.splashView.hidden = NO;
    
    // Add the splash window
    [self.window addSubview:self.splashView];
    [self.window bringSubviewToFront:self.splashView];
    
    // We need to change the coordinate space to (0,0) in the lower left
    //self.splashView.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);

    // Draw the moon in the 
    self.moonSplashView = [[[Moon alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)] autorelease];
    self.moonSplashView.dataSource = self.moonSplashView;
    self.moonSplashView.userInteractionEnabled = NO;
    self.moonSplashView.hidden = NO;
    [self.moonSplashView useNormalView];
    [self.splashView addSubview:self.moonSplashView];
    
#if 0
    // Now animate the image
    //const CGRect AnimationContentStretch = {{0, 0}, {.5, .5}};
    //const CGAffineTransform AnimationTransform = {1, 0, 0, 1, .5, .5};
    //const float AnimationAlpha = 1.0;
    const float AnimationDuration = 3.0;
    const CGRect AnimationStartingFrame = {{768/2, 1024/2}, {0, 0}};
    const CGRect AnimationEndingFrame = {{0, 0}, {768, 1024}};
    
    // Splash screen animation start state
    self.splashView.frame = AnimationStartingFrame;
    [UIView beginAnimations:nil context:nil];
    
    // Splash screen animation end state
    [UIView setAnimationDuration:AnimationDuration];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self]; 
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    self.splashView.frame = AnimationEndingFrame;
    //self.splashView.alpha = AnimationAlpha;
    //self.splashView.contentStretch = AnimationContentStretch;
    //self.splashView.transform = AnimationTransform;
    [UIView commitAnimations];
#else
    // Create the application UI
    [self.window addSubview:self.landerViewController.view];
    [self.window makeKeyAndVisible];
#endif
    
    // All done, start the app
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)dealloc
{
    [_splashView release];
    [_landerViewController release];
    [super dealloc];
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // Clean up the splash screen
    [self.splashView removeFromSuperview];
    [self.splashView release];
    
    // Create the application UI
    [self.window addSubview:self.landerViewController.view];
    [self.window makeKeyAndVisible];
}

@end
