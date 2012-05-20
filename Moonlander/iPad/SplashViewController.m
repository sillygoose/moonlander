//
//  SplashViewController.m
//  Moonlander
//
//  Created by Rick Naro on 5/5/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "SplashViewController.h"


@implementation SplashViewController

@synthesize firstPart=_firstPart;
@synthesize secondfPart=_secondPart;
@synthesize moonLander=_moonLander;



- (void)dismissSplashScreen
{
    [self performSegueWithIdentifier:@"MenuSegue" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.firstPart.alpha = self.secondfPart.alpha = self.moonLander.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
#ifdef DEBUG
    [self performSelector:@selector(dismissSplashScreen) withObject:nil afterDelay:0];
#else
    [super viewWillAppear:animated];
    
    const float SplashScreenDelay = 3.0;
    const float textFadeInTime = 2.5;
    const float secondFadeInDelay = textFadeInTime + 0.5;
    const float textFadeOutTime = 2.5;
    
    void (^splashComplete)(BOOL) = ^(BOOL f) {
        [self performSelector:@selector(dismissSplashScreen) withObject:nil afterDelay:SplashScreenDelay];
    };
    void (^fadeOut)(void) = ^{
        self.firstPart.alpha = self.secondfPart.alpha = 0.0;
        self.moonLander.alpha = 1.0;
    };
    void (^fadeInComplete)(BOOL) = ^(BOOL f) {
        [UILabel animateWithDuration:textFadeOutTime delay:0.5 options:0 animations:fadeOut completion:splashComplete];
    };
    void (^fadeInFirst)(void) = ^{
        self.firstPart.alpha = 1.0;
    };
    void (^fadeInSecond)(void) = ^{
        self.secondfPart.alpha = 1.0;
    };
    
    // Fade in the splash screen
    [UILabel animateWithDuration:textFadeInTime animations:fadeInFirst];
    [UILabel animateWithDuration:textFadeInTime delay:secondFadeInDelay options:0 animations:fadeInSecond completion:fadeInComplete];
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.firstPart = nil;
    self.secondfPart = nil;
    self.moonLander = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end