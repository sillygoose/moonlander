//
//  Lander.h
//  Moonlander
//
//  Created by Rick on 5/24/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGView.h"

typedef short (^thrust_percent_t)();
typedef short (^thrust_data_t)();
typedef float (^angle_data_t)();

@interface Lander : VGView {
    VGView              *_thrust;
    
    thrust_percent_t    _thrustPercent;
    thrust_data_t       _thrustData;
    angle_data_t        _angleData;
    
    float               _previousAngle;
    
@private
    int                 _FRAND;
    int                 _FSHIFT;
    int                 _FlameLine;
    int                 _FlameIntensity;
}

@property (nonatomic, strong) VGView *thrust;

@property (nonatomic, copy) thrust_percent_t thrustPercent;
@property (nonatomic, copy) thrust_data_t thrustData;
@property (nonatomic, copy) angle_data_t angleData;

@property (nonatomic) float previousAngle;

@property (nonatomic) int FRAND;
@property (nonatomic) int FSHIFT;
@property (nonatomic) int flameLine;
@property (nonatomic) int flameIntensity;

- (id)init;

-(void)updateLander;

@end
