//
//  PIDController.m
//  Moonlander
//
//  Created by Rick Naro on 5/3/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//
//  previous_error = setpoint - process_feedback
//  integral = 0
//  start:
//      wait(dt)
//      error = setpoint - process_feedback
//      integral = integral + (error*dt)
//      derivative = (error - previous_error)/dt
//      output = (Kp*error) + (Ki*integral) + (Kd*derivative)
//      previous_error = error
//      goto start
// 

#import "PIDController.h"


@implementation PIDController

@synthesize Kp=_Kp;
@synthesize Kd=_Kd;
@synthesize Ki=_Ki;

@synthesize setPoint=_setPoint;
@synthesize processValue=_processValue;
@synthesize output=_output;

@synthesize previousError=_previousError;
@synthesize integral=_integral;


- (id)init
{
    self = [super init];
    if (self) {
        self.previousError = 0;
        self.integral = 0;
        
        self.Kp = 0;
        self.Kd = 0;
        self.Ki = 0;
    }
    return self;
}

- (void)setup
{
    self.previousError = self.setPoint() - self.processValue();;
    self.integral = 0;
}

- (void)step:(float)dt
{
    float error = self.setPoint() - self.processValue();
    self.integral += error * dt;
    float derivative = (error - self.previousError) / dt;
    self.output = self.Kp * error + self.Ki * self.integral + self.Kd * derivative;
    self.previousError = error;
}

@end
