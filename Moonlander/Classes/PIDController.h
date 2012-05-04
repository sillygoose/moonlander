//
//  PIDController.h
//  Moonlander
//
//  Created by Rick Naro on 5/3/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef float (^process_data_t)();


@interface PIDController : NSObject
{
    float           _Kp;
    float           _Kd;
    float           _Ki;
    
    process_data_t  _setPoint;
    process_data_t  _processValue;
    float           _output;
    
    float           _previousError;
    float           _integral;
}

@property (nonatomic) float Kp;
@property (nonatomic) float Kd;
@property (nonatomic) float Ki;

@property (nonatomic, copy) process_data_t setPoint;
@property (nonatomic, copy) process_data_t processValue;
@property (nonatomic) float output;

@property (nonatomic) float previousError;
@property (nonatomic) float integral;


- (id)init;

- (void)setup;
- (void)step:(float)dt;

@end
