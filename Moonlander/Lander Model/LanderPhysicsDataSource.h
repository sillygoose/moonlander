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
- (float)altitude;
- (float)range;

- (BOOL)lowFuelWarning;
- (BOOL)onSurface;

- (float)angle;
- (float)angleDegrees;
- (float)thrust;
- (float)fuel;
- (float)weight;
- (float)horizVel;
- (float)vertVel;
- (float)horizAccel;
- (float)vertAccel;
- (float)acceleration;
- (float)thrustPercent;
- (float)time;

- (void)setThrust:(float)thrust;
- (void)setAngle:(float)angleRadians;
- (void)setAngleDegrees:(float)angleDegrees;

- (float)updateTime:(float)timeInterval;

- (void)newGame;

@end
