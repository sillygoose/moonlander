//
//  LanderPhysicsConstants.m
//  Moonlander
//
//  Created by Rick on 5/12/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import "LanderPhysicsConstants.h"


@implementation LanderPhysicsModel (LanderPhysicsConstants)

- (float)maxThrust
{
    return 10500.0f;
}

- (float)minThrust
{
    return (self.fuelRemaining > 0.0f) ? 0.1f * self.maxThrust : 0.0f;
}

- (float)maxThrustLEM
{
    return 9870.0f;
}

- (float)minThrustLEM
{
    return (self.fuelRemaining > 0.0f) ? 1050 : 0.0f;
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

- (float)lemEmptyMassLEM
{
    // Empty lander + crew/gear
    return 8650.0f + 1000.0;
}

- (float)lemInitalFuel
{
    return 3000.0f;
}

- (float)lowFuelLimit
{
    return 200.0f;
}

@end
