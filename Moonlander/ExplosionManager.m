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

@synthesize createQueue= _createQueue;
@synthesize animateQueue=_animateQueue;
@synthesize completionBlock=_completionBlock;

@synthesize currentRadius=_currentRadius;
@synthesize radiusIncrement=_radiusIncrement;
@synthesize queueDelay=_queueDelay;
@synthesize beepCount=_beepCount;

@synthesize delegate=_delegate;


const short MaximumRadius = 200;
const short RadiusIncrement1 = 33;
const short RadiusIncrement2 = -10;



- (id)init
{
    self = [super init];
    if (self) {
        // Create our array of views we will be managing
        self.explosionViews = [NSMutableArray array];

        // Create a queue for the animation views
        self.createQueue = dispatch_queue_create("com.devtools.moonlander.explode.create", NULL);
        self.animateQueue = dispatch_queue_create("com.devtools.moonlander.explode.animate", NULL);

        // Our initial values for expansion code
        self.currentRadius = 0;
        self.radiusIncrement = RadiusIncrement2;
    }
    return self;
}

- (void)start
{
    const float DelayInSeconds = 0.05;
    const float PhosphorDecay = .7;
    
    __block BOOL allViewsCreated = NO;
    void (^viewsCreated)(void) = ^{
        allViewsCreated = YES;
    };

    // Create the explosion views
    short radius = 0;
    short radiusIncrement = RadiusIncrement2;
    
    // Create a queue and group for the tasks
    dispatch_queue_t explosionQueue = dispatch_queue_create("com.devtools.moonlander.explode", NULL);
    
    while (radius < MaximumRadius) {
        // Block variables for the view manager
        __block Explosion *explosionView;
        void (^animateExplosionView)(void) = ^{
            // Use a block animation to fade the alpha to zero
            int count = [self.explosionViews count];
            if (count) {
                // Need a beep on every other explosion pass
                if (self.beepCount++ % 2) {
                    [self.delegate beep];
                }

                // Get the view and make visible
                __block Explosion *theView = [self.explosionViews objectAtIndex:0];
                [self.parentView addSubview:explosionView];
                theView.hidden = NO;

                // Pop this view from the array
                [self.explosionViews removeObjectAtIndex:0];

                // USe a block animation to fade the view
                [Explosion animateWithDuration:PhosphorDecay
                                        animations:^{theView.alpha = 0.0;}
                                        completion:^(BOOL finished){ [theView removeFromSuperview]; }];
                });
            }
            
            // Should be zero when all queues are posted
            if (allViewsCreated && [self.explosionViews count] == 0) {
                // This matters but I need to figure it out
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.completionBlock();
                });
                
                // Release the queues
                dispatch_release(self.createQueue);
                dispatch_release(self.animateQueue);
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
           
            // Populate the view with dust
            [explosionView EXGEN:self.currentRadius];
            
            // Update the radius for the next view
            self.currentRadius += self.radiusIncrement;
            self.radiusIncrement = (self.radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
            
            // Add to our array of explosion views
            [self.explosionViews addObject:explosionView];

            // Now create a dispatch event to make the view visible
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.queueDelay);
            dispatch_after(popTime, self.animateQueue, animateExplosionView);
            //NSLog(@"createExplosionView: %d for execution in %llu msecs", self.currentRadius, (self.queueDelay / USEC_PER_SEC));

            // Adjust the delay for the next view
            self.queueDelay += DelayInSeconds * NSEC_PER_SEC;
        };
        
        // Add the view to a queue to be populated
        dispatch_async(self.createQueue, createExplosionView);
        
        // Add to our array of explosion views
        radius += radiusIncrement;
        radiusIncrement = (radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
    }
    
    // Execuate a block to let us know all views are created
    dispatch_async(self.createQueue, viewsCreated);
}

- (void)EXGEN:(Explosion *)view
{
    const int YUpDown[] = { 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1 };
    const size_t DimYUpDown = sizeof(YUpDown)/sizeof(YUpDown[0]);
    const float StartingAngle = DegreesToRadians(150);
    const float AngleIncrement = DegreesToRadians(1);
    
    float angle = StartingAngle;
    short count = 241;
    float centerX = view.bounds.size.width / 2;
    float centerY = view.bounds.size.height / 2;
    
    // Allocate our path array
    NSMutableArray *path = [[NSMutableArray alloc] init];
    NSArray *paths = [NSArray arrayWithObject:path];
    
    // Prep the intensity and line type info
    short radius = view.radius;

    //(EXGENL)
    while (count > 0) {
        // We skip fooling around and just randomize this
        short randomIndex = random() % DimYUpDown;
        short TEMP = YUpDown[randomIndex];
        TEMP += radius;
        if (TEMP >= 0) {
            short X = TEMP * cos(angle) + centerX;
            short Y = TEMP * sin(angle) + centerY;
            if (X >= 0 && Y >= 0) {
                // Create our display point
                NSNumber *x = [NSNumber numberWithInt:X];
                NSNumber *y = [NSNumber numberWithInt:Y];
                
                // Default size for a rectangle is 1 x 1
                NSDictionary *originItem = [NSDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil];
                NSDictionary *rectItem = [NSDictionary dictionaryWithObjectsAndKeys:originItem, @"origin", nil];
                NSDictionary *pathItem = [NSDictionary dictionaryWithObjectsAndKeys:rectItem, @"rect", nil];
                [path addObject:pathItem];
            }
        }
        
        //(EXGEND)
        angle += AngleIncrement;
        count--;
    }
    
    // Add the draw paths and update the display
    view.drawPaths = paths;
    //###dispatch_async(dispatch_get_main_queue(), ^{[view setNeedsDisplay];});
}

@end