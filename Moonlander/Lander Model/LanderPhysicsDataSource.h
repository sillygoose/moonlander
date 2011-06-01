//
//  LanderPhysicsProtocol.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LanderPhysicsDataSource <NSObject>

- (BOOL)onSurface;

- (CGPoint)landerPosition;

- (float)altitude;
- (float)distance;
- (void)setDistance:(float)newDistance;

- (BOOL)lowFuelWarning;

- (float)angle;
- (float)angleDegrees;
- (void)setAngle:(float)angleRadians;
- (void)setAngleDegrees:(float)angleDegrees;

- (float)thrust;
- (void)setThrust:(float)thrust;
- (float)thrustPercent;

- (float)fuel;
- (void)setFuel:(float)fuel;
- (float)weight;
- (float)horizVel;
- (void)setHorizVel:(float)newVel;
- (float)vertVel;
- (void)setVertVel:(float)newVel;
- (float)horizAccel;
- (float)vertAccel;
- (float)acceleration;
- (float)time;

@end
