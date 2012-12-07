//
//  Controls.m
//  ROCKET Classic
//
//  Created by Rick Naro on 5/17/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "Controls.h"


@interface Controls ()

@property (nonatomic) IBOutlet UISwitch *stepEnabled;
@property (nonatomic) IBOutlet UISlider *stepInterval;
@property (nonatomic) BOOL autopilotMode;

- (IBAction)traceEnabledChanged:(id)sender;
- (IBAction)traceStepIntervalChanged:(id)sender;

@end


@implementation Controls

@synthesize stepEnabled, stepInterval;
@synthesize autopilotMode;


#pragma mark -
#pragma mark Control interfaces

- (IBAction)traceEnabledChanged:(id)sender
{
    // Enable/disable the slider
    self.stepInterval.enabled = self.stepEnabled.on;
    
    // Pass along the notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceSwitchChange" object:[NSNumber numberWithBool:self.stepEnabled.on]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceStepIntervalChange" object:[NSNumber numberWithFloat:self.stepInterval.value]];
}

- (IBAction)traceStepIntervalChanged:(id)sender
{
    // Pass along the notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceStepIntervalChange" object:[NSNumber numberWithFloat:self.stepInterval.value]];
}


#pragma mark -
#pragma mark Notifications

- (void)debugSetTraceEnable:(NSNotification *)notification
{
    NSNumber *traceState = notification.object;
    self.stepEnabled.on = [traceState boolValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceSwitchChange" object:[NSNumber numberWithBool:self.stepEnabled.on]];
}

- (void)debugSetTraceInterval:(NSNotification *)notification
{
    NSNumber *traceInterval = notification.object;
    self.stepInterval.value = [traceInterval floatValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceStepIntervalChange" object:[NSNumber numberWithFloat:self.stepInterval.value]];
}

- (void)autopilotMode:(NSNotification *)notification
{
    NSNumber *autopilotModeValue = notification.object;
    self.autopilotMode = [autopilotModeValue boolValue];
    self.stepEnabled.enabled = self.stepInterval.enabled = (self.autopilotMode == YES) ? NO : YES;
}


#pragma mark -
#pragma mark View lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Sign up to get changes in debug controls
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugSetTraceEnable:) name:@"debugSetTraceEnable" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugSetTraceInterval:) name:@"debugSetTraceInterval" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autopilotMode:) name:@"autopilotMode" object:nil];
    }
    return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    // Release notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // Release objects
    self.stepEnabled = nil;
    self.stepInterval = nil;
}

@end
