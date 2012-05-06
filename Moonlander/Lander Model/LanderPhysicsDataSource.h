//
//  LanderPhysicsProtocol.h
//  Moonlander
//
//  Created by Rick on 5/10/11.
//  Copyright 2011 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanderDelegate.h"


@protocol LanderPhysicsDataSource <NSObject>

- (CGPoint)landerPosition;
- (BOOL)lowFuelWarning;

- (short)altitude;
- (void)setAltitude:(short)value;

- (short)distance;
- (void)setDistance:(short)newDistance;

- (float)angle;
- (short)angleDegrees;
- (void)setAngleDegrees:(short)angleDegrees;

- (short)thrust;
- (void)setThrust:(short)percentThrust;
- (short)thrustPercent;

- (short)fuel;
- (void)setFuel:(short)value;

- (short)horizVel;
- (void)setHorizVel:(short)newVel;

- (short)vertVel;
- (void)setVertVel:(short)newVel;

- (short)weight;
- (short)horizAccel;
- (short)vertAccel;
- (short)acceleration;
- (float)time;
- (short)maximumThrust;
- (float)moonGravity;

- (BOOL)onSurface;

@end
