//
//  Autopilot.h
//  Moonlander
//
//  Created by Rick Naro on 5/3/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PIDController.h"


@interface Autopilot : NSObject
{
    float               _targetAltitude;
    float               _targetRange;

    float               _currentRange;
    
    BOOL                _enabled;

    PIDController       *_verticalPosition;
    PIDController       *_verticalVelocity;
    
    PIDController       *_horizontalPosition;
    PIDController       *_horizontalVelocity;
    
    float               _verticalThrustRequested;
    float               _horizontalThrustRequested;
}

@property (nonatomic) float targetAltitude;
@property (nonatomic) float targetRange;

@property (nonatomic) float currentRange;

@property (nonatomic) BOOL enabled;

@property (nonatomic, strong) PIDController *verticalPosition;
@property (nonatomic, strong) PIDController *verticalVelocity;

@property (nonatomic, strong) PIDController *horizontalPosition;
@property (nonatomic, strong) PIDController *horizontalVelocity;

@property (nonatomic) float verticalThrustRequested;
@property (nonatomic) float horizontalThrustRequested;


- (id)init;

- (void)setup;
- (void)step:(float)dt;

@end
