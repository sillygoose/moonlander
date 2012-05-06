//
//  AutoPilotViewController_iPad.m
//  Moonlander
//
//  Created by Rick Naro on 5/5/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "AutoPilotViewController_iPad.h"

@interface AutoPilotViewController_iPad ()

@end

@implementation AutoPilotViewController_iPad


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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    //###self.autoPilotSwitch.hidden = YES;
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
