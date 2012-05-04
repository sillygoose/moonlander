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
const short targetVerticalPosition = 0;
const short targetHorizontalPosition = -200;


- (void)calculateVerticalControls
{
    float vpOutput = self.autoPilot.verticalPosition.output;
    float vvOutput = self.autoPilot.verticalVelocity.output;
    
    // Some state data
    float landerWeight = self.WEIGHT;
    float maxThrust = self.MAXTHRUST;
    float thrustAngle = self.ANGLE;
    float cosThrustAngle = cos(thrustAngle);
    float lunarGravity = self.GRAVITY;
    float forceDueToGravity = (landerWeight / 32) * lunarGravity;
    
    // Land with some velocity
    vvOutput -= -12;
    NSLog(@"vpOutput: %f, vvOutput: %f", vpOutput, vvOutput);
    
    float neededThrust = ((1.3 * forceDueToGravity) / maxThrust) * 100;
    if (vpOutput < 20) {
        neededThrust = 2.0 * vvOutput;
    }
    else if (vpOutput < 50) {
        neededThrust = 2.3 * vvOutput;
    }
    else if (vpOutput < 100) {
        neededThrust = 1.8 * vvOutput;
    }
    else if (vpOutput < 200) {
        neededThrust = 1.3 * vvOutput;
    }
    else if (vpOutput < 500) {
        neededThrust = 1.0 * vvOutput;
    }
    else if (vpOutput < 1000) {
        neededThrust = ((1.5 * forceDueToGravity) / maxThrust) * 100;
    }
    else if (vpOutput < 2500) {
        neededThrust = ((1.75 * forceDueToGravity) / maxThrust) * 100;
    }
    else if (vpOutput < 5000) {
        neededThrust = ((2 * forceDueToGravity) / maxThrust) * 100;
    }
    
    neededThrust = (cosThrustAngle != 0.0) ? neededThrust / cosThrustAngle : 100;
    self.PERTRS = (short)(fabs(neededThrust));
}

- (void)calculateHorizontalControls
{
    float hpOutput = self.autoPilot.horizontalPosition.output;
    float hvOutput = self.autoPilot.horizontalVelocity.output;
    NSLog(@"hpOutput: %f, hvOutput: %f", hpOutput, hvOutput);
    
}

- (void)stepAutoPilot
{
    if ([self.landerModel onSurface]) {
        [self autoPilotChange];
    }
    else {
        // Update the controllers
        [self.autoPilot step:AutoPilotUpdateInterval];
        
        [self calculateVerticalControls];
        [self calculateHorizontalControls];
        
    #if 0
        // Calculate a thrust angle
        float hOutput = self.autoPilot.horizontalPosition.output;
        float vOutput = self.autoPilot.horizontalVelocity.output;

        // Limiting
        if (hOutput < -10.0)
            hOutput = -10.0;
        else if (hOutput > 100.0)
            hOutput = 10.0;
        
        if (vOutput < -10.0)
            vOutput = -10.0;
        else if (vOutput > 10.0)
            vOutput = 10.0;
        NSLog(@"houtput: %f, voutput: %f", hOutput, vOutput);
        
        // Roll angle partitioning
        float angleHOutput = -atanf(hOutput);
        float angleVOutput = atanf(vOutput);
        angleHOutput = angleHOutput * 180.0 / M_PI;
        angleVOutput = angleVOutput * 180.0 / M_PI;
        
    #if 0
        if (vOutput > 2.0) {
            hOutput = vOutput;
            angleHOutput = angleVOutput;
        }
        else if (vOutput < -2.0) {
            hOutput = vOutput;
            angleHOutput = angleVOutput;
        }
    #endif
        NSLog(@"hangle: %f, vangle: %f", angleHOutput, angleVOutput);
        
        float thrustAngle = angleVOutput - angleHOutput;
    //    thrustAngle = -90;

        // Roll angle has rate limits we must enforce
        float deltaAngle = ((float)self.ANGLED - thrustAngle) * 1;
        
        // Thruster limits
        float newThrust = fabs(hOutput) * 100;
        if (newThrust > 100)
            newThrust = 100;
        else if (newThrust < 10)
            newThrust = 10;
        
        // Update the control outputs
        self.PERTRS = newThrust;
        [self.thrusterSlider setValue:self.PERTRS];
        self.ANGLED -= (short)deltaAngle;
#endif
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
    self.autoPilot.verticalPosition.Kp = -1.0 / 1.0;
    self.autoPilot.verticalPosition.Kd = 0;
    
    self.autoPilot.verticalVelocity.setPoint = [^{ return [self vvSetPoint];} copy];
    self.autoPilot.verticalVelocity.processValue = [^{ return [self vvProcessValue];} copy];
    self.autoPilot.verticalVelocity.Kp = -1.0 / 1.0;
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
        self.autoPilot.targetAltitude = 0;
        self.autoPilot.targetRange = -200;
        
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
