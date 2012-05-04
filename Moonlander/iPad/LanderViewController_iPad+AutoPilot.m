//
//  LanderViewController_iPad+AutoPilot.m
//  Moonlander
//
//  Created by Rick Naro on 5/3/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "LanderViewController_iPad+AutoPilot.h"

@implementation LanderViewController_iPad (AutoPilot)

const float AutoPilotUpdateInterval = 0.10;         // How often the autopilot control law execute


// This is where we want to land
const short TargetVerticalPosition = 0;
const short TargetHorizontalPosition = -200;


- (void)calculateVerticalControls
{
    float vpOutput = self.autoPilot.verticalPosition.output;
    float vvOutput = self.autoPilot.verticalVelocity.output;
    
    // Some state data
    float landerWeight = self.WEIGHT;
    float maxThrust = self.MAXTHRUST;
    //float thrustAngle = self.ANGLE;
    //float cosThrustAngle = cos(thrustAngle);
    float lunarGravity = self.GRAVITY;
    float forceDueToGravity = (landerWeight / 32) * lunarGravity;
    
    // First the thrust to hold position against gravity (then fudge it)
    float neededThrust = forceDueToGravity / 2;
    float thrustFromVelocity = 0;
    
    // Clamp since we need to have in the range (-1,1)
    if (vpOutput > 1)
        vpOutput = 1;
    else if (vpOutput < -1)
        vpOutput = -1;

    // Calculate the velocity gain for when speed is out of whack with distance
    float vGain = (vpOutput == 0.0) ? 10 : fabs(vvOutput/vpOutput) ;
    neededThrust += thrustFromVelocity = -(1 - vpOutput) * vvOutput * maxThrust * vGain;
    
    // Land with some velocity
    //NSLog(@"Alt: %d  vpOutput: %f, vvOutput: %f  tV: %5.0f  vG: %4.3f", self.VERDIS, vpOutput, vvOutput, thrustFromVelocity, vGain);
    
    // Save the vertical trhust component
    self.autoPilot.verticalThrustRequested = neededThrust;
}

- (void)calculateHorizontalControls
{
    //float hpOutput = self.autoPilot.horizontalPosition.output;
    //float hvOutput = self.autoPilot.horizontalVelocity.output;
    //NSLog(@"hpOutput: %f, hvOutput: %f", hpOutput, hvOutput);
    
    // Save the vertical trhust component
    float neededThrust = 0;
    self.autoPilot.horizontalThrustRequested = neededThrust;
}

- (void)stepAutoPilot
{
    if ([self.landerModel onSurface]) {
        // Shut down
        [self autoPilotChange];
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
        float thrustAngle = atanf(thrustAngleRatio);
        float thrustAngleDegrees = thrustAngle  * 180 / M_PI;
        self.ANGLED = (short)thrustAngleDegrees;
    }
}

- (float)vpSetPoint
{
    return self.autoPilot.targetAltitude;
}

- (float)vpProcessValue
{
    float vAltitude = self.RADARY;
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

- (void)initializePIDControllers
{
    self.autoPilot.verticalPosition.setPoint = [^{ return [self vpSetPoint];} copy];
    self.autoPilot.verticalPosition.processValue = [^{ return [self vpProcessValue];} copy];
    self.autoPilot.verticalPosition.Kp = -1.0 / 20000.0;
    self.autoPilot.verticalPosition.Kd = 0;
    
    self.autoPilot.verticalVelocity.setPoint = [^{ return [self vvSetPoint];} copy];
    self.autoPilot.verticalVelocity.processValue = [^{ return [self vvProcessValue];} copy];
    self.autoPilot.verticalVelocity.Kp = -1.0 / 500.0;
    self.autoPilot.verticalVelocity.Kd = 0;
    
    self.autoPilot.horizontalPosition.setPoint = [^{ return [self hpSetPoint];} copy];
    self.autoPilot.horizontalPosition.processValue = [^{ return [self hpProcessValue];} copy];
    self.autoPilot.horizontalPosition.Kp = 1.0 / 1000.0;
    self.autoPilot.horizontalPosition.Kd = 0;

    self.autoPilot.horizontalVelocity.setPoint = [^{ return [self hvSetPoint];} copy];
    self.autoPilot.horizontalVelocity.processValue = [^{ return [self hvProcessValue];} copy];
    self.autoPilot.horizontalVelocity.Kp = 1.0 / 1000.0;
    //self.autoPilot.horizontalVelocity.Kd = 0;

    [self.autoPilot setup];
}

- (IBAction)autoPilotChange
{
    self.autoPilot.enabled = !self.autoPilot.enabled;
    self.autoPilotSwitch.titleLabel.blink = self.autoPilot.enabled;
    if (self.autoPilot.enabled == YES) {
        // Set the destinations
        self.autoPilot.targetAltitude = TargetVerticalPosition;
        self.autoPilot.targetRange = TargetHorizontalPosition;
        
        // Initialize PID controllers
        [self initializePIDControllers];
        
        // Prepare for autopilot
        [self disableRollFlightControls];
        [self disableThrustFlightControls];
        self.autoPilotTimer = [NSTimer scheduledTimerWithTimeInterval:AutoPilotUpdateInterval target:self selector:@selector(stepAutoPilot) userInfo:nil repeats:YES];
    }
    else {
        [self.autoPilotTimer invalidate];
        self.autoPilotTimer = nil;
        [self enableRollFlightControls];
        [self enableThrustFlightControls];
    }
}

@end
