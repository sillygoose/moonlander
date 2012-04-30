//
//  L0AppDelegate.m
//  Moonlander
//
//  Created by Rick Naro on 4/30/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "L0AppDelegate.h"


// Ensures the shake is strong enough on at least two axes before declaring it a shake.
// "Strong enough" means "greater than a client-supplied threshold" in G's.
static BOOL L0AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold)
{
	double deltaX = fabs(last.x - current.x);
    double deltaY = fabs(last.y - current.y);
    double deltaZ = fabs(last.z - current.z);
    
	return (deltaX > threshold && deltaY > threshold) || (deltaX > threshold && deltaZ > threshold) || (deltaY > threshold && deltaZ > threshold);
}


@implementation L0AppDelegate

@synthesize hysteresisExcited=_hysteresisExcited;
@synthesize lastAcceleration=_lastAcceleration;


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[UIAccelerometer sharedAccelerometer].delegate = self;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if (self.lastAcceleration) {
		if (!self.hysteresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.7)) {
			self.hysteresisExcited = YES;
            
			// Shake detected - end game
            //###
		}
        else if (self.hysteresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
			self.hysteresisExcited = NO;
		}
	}
    
	self.lastAcceleration = acceleration;
}

@end