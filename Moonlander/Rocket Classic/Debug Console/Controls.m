//
//  Controls.m
//  ROCKET Classic
//
//  Created by Rick Naro on 5/17/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "Controls.h"


@interface Controls ()

@property (nonatomic) BOOL autopilotMode;

- (IBAction)traceEnabledUpdated:(id)sender;

- (IBAction)traceStepIntervalChange:(id)sender;
- (IBAction)traceStepIntervalUpdated:(id)sender;

- (IBAction)teletypeAudioVolumeChange;
- (IBAction)teletypeAudioVolumeUpdated;

@end


@implementation Controls

@synthesize stepEnabled=_stepEnabled, stepInterval=_stepInterval;
@synthesize teletypeVolume=_teletypeVolume;
@synthesize autopilotMode;


#pragma mark -
#pragma mark Control interfaces

- (IBAction)traceEnabledUpdated:(id)sender
{
    // Enable/disable the interval slider
    self.stepInterval.enabled = self.stepEnabled.on;
    
    // Save the new value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.stepEnabled.on forKey:@"optionStepEnabled"];
    
    // Pass along the notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceSwitchChange" object:[NSNumber numberWithBool:self.stepEnabled.on]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceStepIntervalChange" object:[NSNumber numberWithFloat:self.stepInterval.value]];
}

- (IBAction)traceStepIntervalUpdated:(id)sender
{
    // Save the new value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:self.stepInterval.value forKey:@"optionStepInterval"];

    // Pass along the notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceStepIntervalChange" object:[NSNumber numberWithFloat:self.stepInterval.value]];
}

- (IBAction)traceStepIntervalChange:(id)sender
{
    // Pass along the notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"debugTraceStepIntervalChange" object:[NSNumber numberWithFloat:self.stepInterval.value]];
}

- (IBAction)teletypeAudioVolumeUpdated
{
    // Save the new value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:self.teletypeVolume.value forKey:@"optionAudioVolume"];
    
    // Pass along the notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teletypeVolumeChanged" object:[NSNumber numberWithFloat:self.teletypeVolume.value]];
}

- (IBAction)teletypeAudioVolumeChange
{
    // Pass along the notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"teletypeVolumeChanged" object:[NSNumber numberWithFloat:self.teletypeVolume.value]];
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
