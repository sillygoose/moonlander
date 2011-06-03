//
//  LanderPhysicsDelegate.h
//  Moonlander
//
//  Created by Silly Goose on 5/12/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanderPhysicsModel.h"


@protocol LanderPhysicsDelegate <NSObject>
- (void)initializeLanderModel;
- (float)updateTime:(float)timeInterval;
- (void)newGame;
- (void)landerDown;
@end


