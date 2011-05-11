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


@interface LanderPhysicsModel()
// Moonlander constants
@property (nonatomic, readonly) float maxThrust;        // lb
@property (nonatomic, readonly) float minThrust;        // lb

@property (nonatomic, readonly) float lunarGravity;     // feet per seconds squared
@property (nonatomic, readonly) float earthGravity;     // feet per seconds squared
@property (nonatomic, readonly) float lemEmptyMass;     // lbs
@property (nonatomic, readonly) float lemInitalFuel;    // lbs
@property (nonatomic, readonly) float lowFuelLimit;     // lbs
@end


@implementation LanderPhysicsModel

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

@synthesize dataSource=_dataSource;

- (float)turnAngle
{
    if ( fabs(_turnAngle) >= M_PI ) _turnAngle = fmodf(_turnAngle, 2.0f * M_PI);
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
- (float)maxThrust
{
    return 10500.0f;
}

- (float)minThrust
{
    return 0.1f * self.maxThrust;
}

- (float)lunarGravity
{
    return 5.32f;
}

- (float)earthGravity
{
    return 32.174f;
}

- (float)lemEmptyMass
{
    return 14300.0f;
}

- (float)lemInitalFuel
{
    return 3000.0f;
}

- (float)lowFuelLimit
{
    return 200.0f;
}

- (void)stepLanderModel:(float)timeElapsed
{
    // Calculate fuel and accelerations (ROCKET subroutine)
    if (self.fuelRemaining <= 0.0f) {
        self.fuelRemaining = 0.0f;
        self.actualThrust = 0.0f;
        self.lemAcceleration = 0.0f;
        self.horizontalAcceleration = 0.0f;
        self.verticalAcceleration = -self.lunarGravity;
        self.lemMass = self.lemEmptyMass;
    }
    else {
        self.actualThrust = self.percentThrustRequested * self.maxThrust / 100.0f;
        float fuelUsed = self.actualThrust * timeElapsed / 250.0f;
        self.fuelRemaining -= ( fuelUsed >= self.fuelRemaining ) ? self.fuelRemaining : fuelUsed;
        self.lemMass = self.fuelRemaining + self.lemEmptyMass;
        self.lemAcceleration = self.actualThrust * self.earthGravity / self.lemMass * 1.6f;
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

- (float)thrustPercent
{
    return self.actualThrust / self.maxThrust * 100.0f;
}

#pragma mark Data source
- (CGPoint)landerPosition
{
    return CGPointMake(self.horizontalDistance, self.verticalDistance);
}

- (float)altitude
{
    return (self.verticalDistance <= 0.0f) ? 0.0f : self.verticalDistance;
}

- (float)range
{
    return self.horizontalDistance;
}

- (BOOL)lowFuelWarning
{
    return ((self.fuelRemaining > 0.0f) && (self.fuelRemaining <= self.lowFuelLimit)) ? YES : NO;
}

- (BOOL)onSurface
{
    return (self.verticalDistance <= 0);
}

- (float)rotation
{
    return self.turnAngle;
}

- (float)rotationDegrees
{
    return RadiansToDegrees(self.turnAngle);
}

- (float)thrust
{
    return self.actualThrust;
}

- (float)weight
{
    return self.lemMass ;
}

- (float)fuel
{
    return self.fuelRemaining;
}

- (float)acceleration
{
    return self.lemAcceleration;
}

- (float)horizVel
{
    return self.horizontalVelocity;
}

- (float)vertVel
{
    return self.verticalVelocity;
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

- (void)setThrust:(float)thrust
{
    self.percentThrustRequested = thrust;
}

- (void)setRotation:(float)rotation
{
    self.turnAngle = rotation;
}

- (float)updateTime:(float)timeElasped
{
    [self stepLanderModel:timeElasped];
    return self.clockTicks;
}

#pragma mark Model initialization
- (void)initializeLanderModel
{
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

@end
