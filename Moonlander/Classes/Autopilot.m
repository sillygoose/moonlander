//
//  Autopilot.m
//  Moonlander
//
//  Created by Rick Naro on 5/3/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//

#import "Autopilot.h"

@implementation Autopilot

@synthesize targetAltitude=_targetAltitude;
@synthesize targetRange=_targetRange;

@synthesize currentRange=_currentRange;

@synthesize enabled=_enabled;

@synthesize verticalPosition=_verticalPosition;
@synthesize verticalVelocity=_verticalVelocity;

@synthesize horizontalPosition=_horizontalPosition;
@synthesize horizontalVelocity=_horizontalVelocity;

@synthesize verticalThrustRequested=_verticalThrustRequested;
@synthesize horizontalThrustRequested=_horizontalThrustRequested;


- (id)init
{
    self = [super init];
    if (self) {
        self.enabled = NO;
        
        self.verticalPosition = [[PIDController alloc] init];
        self.verticalVelocity = [[PIDController alloc] init];
        
        self.horizontalPosition = [[PIDController alloc] init];
        self.horizontalVelocity = [[PIDController alloc] init];
    }
    return self;
}

- (void)setup
{
    [self.verticalPosition setup];
    [self.verticalVelocity setup];

    [self.horizontalPosition setup];
    [self.horizontalVelocity setup];
}

- (void)step:(float)dt
{
    [self.verticalPosition step:dt];
    [self.verticalVelocity step:dt];

    [self.horizontalPosition step:dt];
    [self.horizontalVelocity step:dt];
}

@end
