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

@synthesize completionBlock=_completionBlock;
@synthesize queueDelay=_queueDelay;
@synthesize beepCount=_beepCount;

@synthesize delegate=_delegate;


const short MaximumRadius = 192;            // 300 octal in program
const short RadiusIncrement1 = 33;
const short RadiusIncrement2 = -10;


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
    const float DelayInSeconds = 0.05;
    const float PhosphorDecay = 0.7;
    
    // Create the explosion views
    short radius = 0;
    short radiusIncrement = RadiusIncrement2;
    
    // Create a queue and group for the tasks
    dispatch_queue_t explosionQueue = dispatch_queue_create("com.devtools.moonlander.explode", NULL);
    dispatch_queue_t animateQueue = dispatch_queue_create("com.devtools.moonlander.animate", NULL);
    
    // Block handler to signal all done
    void (^animateComplete)(void) = ^{
        // Free up the queue we created and call our completion block
        dispatch_release(animateQueue);
        dispatch_async(dispatch_get_main_queue(), ^{self.completionBlock();});
    };
    
    // Queue up a task to mark the end of the view queuing process
    void (^explosionComplete)(void) = ^{
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.queueDelay);
        dispatch_after(popTime, animateQueue, animateComplete);
    };
    
    // Run thru and create the views
    while (radius < MaximumRadius) {
        // Block variables for the view manager
        __block Explosion *explosionView;
        
        void (^animateExplosionView)(void) = ^{
            // Use a block animation to fade the alpha to zero
            int count = [self.explosionViews count];
            if (count) {
                // Get the view and make visible
                __block Explosion *theView = [self.explosionViews objectAtIndex:0];
                
                // UI code so runs on the main queue
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Start working with the view
                    [self.parentView addSubview:explosionView];
                    theView.hidden = NO;

                    // Use a block animation to fade the view
                    [Explosion animateWithDuration:PhosphorDecay
                                            animations:^{theView.alpha = 0.0;}
                                            completion:^(BOOL finished){ [theView removeFromSuperview];}];
                });
                
                // Remove this view from the array
                [self.explosionViews removeObjectAtIndex:0];
            }
        };
        
        // Block to create and populate views
        void (^createExplosionView)(void) = ^{
            //### Create an explosion view
            float explosionSize = self.currentRadius * 2;
            float xPos = self.delegate.SHOWX - explosionSize / 2;
            float yPos = (768 - self.delegate.SHOWY) - explosionSize / 4;
            //###
            CGRect frameRect = CGRectMake(xPos, yPos, explosionSize, explosionSize);
            dispatch_sync(dispatch_get_main_queue(), ^{explosionView = [[Explosion alloc] initWithFrame:frameRect];});
           
            // Populate the view with dust
            [explosionView EXGEN:self.currentRadius];
            
            // Update the radius for the next view
            self.currentRadius += self.radiusIncrement;
            self.radiusIncrement = (self.radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
            
            // Add to our array of explosion views
            [self.explosionViews addObject:explosionView];

            // Now create a dispatch event to make the view visible
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.queueDelay);
            dispatch_after(popTime, animateQueue, animateExplosionView);

            // Need a beep on every other explosion pass
            if (self.beepCount++ % 2) {
                dispatch_after(popTime, dispatch_get_main_queue(), ^{[self.delegate beep];});
            }

            // Adjust the delay for the next view
            self.queueDelay += DelayInSeconds * NSEC_PER_SEC;
        };
        
        // Add the view to a queue to be populated
        dispatch_async(explosionQueue, createExplosionView);
        
        // Add to our array of explosion views
        radius += radiusIncrement;
        radiusIncrement = (radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
    }

    // Mark that the queue is filled
    dispatch_async(explosionQueue, explosionComplete);

    // Free up the queue we created
    dispatch_release(explosionQueue);
}

@end