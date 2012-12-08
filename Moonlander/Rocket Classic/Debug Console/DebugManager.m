//
//  DebugManager.m
// Moonlander
//
//  Created by Rick Naro on 5/17/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "DebugManager.h"


@interface DebugManager ()

@property (nonatomic) BOOL traceEnabled;
@property (nonatomic) float traceStepInterval;

@end


@implementation DebugManager

@synthesize debugControls, debugConsole;
@synthesize traceEnabled, traceStepInterval;


#pragma mark -
#pragma mark View lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //### too many Set debug control options from settinbgs
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.traceEnabled = [defaults floatForKey:@"optionStepEnabled"];
        self.traceStepInterval = [defaults floatForKey:@"optionStepInterval"];

        // Sign up to get changes in debug controls
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugTraceSwitchChange:) name:@"debugTraceSwitchChange" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugTraceStepIntervalChange:) name:@"debugTraceStepIntervalChange" object:nil];
    }
    return self;
}


#pragma mark -
#pragma mark Notifications

- (void)debugTraceSwitchChange:(NSNotification *)notification
{
    NSNumber *traceState = notification.object;
    self.traceEnabled = [traceState boolValue];
}

- (void)debugTraceStepIntervalChange:(NSNotification *)notification
{
    NSNumber *stepsPerSecond = notification.object;
    self.traceStepInterval = [stepsPerSecond floatValue];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    // Release notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // Release objects
    self.debugControls = nil;
    self.debugConsole = nil;
}


#pragma mark -
#pragma mark Debugger methods

- (void)step:(NSString *)statement
{
    self.debugConsole.stepStatement = statement;
}

- (void)stepWait:(NSString *)statement
{
    // Save the current statement
    [self step:statement];
    
    // Trace delay if enabled
    if (self.traceEnabled) {
        float step = 1.0 / traceStepInterval;
        [NSThread sleepForTimeInterval:step];
    }
}

@end
