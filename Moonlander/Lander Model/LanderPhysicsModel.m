//
//  LanderPhysicsModel.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderPhysicsModel.h"


@interface LanderPhysicsModel()
// Moonlander constants
@property (nonatomic, readonly) float clockFrequency;
@property (nonatomic, readonly) float maxThrust;
@property (nonatomic, readonly) float minThrust;

@property (nonatomic, readonly) float lunarGravity;
@property (nonatomic, readonly) float lemInitalMass;
@property (nonatomic, readonly) float lemInitalFuel;
@end


@implementation LanderPhysicsModel

@synthesize clockTicks=_clockTicks;

@synthesize horizontalDistance=_horizontalDistance;
@synthesize verticalDistance=_verticalDistance;

@synthesize rateOfTurn=_rateOfTurn;
@synthesize turnAngle=_turnAngle;
@synthesize lemAcceleration=_lemAcceleration;
@synthesize verticalAcceleration=_verticalAcceleration;
@synthesize horizonalAcceleration=_horizonalAcceleration;
@synthesize verticalVelocity=_verticalVelocity;
@synthesize horizontalVelocity=_horizontalVelocity;

@synthesize percentThrustRequested=_percentThrustRequested;
@synthesize actualThrust=_actualThrust;
@synthesize fuelRemaining=_fuelRemaining;
@synthesize lemMass=_lemMass;

@synthesize dataSource=_dataSource;


#pragma mark Model Constants
- (float)clockFrequency
{
    return 1.0f;
}

- (float)maxThrust
{
    return 9870.0f;
}

- (float)minThrust
{
    return 1050.0f;
}

- (float)lunarGravity
{
    return 5.32f;
}

- (float)lemInitalMass
{
    return 10334.0f;
}

- (float)lemInitalFuel
{
    return 30000.0f;
}

#pragma mark Data source
- (CGPoint)position
{
    return CGPointMake(0.0f, 0.0f);
}

- (float)rotation
{
    return self.turnAngle;
}

- (float)thrust
{
    return self.actualThrust;
}

- (void)setThrust:(float)thrust
{
    self.percentThrustRequested = thrust;
}

- (void)setRotation:(float)rotation
{
    self.turnAngle = rotation;
}

- (float)updateTime:(float)timeInterval
{
    self.clockTicks += timeInterval;
    return self.clockTicks;
}


#pragma mark Model initialization
- (void)initializeLanderModel
{
    self.rateOfTurn = -1.0f;
    self.turnAngle = -70.0f;
    self.horizontalVelocity = 10000.0f;
    self.verticalVelocity = -5000.0f;
    self.horizontalDistance = -22000.0;
    self.verticalDistance = 23000.0f;
    self.percentThrustRequested = 75.0f;
    self.fuelRemaining = self.lemInitalFuel;
    self.clockTicks = 0.0f;
}

- (id)init
{
    if ((self = [super init])) {
    }
    return self ;
}

- (void)dealloc {
    [super dealloc] ;
}

@end
