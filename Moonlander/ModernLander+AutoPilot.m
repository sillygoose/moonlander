//
//  ModernLander+AutoPilot.m
//  Moonlander
//
//  Created by Rick Naro on 5/3/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//

#import "ModernLander+AutoPilot.h"

@implementation ModernLanderViewController (AutoPilot)

#ifdef DEBUG
//#define DEBUG_AUTOPILOT
//#define DEBUG_HORIZONTAL_AUTOPILOT
//#define DEBUG_VERTICAL_AUTOPILOT

// This is where we want to land
const short TargetVerticalPosition = 0;
const short TargetHorizontalPosition = 1000;
#endif

const float AutoPilotUpdateInterval = 0.10;         // How often the autopilot control law execute



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
    float vpOutput = self.autoPilot.verticalPosition.output;
    float vvOutput = self.autoPilot.verticalVelocity.output;
    
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
    self.autoPilot.verticalThrustRequested = neededThrust;
}

- (void)calculateHorizontalControls
{
    // First the thrust to hold position against gravity (then fudge it)
    float neededThrust = 0;
    
#ifndef DEBUG_VERTICAL_AUTOPILOT
    // Some state data we use
    float maxThrust = self.MAXTHRUST;
    
    // PID controller outputs
    float hpOutput = self.autoPilot.horizontalPosition.output;
    float hvOutput = self.autoPilot.horizontalVelocity.output;

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
    self.autoPilot.horizontalThrustRequested = neededThrust;
}

- (void)stepAutoPilot
{
    if ([self.landerModel onSurface]) {
        // Shut down
        [self autoPilotShutdown];
    }
    else {
        // Update the controllers
        [self.autoPilot step:AutoPilotUpdateInterval];
        
        [self calculateVerticalControls];
        [self calculateHorizontalControls];
        
        // Set the control outputs
        float verticalThrustRequested = self.autoPilot.verticalThrustRequested;
        float horizontalThrustRequested = self.autoPilot.horizontalThrustRequested;
        
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
        const float MaxThrustAngle = 80.0;
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
        
        self.autoPilotTimer = [NSTimer scheduledTimerWithTimeInterval:AutoPilotUpdateInterval target:self selector:@selector(stepAutoPilot) userInfo:nil repeats:NO];
    }
}

- (float)vpSetPoint
{
    return self.autoPilot.targetAltitude;
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
    return self.autoPilot.targetRange;
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
    __weak ModernLanderViewController *weakSelf = self;
    self.autoPilot.verticalPosition.setPoint = [^{ return [weakSelf vpSetPoint];} copy];
    self.autoPilot.verticalPosition.processValue = [^{ return [weakSelf vpProcessValue];} copy];
    self.autoPilot.verticalPosition.Kp = -1.0 / 20000.0;
    self.autoPilot.verticalPosition.Kd = 0;
    [self.autoPilot setup];
}

- (void)initializePIDControllers
{
    __weak ModernLanderViewController *weakSelf = self;
    
    self.autoPilot.verticalPosition.setPoint = [^{ return [weakSelf vpSetPoint];} copy];
    self.autoPilot.verticalPosition.processValue = [^{ return [weakSelf vpProcessValue];} copy];
    self.autoPilot.verticalPosition.Kp = -1.0 / 10000.0;
    self.autoPilot.verticalPosition.Kd = 0;
    
    self.autoPilot.verticalVelocity.setPoint = [^{ return [weakSelf vvSetPoint];} copy];
    self.autoPilot.verticalVelocity.processValue = [^{ return [weakSelf vvProcessValue];} copy];
    self.autoPilot.verticalVelocity.Kp = -1.0 / 500.0;
    self.autoPilot.verticalVelocity.Kd = 0;
    
    self.autoPilot.horizontalPosition.setPoint = [^{ return [weakSelf hpSetPoint];} copy];
    self.autoPilot.horizontalPosition.processValue = [^{ return [weakSelf hpProcessValue];} copy];
    self.autoPilot.horizontalPosition.Kp =  -1.0 / 18000.0;
    self.autoPilot.horizontalPosition.Kd = 0;
    
    self.autoPilot.horizontalVelocity.setPoint = [^{ return [weakSelf hvSetPoint];} copy];
    self.autoPilot.horizontalVelocity.processValue = [^{ return [weakSelf hvProcessValue];} copy];
    self.autoPilot.horizontalVelocity.Kp = -1.0 / 1000.0;
    //self.autoPilot.horizontalVelocity.Kd = 0;
    
    [self.autoPilot setup];
}

- (IBAction)autoPilotChange
{
    self.autoPilot.enabled = !self.autoPilot.enabled;
    self.autoPilotSwitch.titleLabel.blink = self.autoPilot.enabled;
    if (self.autoPilot.enabled == YES) {
#ifdef DEBUG_AUTOPILOT
        // Set the destinations
        self.autoPilot.targetAltitude = TargetVerticalPosition;
        self.autoPilot.targetRange = TargetHorizontalPosition;
#else
        // Pick a random destination
        self.autoPilot.targetAltitude = 0;
        self.autoPilot.targetRange = 750 - (random() % 1500);
#endif
        
        // Initialize PID controllers
        [self initializePIDControllers];
        
        // Prepare for autopilot
        [self disableRollFlightControls];
        [self disableThrustFlightControls];
        self.autoPilotTimer = [NSTimer scheduledTimerWithTimeInterval:AutoPilotUpdateInterval target:self selector:@selector(stepAutoPilot) userInfo:nil repeats:NO];
    }
    else {
        // Disengage the autopilot
        [self.autoPilotTimer invalidate];
        self.autoPilotTimer = nil;
        [self enableRollFlightControls];
        [self enableThrustFlightControls];
    }
}

- (void)autoPilotShutdown
{
    self.autoPilot.enabled = NO;
    self.autoPilotSwitch.titleLabel.blink = self.autoPilot.enabled;

    // Disengage the autopilot
    [self.autoPilotTimer invalidate];
    self.autoPilotTimer = nil;
    [self enableRollFlightControls];
    [self enableThrustFlightControls];
}

@end
