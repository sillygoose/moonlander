//
//  LanderPhysicsConstants.h
//  Moonlander
//
//  Created by Silly Goose on 5/12/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanderPhysicsModel.h"

@interface LanderPhysicsModel (LanderPhysicsConstants)
@property (nonatomic, readonly) float maxThrust;        // lb
@property (nonatomic, readonly) float minThrust;        // lb

@property (nonatomic, readonly) float lunarGravity;     // feet per seconds squared
@property (nonatomic, readonly) float earthGravity;     // feet per seconds squared
@property (nonatomic, readonly) float lemEmptyMass;     // lbs
@property (nonatomic, readonly) float lemInitalFuel;    // lbs
@property (nonatomic, readonly) float lowFuelLimit;     // lbs
@end
