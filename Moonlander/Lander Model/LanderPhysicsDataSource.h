//
//  LanderPhysicsProtocol.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LanderPhysicsDataSource <NSObject>

- (CGPoint)landerPosition;
- (BOOL)lowFuelWarning;

- (float)altitude;
- (void)setAltitude:(float)value;

- (float)distance;
- (void)setDistance:(float)newDistance;

- (float)angle;
- (void)setAngle:(float)angleRadians;

- (float)angleDegrees;
- (void)setAngleDegrees:(float)angleDegrees;

- (float)thrust;
- (void)setThrust:(float)thrust;

- (float)fuel;
- (void)setFuel:(float)value;

- (float)horizVel;
- (void)setHorizVel:(float)newVel;

- (float)vertVel;
- (void)setVertVel:(float)newVel;

- (float)thrustPercent;
- (float)weight;
- (float)horizAccel;
- (float)vertAccel;
- (float)acceleration;
- (float)time;

- (BOOL)onSurface;

@end
