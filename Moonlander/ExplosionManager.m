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
@synthesize explosionTimer=_explosionTimer;
@synthesize phosphorTimer=_phosphorTimer;
@synthesize parentView=_parentView;

@synthesize groundZero=_groundZero;
@synthesize currentRadius=_currentRadius;
@synthesize radiusIncrement=_radiusIncrement;


const short MaximumRadius = 300;
const short RadiusIncrement1 = 33;
const short RadiusIncrement2 = -10;

const float AnimateExplosionTimer = 0.075;
const float AgeExplosionTimer = 0.1;
const float DeltaAlpha = 0.2;



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
    }
    return self;
}

- (id)initWithView:(UIView *)view atPoint:(CGPoint)gz
{
    self = [self init];
    if (self) {
        // Create our array
        self.explosionViews = [NSArray array];
        
        // Our initial values for expansion code
        self.currentRadius = 0;
        self.radiusIncrement = RadiusIncrement2;
        
        // Cache our view info
        self.parentView = view;
        self.groundZero = gz; 
        
        // Create a timer to start the explosion view sequence
        self.explosionTimer = [NSTimer scheduledTimerWithTimeInterval:AnimateExplosionTimer target:self selector:@selector(createExplosionViews) userInfo:nil repeats:YES];
        
        // And a timer to simulatethe phosphor decay
        self.phosphorTimer = [NSTimer scheduledTimerWithTimeInterval:AgeExplosionTimer target:self selector:@selector(ageExplosionViews) userInfo:nil repeats:YES];
    }
    return self;
}

- (BOOL)explosionComplete
{
    return (self.phosphorTimer == nil);
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
    short intensityLevel = 7;//view.intensity;
    short radius = view.radius;
    
    NSNumber *intensity = [NSNumber numberWithInt:intensityLevel];
    NSNumber *width = [NSNumber numberWithFloat:1.0f];
    NSNumber *height = [NSNumber numberWithFloat:1.0f];
    
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
                
                // This is not very optimal - should be intensity, frame, point, point, etc...
                NSDictionary *originItem = [NSDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil];
                NSDictionary *sizeItem = [NSDictionary dictionaryWithObjectsAndKeys:width, @"width", height, @"height", nil];
                NSDictionary *frameItem = [NSDictionary dictionaryWithObjectsAndKeys:originItem, @"origin", sizeItem, @"size", nil];
                NSDictionary *rectItem = [NSDictionary dictionaryWithObjectsAndKeys:frameItem, @"frame", nil];
                NSDictionary *pathItem = [NSDictionary dictionaryWithObjectsAndKeys:rectItem, @"rect", intensity, @"intensity", nil];
                [path addObject:pathItem];
            }
        }
        
        //(EXGEND)
        angle += AngleIncrement;
        count--;
    }
    
    // Add the draw paths and update the display
    view.drawPaths = paths;
    [view setNeedsDisplay];
}

- (void)createExplosionViews
{
    if (self.explosionTimer) {
        if (self.currentRadius > MaximumRadius) {
            // Kill our view generation timer as all our views are created
            [self.explosionTimer invalidate];
            self.explosionTimer = nil;
        }
        else {
            // Create an explosion view
            float explosionSize = self.currentRadius * 2;
            float xPos = self.groundZero.x - explosionSize / 2;
            float yPos = (768 - self.groundZero.y) - explosionSize / 2;
            CGRect frameRect = CGRectMake(xPos, yPos, explosionSize, explosionSize);
            Explosion *explosionView = [[Explosion alloc] initWithFrame:frameRect];
            explosionView.radius = self.currentRadius;
            explosionView.intensity = (short)random() % 8;
            explosionView.alpha = 1.0;
            [self EXGEN:explosionView];

            // Add to our array of explosion views
            self.explosionViews = [self.explosionViews arrayByAddingObject:explosionView];
            self.currentRadius += self.radiusIncrement;
            self.radiusIncrement = (self.radiusIncrement == RadiusIncrement1) ? RadiusIncrement2 : RadiusIncrement1;
            
            // Add the view to the parent
            [self.parentView addSubview:explosionView];
        }
    }
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
                if (explosionView.alpha > 0) {
                    // Update the drawing vectors for this view
                    [self EXGEN:explosionView];
                    
                    // Age the view
                    explosionView.alpha -= DeltaAlpha;
                    explosionView.intensity = explosionView.intensity - 1;
                }
                else {
                    // Remove this view from screen
                    [updatedViews removeObject:explosionView];
                    [explosionView removeFromSuperview];
                }
            }

            // We are done when no views remain
            if ([updatedViews count] == 0) {
                // Kill the phosphor decay timer
                [self.phosphorTimer invalidate];
                self.phosphorTimer = nil;
            }
            
            // Update the list of active views
            self.explosionViews = updatedViews;
        }
    }
}

@end
