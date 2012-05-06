//
//  ModernLanderViewController_iPad.m
//  Moonlander
//
//  Created by Rick Naro on 5/5/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "ModernLanderViewController_iPad.h"

@interface ModernLanderViewController_iPad ()

@end

@implementation ModernLanderViewController_iPad

@synthesize autoPilot=_autoPilot;
@synthesize autoPilotSwitch=_autoPilotSwitch;
@synthesize autoPilotTimer=_autoPilotTimer;


- (CGFloat)gameFontSize
{
    return 15;
}

- (LanderType)landerType
{
    return LanderTypeModern;
}

- (void)viewDidLoad
{
    // Do the heavy lifting
    [super viewDidLoad];
    
    // Set out lander type
    self.landerType = LanderTypeModern;
    
    // Autopilot and its control switch
	const CGFloat TelemetryXPos = 900;
    const CGFloat TelemetryXSize = 100;
    const CGFloat TelemetryYSize = 24;
    short instrumentY = 320;
    
    self.autoPilot = [[Autopilot alloc] init];
    self.autoPilotSwitch = [[VGButton alloc] initWithFrame:CGRectMake(TelemetryXPos, instrumentY, TelemetryXSize, TelemetryYSize)];
    self.autoPilotSwitch.titleLabel.fontSize = self.gameFontSize;;
    self.autoPilotSwitch.titleLabel.text = @"AUTOPILOT";
    [self.autoPilotSwitch addTarget:self action:@selector(autoPilotChange) forControlEvents:UIControlEventValueChanged];
    self.autoPilotSwitch.hidden = YES;
#ifdef DEBUG
    self.autoPilotSwitch.titleLabel.vectorName = @"autopilot";
#endif
    [self.view addSubview:self.autoPilotSwitch];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.autoPilotSwitch = nil;
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)enableFlightControls
{
    [super enableFlightControls];
    self.autoPilotSwitch.enabled = YES;
}

- (void)disableFlightControls
{
    [super disableFlightControls];
    self.autoPilotSwitch.enabled = NO;
}

- (void)initGame
{
    [self.landerMessages addSystemMessage:@"SplashScreenModern"];
    [super initGame];
}

- (void)initGame2
{
    [super initGame2];
    self.autoPilotSwitch.hidden = NO;
}

- (void)cleanupTimers
{
    [super cleanupTimers];
    [self.autoPilotTimer invalidate];
    self.autoPilotTimer = nil;
}

- (void)cleanupControls
{
    [super cleanupControls];
    self.autoPilotSwitch.titleLabel.blink = NO;
    self.autoPilotSwitch.enabled = NO;
}

- (void)getStarted
{
    [super getStarted];
}

@end
