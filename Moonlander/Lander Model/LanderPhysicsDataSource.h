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

- (float)angle;
- (float)angleDegrees;
- (void)setAngle:(float)angleRadians;
- (void)setAngleDegrees:(float)angleDegrees;

- (float)thrust;
- (void)setThrust:(float)thrust;
- (float)thrustPercent;

- (float)fuel;
- (float)weight;
- (float)horizVel;
- (float)vertVel;
- (float)horizAccel;
- (float)vertAccel;
- (float)acceleration;
- (float)time;

@end
