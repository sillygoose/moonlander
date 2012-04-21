//
//  ExplosionManager.m
//  Moonlander
//
//  Created by Rick Naro on 4/16/12.
//  Copyright (c) 2012 Paradigm Systems . All rights reserved.
//

#import "ExplosionManager.h"

@implementation ExplosionManager

@synthesize explosionViews=_explosionViews;
@synthesize parentView=_parentView;

@synthesize currentRadius=_currentRadius;
@synthesize radiusIncrement=_radiusIncrement;

@synthesize dispatchQueue=_dispatchQueue;
@synthesize completionBlock=_completionBlock;
@synthesize queueDelay=_queueDelay;
@synthesize beepCount=_beepCount;

@synthesize delegate=_delegate;


const short MaximumRadius = 200;
const short RadiusIncrement1 = 33;
const short RadiusIncrement2 = -10;

const float AnimateExplosionTimer = 0.075;
const float AgeExplosionTimer = 0.2;
const float DeltaAlpha = 0.05;



- (id)init
{
    self = [super init];
    if (self) {
        // Create our array of views we will be managing
        self.explosionViews = [NSMutableArray array];

        // Our initial values for expansion code
        self.currentRadius = 0;
        self.radiusIncrement = RadiusIncrement2;
    }
    return self;
}

- (void)start
{
    const float DelayInSeconds = 0.04;
    const float PhosphorDecay = 0.4;
    
    // Create the explosion views
    short radius = 0;
    short radiusIncrement = RadiusIncrement2;
    while (radius < MaximumRadius) {
        // Block variables for the view manager
        __block Explosion *explosionView;
        
        void (^animateExplosionView)(void) = ^{
            // Use a block animation to fade the alpha to zero
            int count = [self.explosionViews count];
            if (count) {
                // Need a beep every othger pass
                if (self.beepCount++ % 2) {
                    [self.delegate beep];
                }

                // Create the new view
                __block Explosion *theView = [self.explosionViews objectAtIndex:0];
                [self.explosionViews removeObjectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    theView.hidden = NO;
                    [Explosion animateWithDuration:PhosphorDecay
                                        animations:^{theView.alpha = 0.0;}
                                        completion:^(BOOL finished){ [theView removeFromSuperview]; }];
                });
                
                // Call the completion block
                count = [self.explosionViews count];
            }
            if (count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.completionBlock();
                });
            }
        };
        
        // Block to create and populate views
        void (^createExplosionView)(void) = ^{
            // Create an explosion view
            float explosionSize = self.currentRadius * 2;
            float xPos = self.delegate.SHOWX - explosionSize / 2;
            float yPos = (768 - self.delegate.SHOWY) - explosionSize / 4;
            CGRect frameRect = CGRectMake(xPos, yPos, explosionSize, explosionSize);
            dispatch_sync(dispatch_get_main_queue(), ^{explosionView = [[Explosion alloc] initWithFrame:frameRect];});
           
            // View display settings
            explosionView.radius = self.currentRadius;
            explosionView.alpha = (float)((random() % 40)/100.0)+ 0.6;
            explosionView.hidden = YES;
            [explosionView EXGEN];
            
            // Update the radius for the next view
            self.currentRadius += self.radiusIncrement;
            self.radiusIncrement = (self.radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
            
            // Add to our array of explosion views
            [self.explosionViews addObject:explosionView];

            // Add the view to the parent
            dispatch_async(dispatch_get_main_queue(), ^{[self.parentView addSubview:explosionView];});
            
            // Now create a dispatch to make the view visible
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.queueDelay);
            dispatch_after(popTime, self.dispatchQueue, animateExplosionView);
            //NSLog(@"createExplosionView: %d for execution in %llu msecs", self.currentRadius, (self.queueDelay / USEC_PER_SEC));

            // Adjust the delay for the next view
            self.queueDelay += DelayInSeconds * NSEC_PER_SEC;
        };
        
        // Add the view to a queue to be populated
        dispatch_async(self.dispatchQueue, createExplosionView);
        
        // Add to our array of explosion views
        radius += radiusIncrement;
        radiusIncrement = (radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
    }
}

@end