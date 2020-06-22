//
//  AutoPilotViewController+Autopilot.m
//  Moonlander
//
//  Created by Silly Goose on 12/6/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//

#import "AutoPilotViewController+Autopilot.h"

@implementation AutoPilotViewController (Autopilot)

#ifdef DEBUG
//#define DEBUG_AUTOPILOT
//#define DEBUG_HORIZONTAL_AUTOPILOT
//#define DEBUG_VERTICAL_AUTOPILOT
#endif

const float MenuAutoPilotUpdateInterval = 0.10;         // How often the autopilot control law execute



- (void)calculateVerticalControls
{
    // First the thrust to hold position against gravity (then fudge it)
    float neededThrust = 0;
    
#ifndef DEBUG_HORIZONTAL_AUTOPILOT
    // Some state data we use
    float landerWeight = self.WEIGHT;
    float maxThrust = self.MAXTHRUST;
    float lunarGravity = self.GRAVITY;
    float forceDueToGravity = (landerWeight / 32) * lunarGravity;
    
    // PID controller outputs
    float vpOutput = self.backgroundAutoPilot.verticalPosition.output;
    float vvOutput = self.backgroundAutoPilot.verticalVelocity.output;
    
    // Clamp since we need to have in the range (-1,1)
    if (vpOutput > 1)
        vpOutput = 1;
    else if (vpOutput < -1)
        vpOutput = -1;
    
    // Correct for lunar gravity
    neededThrust += forceDueToGravity / 2;
    
    // Calculate the velocity gain for when speed is out of whack with distance
    float vGain = (vpOutput == 0.0) ? 10 : fabs(vvOutput/vpOutput) ;
    neededThrust += -(1 - vpOutput) * vvOutput * maxThrust * vGain;
    
#ifdef DEBUG_VERTICAL_AUTOPILOT
    NSLog(@"Alt: %d  vpOutput: %f, vvOutput: %f  tV: %5.0f  vG: %4.3f", self.VERDIS, vpOutput, vvOutput, neededThrust, vGain);
#endif
#endif
    
    // Save the vertical thrust component
    self.backgroundAutoPilot.verticalThrustRequested = neededThrust;
}

- (void)calculateHorizontalControls
{
    // First the thrust to hold position against gravity (then fudge it)
    float neededThrust = 0;
    
#ifndef DEBUG_VERTICAL_AUTOPILOT
    // Some state data we use
    float maxThrust = self.MAXTHRUST;
    
    // PID controller outputs
    float hpOutput = self.backgroundAutoPilot.horizontalPosition.output;
    float hvOutput = self.backgroundAutoPilot.horizontalVelocity.output;
    
    // Clamp since we need to have in the range (-1,1)
    if (hpOutput > 1)
        hpOutput = 1;
    else if (hpOutput < -1)
        hpOutput = -1;
    
    float hGain = (hpOutput == 0.0) ? 10 : fabs(hvOutput/hpOutput) ;
    neededThrust += -(1 - hpOutput) * hvOutput * maxThrust * hGain;
    
#ifdef DEBUG_HORIZONTAL_AUTOPILOT
    NSLog(@"Dis: %d  hpOutput: %f, hvOutput: %f  tV: %5.0f  vG: %4.3f", self.HORDIS, hpOutput, hvOutput, neededThrust, hGain);
#endif
#endif
    
    // Save the horizontal thrust component
    self.backgroundAutoPilot.horizontalThrustRequested = neededThrust;
}

- (void)stepAutoPilot
{
    if ([self.landerModel onSurface]) {
        // Shut down
        [self autoPilotShutdown];
    }
    else {
        // Update the controllers
        [self.backgroundAutoPilot step:MenuAutoPilotUpdateInterval];
        
        [self calculateVerticalControls];
        [self calculateHorizontalControls];
        
        // Set the control outputs
        float verticalThrustRequested = self.backgroundAutoPilot.verticalThrustRequested;
        float horizontalThrustRequested = self.backgroundAutoPilot.horizontalThrustRequested;
        
        // Calculate the resulant vector that contains our vertical and horizontal components
        float maxThrust = self.MAXTHRUST;
        float totalThrust = sqrt(horizontalThrustRequested * horizontalThrustRequested + verticalThrustRequested * verticalThrustRequested);
        totalThrust = (totalThrust / maxThrust) * 100;
        self.PERTRS = (short)totalThrust;
        
        // Find an angle that will provide the thrust components
        float thrustAngleRatio = 0;
        if (verticalThrustRequested != 0) {
            thrustAngleRatio = horizontalThrustRequested / verticalThrustRequested;
        }
        else {
            float signHorizontalThrust = (horizontalThrustRequested < 0) ? -1 : 1;
            thrustAngleRatio = 1000 * signHorizontalThrust;
        }
        float thrustAngle = atanf(thrustAngleRatio);
        float thrustAngleDegrees = thrustAngle  * 180 / M_PI;
        
        // Limit the maximum roll authority
        const float MaxThrustAngle = 70.0;
        if (fabs(thrustAngleDegrees) > MaxThrustAngle) {
            float signF = copysignf(1.0, thrustAngleDegrees);
            thrustAngleDegrees = MaxThrustAngle * signF;
        }
        
        // Limit the roll rate
        short previousRollAngle = self.ANGLED;
        short requestedRollAngle = (short)thrustAngleDegrees;
        short deltaRollAngle = previousRollAngle - requestedRollAngle;
        const short MaxRollRate = 1;
        short signD = (deltaRollAngle < 0) ? -1 : 1;
        if (abs(deltaRollAngle) > MaxRollRate) {
            deltaRollAngle = signD * MaxRollRate;
        }
        
        // Final roll angle output
        self.ANGLED -= deltaRollAngle;
        
        // Switch to low altitude PID
        if (self.RADARY < 1000) {
            [self lowAltitudePID];
        }
        
        self.backgroundAutoPilotTimer = [NSTimer scheduledTimerWithTimeInterval:MenuAutoPilotUpdateInterval target:self selector:@selector(stepAutoPilot) userInfo:nil repeats:NO];
    }
}

- (float)vpSetPoint
{
    return self.backgroundAutoPilot.targetAltitude;
}

- (float)vpProcessValue
{
    float vAltitude = self.VERDIS;
    return vAltitude;
}

- (float)vvSetPoint
{
    return 0;
}

- (float)vvProcessValue
{
    float vVelocity = self.VERVEL;
    return vVelocity;
}

- (float)hpSetPoint
{
    return self.backgroundAutoPilot.targetRange;
}

- (float)hpProcessValue
{
    float hRange = self.HORDIS;
    return hRange;
}

- (float)hvSetPoint
{
    return 0;
}

- (float)hvProcessValue
{
    float hVelocity = self.HORVEL;
    return hVelocity;
}

- (void)lowAltitudePID
{
    __weak AutoPilotViewController *weakSelf = self;
    self.backgroundAutoPilot.verticalPosition.setPoint = [^{ return [weakSelf vpSetPoint];} copy];
    self.backgroundAutoPilot.verticalPosition.processValue = [^{ return [weakSelf vpProcessValue];} copy];
    self.backgroundAutoPilot.verticalPosition.Kp = -1.0 / 18000.0;
    self.backgroundAutoPilot.verticalPosition.Kd = 0;
    [self.backgroundAutoPilot setup];
}

- (void)initializePIDControllers
{
    __weak AutoPilotViewController *weakSelf = self;
    
    self.backgroundAutoPilot.verticalPosition.setPoint = [^{ return [weakSelf vpSetPoint];} copy];
    self.backgroundAutoPilot.verticalPosition.processValue = [^{ return [weakSelf vpProcessValue];} copy];
    self.backgroundAutoPilot.verticalPosition.Kp = -1.0 / 8000.0;
    self.backgroundAutoPilot.verticalPosition.Kd = 0;
    
    self.backgroundAutoPilot.verticalVelocity.setPoint = [^{ return [weakSelf vvSetPoint];} copy];
    self.backgroundAutoPilot.verticalVelocity.processValue = [^{ return [weakSelf vvProcessValue];} copy];
    self.backgroundAutoPilot.verticalVelocity.Kp = -1.0 / 500.0;
    self.backgroundAutoPilot.verticalVelocity.Kd = 0;
    
    self.backgroundAutoPilot.horizontalPosition.setPoint = [^{ return [weakSelf hpSetPoint];} copy];
    self.backgroundAutoPilot.horizontalPosition.processValue = [^{ return [weakSelf hpProcessValue];} copy];
    self.backgroundAutoPilot.horizontalPosition.Kp =  -1.0 / 16000.0;
    self.backgroundAutoPilot.horizontalPosition.Kd = 0;
    
    self.backgroundAutoPilot.horizontalVelocity.setPoint = [^{ return [weakSelf hvSetPoint];} copy];
    self.backgroundAutoPilot.horizontalVelocity.processValue = [^{ return [weakSelf hvProcessValue];} copy];
    self.backgroundAutoPilot.horizontalVelocity.Kp = -1.0 / 1000.0;
    //self.autoPilot.horizontalVelocity.Kd = 0;
    
    [self.backgroundAutoPilot setup];
}

- (void)autoPilotShutdown
{
    // Disengage the autopilot
    self.backgroundAutoPilot.enabled = NO;
    [self.backgroundAutoPilotTimer invalidate];
    self.backgroundAutoPilotTimer = nil;
    [self enableRollFlightControls];
    [self enableThrustFlightControls];
}

- (void)enableAutoPilot
{
    self.backgroundAutoPilot.enabled = YES;
    
    // Pick a random destination
    self.backgroundAutoPilot.targetAltitude = 0;
    self.backgroundAutoPilot.targetRange = 750 - (random() % 1500);
#ifdef DEBUG_AUTOPILOT
    NSLog(@"target range: %f", self.backgroundAutoPilot.targetRange);
#endif
    
    // Initialize PID controllers
    [self initializePIDControllers];
    
    // Prepare for autopilot
    [self disableRollFlightControls];
    [self disableThrustFlightControls];
    self.backgroundAutoPilotTimer = [NSTimer scheduledTimerWithTimeInterval:MenuAutoPilotUpdateInterval target:self selector:@selector(stepAutoPilot) userInfo:nil repeats:NO];
}

- (void)disableAutoPilot
{
    self.backgroundAutoPilot.enabled = NO;
}

@end
