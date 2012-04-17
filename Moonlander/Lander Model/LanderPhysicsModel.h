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
    
    short       _turnAngle;
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

    id <LanderPhysicsDataSource> __unsafe_unretained _dataSource ;
    id <LanderPhysicsDelegate> __unsafe_unretained _delegate;
}

@property (nonatomic) float clockTicks;             // seconds

@property (nonatomic) float horizontalDistance;     // feet
@property (nonatomic) float verticalDistance;       // feet

@property (nonatomic) short turnAngle;              // degrees (0 is vertical)
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

@property (unsafe_unretained) id <LanderPhysicsDataSource> dataSource;
@property (unsafe_unretained) id <LanderPhysicsDelegate> delegate;

@end
