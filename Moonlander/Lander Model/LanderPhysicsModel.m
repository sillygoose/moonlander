//
//  LanderPhysicsModel.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//
//  Classic game data
//  Time     Fuel     HorizVel   VertVel
//   52      1420
//   52      1424
//   52      1425
//

#import "LanderPhysicsModel.h"
#import "LanderPhysicsDelegate.h"
#import "LanderPhysicsConstants.h"


@implementation LanderPhysicsModel

@synthesize dataSource=_dataSource;
@synthesize delegate=_delegate;

@synthesize clockTicks=_clockTicks;

@synthesize horizontalDistance=_horizontalDistance;
@synthesize verticalDistance=_verticalDistance;

@synthesize rateOfTurn=_rateOfTurn;
@synthesize turnAngle=_turnAngle;
@synthesize lemAcceleration=_lemAcceleration;
@synthesize verticalAcceleration=_verticalAcceleration;
@synthesize horizontalAcceleration=_horizonalAcceleration;
@synthesize verticalVelocity=_verticalVelocity;
@synthesize horizontalVelocity=_horizontalVelocity;

@synthesize percentThrustRequested=_percentThrustRequested;
@synthesize actualThrust=_actualThrust;
@synthesize fuelRemaining=_fuelRemaining;
@synthesize lemMass=_lemMass;


- (float)turnAngle
{
    if ( fabs(_turnAngle) >= M_PI ) {
        _turnAngle = fmodf(_turnAngle, 2.0f * M_PI);
    }
    return _turnAngle;
}

float DegreesToRadians(float degrees)
{
    return degrees * M_PI / 180;
}

float RadiansToDegrees(float radians)
{
    return radians * 180 / M_PI;
}

#pragma mark Model Constants
- (void)stepLanderModel:(float)timeElapsed
{
    // Calculate fuel and accelerations (ROCKET subroutine)
    if (self.fuelRemaining <= 0.0f) {
        self.fuelRemaining = 0.0f;
        self.lemMass = self.lemEmptyMass;
        self.actualThrust = 0.0f;
        self.lemAcceleration = 0.0f;
        self.horizontalAcceleration = 0.0f;
        self.verticalAcceleration = -self.lunarGravity;
    }
    else {
        self.actualThrust = self.percentThrustRequested * self.maxThrust / 100.0f;
        float fuelUsed = self.actualThrust * timeElapsed / 260.0f;
        self.fuelRemaining -= ( fuelUsed >= self.fuelRemaining ) ? self.fuelRemaining : fuelUsed;
        self.lemMass = self.fuelRemaining + self.lemEmptyMass;
        self.lemAcceleration = self.actualThrust * self.earthGravity / self.lemMass * 1.50f;
        self.horizontalAcceleration = self.lemAcceleration * sinf(self.turnAngle);
        self.verticalAcceleration = self.lemAcceleration * cosf(self.turnAngle) - self.lunarGravity;
    }
    
    // Horizontal/vertical velocity/position updates
    self.horizontalVelocity += self.horizontalAcceleration * timeElapsed;
    self.verticalVelocity += self.verticalAcceleration * timeElapsed;
    self.horizontalDistance += self.horizontalVelocity * timeElapsed;
    self.verticalDistance += self.verticalVelocity * timeElapsed;

    // Update the simulation clock
    self.clockTicks += timeElapsed;
}

#pragma mark Data source
- (float)thrustPercent
{
    return (self.fuelRemaining > 0) ? self.actualThrust / self.maxThrust * 100.0f : 0.0f;
}

- (CGPoint)landerPosition
{
    return CGPointMake(self.horizontalDistance, self.verticalDistance);
}

- (float)altitude
{
    return (self.verticalDistance <= 0.0f) ? 0.0f : self.verticalDistance;
}

- (float)distance
{
    return self.horizontalDistance;
}

- (void)setDistance:(float)newDistance
{
    self.horizontalDistance = newDistance;
}

- (BOOL)lowFuelWarning
{
    return ((self.fuelRemaining > 0.0f) && (self.fuelRemaining <= self.lowFuelLimit)) ? YES : NO;
}

- (float)angle
{
    return self.turnAngle;
}

- (float)angleDegrees
{
    return RadiansToDegrees(self.turnAngle);
}

- (float)thrust
{
    return (self.verticalDistance <= 0.0f) ? 0.0f : self.actualThrust;
}

- (float)weight
{
    return self.lemMass ;
}

- (float)fuel
{
    return self.fuelRemaining;
}

- (void)setFuel:(float)fuel
{
    self.fuelRemaining = fuel;
}

- (float)acceleration
{
    return self.lemAcceleration;
}

- (float)horizVel
{
    return self.horizontalVelocity;
}

- (void)setHorizVel:(float)newVel
{
    self.horizontalVelocity = newVel;
}

- (float)vertVel
{
    return self.verticalVelocity;
}

- (void)setVertVel:(float)newVel
{
    self.verticalVelocity = newVel;
}

- (float)horizAccel
{
    return self.horizontalAcceleration;
}

- (float)vertAccel
{
    return self.verticalAcceleration;
}

- (float)time
{
    return self.clockTicks;
}

- (void)setThrust:(float)thrustPercent
{
    if (thrustPercent < 10.0f) {
        thrustPercent = 10.0f;
    }
    self.percentThrustRequested = thrustPercent;
}

- (void)setAngle:(float)angleRadians
{
    self.turnAngle = angleRadians;
}

- (void)setAngleDegrees:(float)angleDegrees
{
    self.turnAngle = DegreesToRadians(angleDegrees);
}

- (float)updateTime:(float)timeElasped
{
    [self stepLanderModel:timeElasped];
    return self.clockTicks;
}

- (void)landerDown
{
    self.actualThrust = 0.0f;
    self.lemAcceleration = 0.0f;
    self.horizontalAcceleration = 0.0f;
    self.verticalAcceleration = -self.lunarGravity;
}

#pragma mark Model initialization
- (void)initializeLanderModel
{
#if 1
    self.rateOfTurn = 0;
    self.turnAngle = DegreesToRadians(0.0f);
    self.horizontalVelocity = 0;
    self.verticalVelocity = -5;
    self.horizontalDistance = 400;
    self.verticalDistance = 150;
    self.percentThrustRequested = 14;
    self.actualThrust = self.percentThrustRequested * self.maxThrust / 100.0;
    self.fuelRemaining = 2006;//self.lemInitalFuel;
    self.clockTicks = 0.0f;
#else
    self.rateOfTurn = 0.0f;
    self.turnAngle = DegreesToRadians(-70.0f);
    self.horizontalVelocity = 1000.0f;
    self.verticalVelocity = -500.0f;
    self.horizontalDistance = -22000.0;
    self.verticalDistance = 23000.0f;
    self.percentThrustRequested = 75.0f;
    self.actualThrust = self.percentThrustRequested * self.maxThrust / 100.0;
    self.fuelRemaining = self.lemInitalFuel;
    self.clockTicks = 0.0f;
#endif
}

- (id)init
{
    if ((self = [super init])) {
        [self initializeLanderModel];
    }
    return self ;
}

- (void)dealloc {
    [super dealloc] ;
}

- (void)newGame
{
    [self initializeLanderModel];
}

   

@end
