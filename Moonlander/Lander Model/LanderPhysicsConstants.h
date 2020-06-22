//
//  LanderPhysicsConstants.h
//  Moonlander
//
//  Created by Rick on 5/12/11.
//  Copyright 2012 Rick Naro. All rights reserved.
//
//  Most constants are form the orignla sources, those ending with LEM are from
//  the Smithsonian Apollo specifications


#import <Foundation/Foundation.h>

#import "LanderPhysicsModel.h"


@interface LanderPhysicsModel (LanderPhysicsConstants)

@property (nonatomic, readonly) float maxThrust;        // lb
@property (nonatomic, readonly) float maxThrustLEM;     // lb

@property (nonatomic, readonly) float minThrust;        // lb
@property (nonatomic, readonly) float minThrustLEM;     // lb

@property (nonatomic, readonly) float lunarGravity;     // feet per seconds squared
@property (nonatomic, readonly) float earthGravity;     // feet per seconds squared

@property (nonatomic, readonly) float lemEmptyMass;     // lbs
@property (nonatomic, readonly) float lemEmptyMassLEM;  // lbs

@property (nonatomic, readonly) float lemInitialFuel;    // lbs
@property (nonatomic, readonly) float lowFuelLimit;     // lbs

@end
