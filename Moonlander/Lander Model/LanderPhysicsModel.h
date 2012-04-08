//
//  LanderPhysicsModel.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanderPhysicsDataSource.h"
#import "LanderPhysicsDelegate.h"

@interface LanderPhysicsModel : NSObject <LanderPhysicsDelegate,  LanderPhysicsDataSource> {
@private
    float       _clockTicks;
    
    float       _horizontalDistance;
    float       _verticalDistance;
    
    float       _rateOfTurn;
    float       _turnAngle;
    float       _lemAcceleration;
    float       _verticalAcceleration;
    float       _horizonalAcceleration;
    float       _verticalVelocity;
    float       _horizontalVelocity;
    
    float       _percentThrustRequested;
    float       _actualThrust;
    float       _fuelRemaining;
    
    float       _lemMass;
    
    BOOL        _lemOnSurface;

    id <LanderPhysicsDataSource> _dataSource ;
    id <LanderPhysicsDelegate> _delegate;
}

@property (nonatomic) float clockTicks;             // seconds

@property (nonatomic) float horizontalDistance;     // feet
@property (nonatomic) float verticalDistance;       // feet

@property (nonatomic) float rateOfTurn;             // radians per second
@property (nonatomic) float turnAngle;              // radians (0 is vertical)
@property (nonatomic) float lemAcceleration;        // feet per seconds squared
@property (nonatomic) float verticalAcceleration;   // feet per seconds squared
@property (nonatomic) float horizontalAcceleration; // feet per seconds squared
@property (nonatomic) float verticalVelocity;       // feet per second
@property (nonatomic) float horizontalVelocity;     // feet per second

@property (nonatomic) float percentThrustRequested; // percent
@property (nonatomic) float actualThrust;           // lb
@property (nonatomic) float fuelRemaining;          // lbs

@property (nonatomic) float lemMass;                // lbs

@property (nonatomic) BOOL lemOnSurface;            // LEM has landed

@property (assign) id <LanderPhysicsDataSource> dataSource;
@property (assign) id <LanderPhysicsDelegate> delegate;

@end
