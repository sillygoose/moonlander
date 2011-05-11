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

- (float)rotation;
- (float)rotationDegrees;
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
- (void)setRotation:(float)rotation;

- (float)updateTime:(float)timeInterval;

@end
