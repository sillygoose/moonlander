//
//  Lander Model.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanderPhysicsDataSource.h"

@interface LanderPhysicsModel : NSObject <LanderPhysicsDataSource> {
@private
    float _clockTicks;
    
    float _horizontalDistance;
    float _verticalDistance;
    
    float _rateOfTurn;
    float _turnAngle;
    float _lemAcceleration;
    float _verticalAcceleration;
    float _horizonalAcceleration;
    float _verticalVelocity;
    float _horizontalVelocity;
    
    float _percentThrustRequested;
    float _actualThrust;
    float _fuelRemaining;
    float _lemMass;

    id <LanderPhysicsDataSource>  _dataSource ;
}

@property (nonatomic) float clockTicks;

@property (nonatomic) float horizontalDistance;
@property (nonatomic) float verticalDistance;

@property (nonatomic) float rateOfTurn;
@property (nonatomic) float turnAngle;
@property (nonatomic) float lemAcceleration;
@property (nonatomic) float verticalAcceleration;
@property (nonatomic) float horizonalAcceleration;
@property (nonatomic) float verticalVelocity;
@property (nonatomic) float horizontalVelocity;

@property (nonatomic) float percentThrustRequested;
@property (nonatomic) float actualThrust;
@property (nonatomic) float fuelRemaining;
@property (nonatomic) float lemMass;

@property (assign) id <LanderPhysicsDataSource> dataSource;

@end
