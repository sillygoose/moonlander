//
//  Lander.h
//  Moonlander
//
//  Created by Rick on 5/24/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGView.h"

typedef float (^thrust_data_t)();
typedef float (^angle_data_t)();
typedef CGPoint (^position_data_t)();

@interface Lander : VGView {
    VGView          *_thrust;
    thrust_data_t   _thrustData;
    angle_data_t    _angleData;
    position_data_t _positionData;
    float           _previousAngle;
    
@private
    int             _flameRandom;
    int             _FlameShift;
    int             _FlameLine;
    int             _FlameIntensity;
    
    NSNumber        *_x;
    NSNumber        *_y;
}

@property (nonatomic, retain) VGView *thrust;
@property (nonatomic, copy) thrust_data_t thrustData;
@property (nonatomic, copy) angle_data_t angleData;
@property (nonatomic, copy) position_data_t positionData;
@property (nonatomic) float previousAngle;

@property (nonatomic) int flameRandom;
@property (nonatomic) int flameShift;
@property (nonatomic) int flameLine;
@property (nonatomic) int flameIntensity;
@property (nonatomic, retain) NSNumber *x;
@property (nonatomic, retain) NSNumber *y;

- (id)init;

-(void)updateLander;

@end
