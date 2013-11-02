//
//  AutoPilotViewController.m
//  Moonlander
//
//  Created by Rick Naro on 5/5/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "AutoPilotViewController.h"

@interface AutoPilotViewController ()

@end

@implementation AutoPilotViewController

@synthesize backgroundAutoPilot=_backgroundAutoPilot;
@synthesize backgroundAutoPilotTimer=_backgroundAutoPilotTimer;


#pragma -
#pragma mark Delegate
- (void)beep
{
}

- (void)explosion
{
}

- (BOOL)WallpaperController
{
    return YES;
}


#pragma -
#pragma mark Data source

- (CGFloat)gameFontSize
{
    return [super gameFontSize];
}

- (LanderType)landerType
{
    return [super landerType];
}


#pragma -
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS7 support
 //###   self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.backgroundAutoPilot = [[Autopilot alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Start/restart the simulation
    [self setupTimers]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)initGame:(BOOL)splash
{
    self.landerMessages.hidden = YES;
    [super initGame:NO];
}

- (void)initGame2
{
    [self.landerMessages removeAllLanderMessages];
    [self getStarted];
}

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (void)waitNewGame
{
    [self performSelector:@selector(startGameDelay) withObject:nil afterDelay:[self getDelay:DelayNewGame]];
}

- (void)getStarted
{
    [super getStarted];
    [self performSelector:@selector(enableAutoPilot) withObject:nil afterDelay:0];
    
    // Initial instrument displays in autopilot mode
    self.instrument1.instrument = self.heightData;
    self.instrument2.instrument = self.verticalVelocityData;
    self.instrument3.instrument = self.thrustData;
    self.instrument4.instrument = self.thrustAngleData;
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];

    // Enable instrumentation
    self.instrument1.hidden = NO;
    self.instrument2.hidden = NO;
    self.instrument3.hidden = NO;
    self.instrument4.hidden = NO;
}

@end
