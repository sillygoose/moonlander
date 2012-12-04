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


#pragma -
#pragma mark Delegate
- (void)beep
{
}

- (void)explosion
{
}


- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)initGame
{
    [super initGame];
    self.landerMessages.hidden = YES;
    
    [self performSelector:@selector(initGame2) withObject:nil afterDelay:0];
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
    [self performSelector:@selector(startGameDelay) withObject:nil afterDelay:[self getDelay: DelayNewGame]];
}

- (void)getStarted
{
    [super getStarted];
    [self performSelector:@selector(enableAutoPilot) withObject:nil afterDelay:0];
}

@end
