//
//  LanderPhysicsDelegate.h
//  Moonlander
//
//  Created by Rick on 5/12/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanderPhysicsModel.h"


@protocol LanderPhysicsDelegate <NSObject>

- (void)initializeLanderModel;
- (float)updateTime:(float)timeInterval;
- (void)newGame;

- (void)landerDown;
- (void)landerTakeoff;

@end


