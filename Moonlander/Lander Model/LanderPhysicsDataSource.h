//
//  LanderPhysicsProtocol.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LanderPhysicsDataSource <NSObject>

- (CGPoint)position;
- (float)rotation;
- (float)thrust;

- (void)setThrust:(float)thrust;
- (void)setRotation:(float)rotation;

- (float)updateTime:(float)timeInterval;

@end
