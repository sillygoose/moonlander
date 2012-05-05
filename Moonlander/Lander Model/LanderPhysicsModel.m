//
// LanderPhysicsModel.m
// Moonlander
//
// Created by Rick on 5/10/11.
// Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "LanderPhysicsModel.h"
#import "LanderPhysicsDelegate.h"
#import "LanderPhysicsConstants.h"


// Add any custom debugging options
#if defined(TARGET_IPHONE_SIMULATOR) && defined(DEBUG)
//#define DEBUG_AUTOPILOT
//#define DEBUG_DUST
//#define DEBUG_LOCATION
//#define DEBUG_FLAME
//#define HOLD_VELOCITY
//#define DEBUG_HOLD_HORIZONTAL_POSITION
//#define DEBUG_HOLD_VERTICAL_POSITION
#endif


@implementation LanderPhysicsModel

@synthesize dataSource=_dataSource;
@synthesize delegate=_delegate;

@synthesize clockTicks=_clockTicks;

@synthesize horizontalDistance=_horizontalDistance;
@synthesize verticalDistance=_verticalDistance;

@synthesize turnAngle=_turnAngle;
@synthesize lemAcceleration=_lemAcceleration;
@synthesize verticalAcceleration=_verticalAcceleration;
@synthesize horizontalAcceleration=_horizonalAcceleration;
@synthesize verticalVelocity=_verticalVelocity;
@synthesize horizontalVelocity=_horizontalVelocity;
@synthesize percentThrustRequested=_percentThrustRequested;
@synthesize fuelRemaining=_fuelRemaining;

@synthesize actualThrust=_actualThrust;

@synthesize modernModel=_modernModel;
@synthesize lemMass=_lemMass;

@synthesize lemOnSurface=_lemOnSurface;


static float DegreesToRadians(float degrees)
{
    return degrees * M_PI / 180;
}

static float RadiansToDegrees(float radians)
{
    return radians * 180 / M_PI;
}

// Setters and getters
- (void)setFuelRemaining:(float)fuel
{
    _fuelRemaining = fuel;
    if (_fuelRemaining <= 0) {
        _fuelRemaining = 0;
        self.actualThrust = 0;
    }
}

- (void)setPercentThrustRequested:(short)thrustRequested
{
    short mt = (self.modernModel) ? self.maxThrustLEM : self.maxThrust;
    _percentThrustRequested = thrustRequested;
    self.actualThrust = (self.fuelRemaining > 0) ? (_percentThrustRequested * mt / 100) : 0;
}

- (void)setTurnAngle:(short)angle
{
    angle = angle % 360;
    if (angle > 180) {
        angle -= 360;
    }
    _turnAngle = angle;
}

- (float)turnAngleRadians
{
    return DegreesToRadians(self.turnAngle);
}


- (id)init
{
    if ((self = [super init])) {
        self.dataSource = self;
        self.delegate = self;
        [self initializeLanderModel];
    }
    return self ;
}

- (void)newGame
{
    [self initializeLanderModel];
}


#pragma mark Data source
- (CGPoint)landerPosition
{
    return CGPointMake(self.horizontalDistance, self.verticalDistance);
}

- (short)altitude
{
    return (short)((self.verticalDistance <= 0) ? 0 : self.verticalDistance);
}

- (void)setAltitude:(short)value
{
    self.verticalDistance = value;
}

- (short)distance
{
    return (short)self.horizontalDistance;
}

- (void)setDistance:(short)newDistance
{
    self.horizontalDistance = newDistance;
}

- (BOOL)lowFuelWarning
{
    return ((self.fuelRemaining > 0.0f) && (self.fuelRemaining <= self.lowFuelLimit)) ? YES : NO;
}

- (short)thrust
{
    return (short)((self.lemOnSurface) ? 0 : self.actualThrust);
}

- (void)setThrust:(short)thrustPercent
{
    // Enforce a minimum thrust level of 10%
    if (thrustPercent < 10) {
        thrustPercent = 10;
    }
    else if (thrustPercent > 100) {
        thrustPercent = 100;
    }
    self.percentThrustRequested = thrustPercent;
}

- (short)thrustPercent
{
    return self.percentThrustRequested;
}

- (short)weight
{
    return (short)self.lemMass ;
}

- (short)fuel
{
    return (short)self.fuelRemaining;
}

- (void)setFuel:(short)fuel
{
    self.fuelRemaining = fuel;
}

- (short)acceleration
{
    return self.lemAcceleration;
}

- (short)horizVel
{
    return (short)self.horizontalVelocity;
}

- (void)setHorizVel:(short)newVel
{
    self.horizontalVelocity = newVel;
}

- (short)vertVel
{
    return self.verticalVelocity;
}

- (void)setVertVel:(short)newVel
{
    self.verticalVelocity = newVel;
}

- (short)horizAccel
{
    return (short)self.horizontalAcceleration;
}

- (short)vertAccel
{
    return (short)self.verticalAcceleration;
}

- (float)time
{
    return self.clockTicks;
}

- (float)moonGravity
{
    return self.lunarGravity;
}

- (short)maximumThrust
{
    return (self.modernModel) ? self.maxThrustLEM : self.maxThrust;
}

- (float)updateTime:(float)timeElasped
{
    [self stepLanderModel:timeElasped];
    return self.clockTicks;
}

- (float)angle
{
    return DegreesToRadians(self.turnAngle);
}

- (short)angleDegrees
{
    return self.turnAngle;
}

- (void)setAngleDegrees:(short)angleDegrees
{
    self.turnAngle = angleDegrees;
}

- (void)landerTakeoff
{
    self.lemOnSurface = NO;
}

- (BOOL)onSurface
{
    return self.lemOnSurface;
}

- (void)landerDown
{
    // Set our weight on legs indicator
    self.lemOnSurface = YES;
    
    // Set our thrust and accelerations
    self.percentThrustRequested = 0;
    self.actualThrust = 0;
    self.lemAcceleration = 0;
    self.horizontalAcceleration = 0;
    self.verticalAcceleration = -self.lunarGravity;
}

#pragma mark Model initialization
- (void)initializeLanderModel
{
    // Start in flight mode
    self.lemOnSurface = NO;
#if defined(DEBUG) && (defined(DEBUG_AUTOPILOT) || defined(DEBUG_DUST) || defined(DEBUG_FLAME) || defined(DEBUG_HOLD_HORIZONTAL_POSITION) || defined(DEBUG_HOLD_VERTICAL_POSITION))
    // Custom lander start point
    self.fuelRemaining = self.lemInitalFuel;
    self.turnAngle = -0.0f;
    self.horizontalVelocity = 500.0f;
    self.verticalVelocity = 0.0f;
    self.horizontalDistance = -22000.0;
    self.verticalDistance = 18000.0f;
    self.percentThrustRequested = 18.0f;
    self.clockTicks = 0.0f;
#else
    // Default game start point
    self.fuelRemaining = self.lemInitalFuel;
    self.turnAngle = -70.0f;
    self.horizontalVelocity = 1000.0f;
    self.verticalVelocity = -500.0f;
    self.horizontalDistance = -22000.0;
    self.verticalDistance = 23000.0f;
    self.percentThrustRequested = 75.0f;
    self.clockTicks = 0.0f;
#endif
}

#pragma mark Model Periodic Update
- (void)stepLanderModel:(float)timeElapsed
{
    if (!self.onSurface) {
        // Calculate fuel and accelerations (ROCKET subroutine)
        if (self.fuelRemaining <= 0) {
            self.fuelRemaining = 0;
            self.lemMass = (self.modernModel) ? self.lemEmptyMassLEM : self.lemEmptyMass;
            self.actualThrust = 0;
            self.lemAcceleration = 0;
            self.horizontalAcceleration = 0;
            self.verticalAcceleration = -self.lunarGravity;
        }
        else {
            short maxThrust = (self.modernModel) ? self.maxThrustLEM : self.maxThrust;
            self.actualThrust = self.percentThrustRequested * maxThrust / 100.0f;

            float fuelUsed = self.actualThrust * timeElapsed / 250.0f;
            self.fuelRemaining -= fuelUsed;
            
            //(FUELKO)
            short lemEmptyMass = (self.modernModel) ? self.lemEmptyMassLEM : self.lemEmptyMass;
            self.lemMass = self.fuelRemaining + lemEmptyMass;
            
            if (self.modernModel) {
                self.lemAcceleration = self.actualThrust * self.earthGravity / self.lemMass;
            }
            else {
                self.lemAcceleration = self.actualThrust * self.earthGravity / 10674.0;
            }
            self.horizontalAcceleration = self.lemAcceleration * sinf(self.turnAngleRadians);
            self.verticalAcceleration = self.lemAcceleration * cosf(self.turnAngleRadians) - self.lunarGravity;
        }

#ifndef HOLD_VELOCITY
        // Update our velocities
        self.horizontalVelocity += self.horizontalAcceleration * timeElapsed;
        self.verticalVelocity += self.verticalAcceleration * timeElapsed;
#endif
        
        // Horizontal/vertical position updates
#ifndef DEBUG_HOLD_HORIZONTAL_POSITION
        self.horizontalDistance += self.horizontalVelocity * timeElapsed;
#endif
#ifndef DEBUG_HOLD_VERTICAL_POSITION
        self.verticalDistance += self.verticalVelocity * timeElapsed;
#endif
    }
    
    // Update the simulation clock
    self.clockTicks += timeElapsed;
}

@end