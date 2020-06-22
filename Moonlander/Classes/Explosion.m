//
//  Explosion.m
//  Moonlander
//
//  Created by Rick Naro on 4/14/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion


// Helper routines for radians and degrees
static float DegreesToRadians(float degrees)
{
    return degrees * M_PI / 180;
}

#if 0 //###
static float RadiansToDegrees(float radians)
{
    return radians * 180 / M_PI;
}
#endif

- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // Prep the view and intensity info
        self.alpha = (float)((random() % 40)/100.0)+ 0.6;
        self.opaque = NO;
        self.hidden = YES;
    }
    return self;
}

- (void)EXGEN:(short)radius
{
    const int YUpDown[] = { 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1 };
    const size_t DimYUpDown = sizeof(YUpDown)/sizeof(YUpDown[0]);
    const float StartingAngle = DegreesToRadians(-30);
    const float AngleIncrement = DegreesToRadians(1);
    
    float angle = StartingAngle;
    short count = 241;

    float centerX = self.bounds.size.width / 2;
    float centerY = self.bounds.size.height / 2;
    
    //(EXGENL)
    NSMutableArray *points = [NSMutableArray array];
    while (count > 0) {
        // We skip fooling around and just randomize this
        short randomIndex = random() % DimYUpDown;
        short TEMP = YUpDown[randomIndex];
        TEMP += radius;
        if (TEMP >= 0) {
            CGFloat X = TEMP * cos(angle) + centerX;
            CGFloat Y = TEMP * sin(angle) + centerY;
            if (X >= 0 && Y >= 0) {
                // Add the points that fall within the view
                point_t dust;
                dust.x = X;
                dust.y = Y;
                dust.alpha = 1.0;
                NSValue *dustValue = [NSValue valueWithBytes:&dust objCType:@encode(point_t)];
                [points addObject:dustValue];
            }
        }
        
        //(EXGEND)
        angle += AngleIncrement;
        count--;
    }
    
    // Add the draw paths and update the display
    self.drawPaths = [points count] ? points : nil;
    dispatch_async(dispatch_get_main_queue(), ^{[self setNeedsDisplay];});
}

@end
