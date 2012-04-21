//
//  Explosion.m
//  Moonlander
//
//  Created by Rick Naro on 4/14/12.
//  Copyright (c) 2012 Silly Goose Software. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

@synthesize radius=_radius;
@synthesize dustPoints=_dustPoints;


// Helper routines for radians and degrees
static float DegreesToRadians(float degrees)
{
    return degrees * M_PI / 180;
}

static float RadiansToDegrees(float radians)
{
    return radians * 180 / M_PI;
}

- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.opaque = NO;
        
        // Array of dust to draw
        self.dustPoints = [NSMutableArray array];
    }
    return self;
}

- (void)EXGEN
{
    const int YUpDown[] = { 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1 };
    const size_t DimYUpDown = sizeof(YUpDown)/sizeof(YUpDown[0]);
    const float StartingAngle = DegreesToRadians(150);
    const float AngleIncrement = DegreesToRadians(1);
    
    float angle = StartingAngle;
    short count = 241;
    float centerX = self.bounds.size.width / 2;
    float centerY = self.bounds.size.height / 2;
    
    // Prep the intensity and line type info
    short radius = self.radius;
    
    //(EXGENL)
    while (count > 0) {
        // We skip fooling around and just randomize this
        short randomIndex = random() % DimYUpDown;
        short TEMP = YUpDown[randomIndex];
        TEMP += radius;
        if (TEMP >= 0) {
            CGFloat X = TEMP * cos(angle) + centerX;
            CGFloat Y = TEMP * sin(angle) + centerY;
            if (X >= 0 && Y >= 0) {
                CGPoint dust;
                dust.x = X;
                dust.y = Y;
                NSValue *dustValue = [NSValue valueWithBytes:&dust objCType:@encode(CGPoint)];
                [self.dustPoints addObject:dustValue];
            }
        }
        
        //(EXGEND)
        angle += AngleIncrement;
        count--;
    }
    
    // Add the draw paths and update the display
    dispatch_async(dispatch_get_main_queue(), ^{[self setNeedsDisplay];});
}

- (void)drawPoint:(CGPoint)point
{
    // Set up context
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    
    // Set color ###(need this defined in one place!)
    CGContextSetRGBFillColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    CGContextSetRGBStrokeColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    CGContextSetAlpha(context, 1.0);
    
    // Defaults for a rectangle
    CGFloat width = 1.0;
    CGFloat height = 1.0;
    
    // Draw a rectangle
    CGRect rect = CGRectMake(point.x, point.y, width, height);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    // Draw using super quick point mode
    NSEnumerator *pathEnumerator = [self.dustPoints objectEnumerator];
    NSValue *currentPoint;
    while ((currentPoint = [pathEnumerator nextObject])) {
        CGPoint point;
        [currentPoint getValue:&point];
        [self drawPoint:point];
    }
}

@end
