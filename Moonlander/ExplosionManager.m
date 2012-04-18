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
@synthesize phosphorTimer=_phosphorTimer;
@synthesize parentView=_parentView;

@synthesize groundZero=_groundZero;
@synthesize currentRadius=_currentRadius;
@synthesize radiusIncrement=_radiusIncrement;

@synthesize dispatchQueue=_dispatchQueue;
@synthesize tasks=_tasks;
@synthesize completionBlock=_completionBlock;
@synthesize queueDelay=_queueDelay;


const short MaximumRadius = 300;
const short RadiusIncrement1 = 33;
const short RadiusIncrement2 = -10;

const float AnimateExplosionTimer = 0.075;
const float AgeExplosionTimer = 0.1;
const float DeltaAlpha = 0.05;



// Helper routines for radians and degrees
static float DegreesToRadians(float degrees)
{
    return degrees * M_PI / 180;
}

static float RadiansToDegrees(float radians)
{
    return radians * 180 / M_PI;
}


- (id)init
{
    self = [super init];
    if (self) {
        // Create our array of views we will be managing
        self.explosionViews = [NSArray array];

        // Our initial values for expansion code
        self.currentRadius = 0;
        self.radiusIncrement = RadiusIncrement2;

        // And a timer to simulate the phosphor decay
        self.phosphorTimer = [NSTimer scheduledTimerWithTimeInterval:AgeExplosionTimer target:self selector:@selector(ageExplosionViews) userInfo:nil repeats:YES];
 }
    return self;
}

- (void)start
{
    // Create the explosion views
    short radius = 0;
    short radiusIncrement = RadiusIncrement2;
    while (radius < MaximumRadius) {
        __block Explosion *explosionView;
        void (^createExplosionView)(void) = ^{
            //NSLog(@"createExplosionView: %d", self.currentRadius);
            // Create an explosion view
            float explosionSize = self.currentRadius * 2;
            float xPos = self.groundZero.x - explosionSize / 2;
            float yPos = (768 - self.groundZero.y) - explosionSize / 2;
            CGRect frameRect = CGRectMake(xPos, yPos, explosionSize, explosionSize);
            dispatch_sync(dispatch_get_main_queue(), ^{explosionView = [[Explosion alloc] initWithFrame:frameRect];});
           
            explosionView.radius = self.currentRadius;
            explosionView.alpha = (float)((random() % 40)/100.0)+ 0.6;
            [self EXGEN:explosionView];
            
            // Update the radius for the next task
            self.currentRadius += self.radiusIncrement;
            self.radiusIncrement = (self.radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
            
            // Add to our array of explosion views
            self.explosionViews = [self.explosionViews arrayByAddingObject:explosionView];

            // Add the view to the parent
            dispatch_async(dispatch_get_main_queue(), ^{[self.parentView addSubview:explosionView];});
        };
        
        // Add the view to a queue
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.queueDelay);
        dispatch_after(popTime, self.dispatchQueue, createExplosionView);
        self.tasks += 1;
        
        // Add to our array of explosion views
        radius += radiusIncrement;
        radiusIncrement = (radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
        float delayInSeconds = 0.1;
        self.queueDelay += delayInSeconds * NSEC_PER_SEC;
    }
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
    dispatch_async(dispatch_get_main_queue(), ^{[view setNeedsDisplay];});
}

- (void)ageExplosionViews
{
    if (self.phosphorTimer) {
        // Walk thru the array and display/age each extry
        if ([self.explosionViews count]) {
            NSMutableArray *updatedViews = [NSMutableArray arrayWithArray:self.explosionViews];
            NSEnumerator *explosionEnumerator = [self.explosionViews objectEnumerator];
            Explosion *explosionView;
            while (explosionView = [explosionEnumerator nextObject]) {
                // Modify the age of each entry
                float alpha = explosionView.alpha;
                if (alpha > 0) {
                    // Update the drawing vectors for this view
                    //###[self EXGEN:explosionView];
                    
                    // Age the view
                    alpha -= DeltaAlpha;
                    explosionView.alpha = alpha;
                }
                else {
                    // Remove this view from screen
                    [updatedViews removeObject:explosionView];
                    [explosionView removeFromSuperview];
                    self.tasks -= 1;
                }
            }

            // We are done when no views remain
            if ([updatedViews count] == 0 && self.tasks == 0) {
                // Kill the phosphor decay timer
                [self.phosphorTimer invalidate];
                self.phosphorTimer = nil;
                
                // Call the completion block
                self.completionBlock();
            }
            
            // Update the list of active views
            self.explosionViews = updatedViews;
        }
    }
}

@end
