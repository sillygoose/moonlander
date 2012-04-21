//
//  Dust.m
//  Moonlander
//
//  Created by Silly Goose on 6/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "Dust.h"


@implementation Dust

@synthesize delegate=_delegate;

@synthesize dustPoints=_dustPoints;   

const float DustViewWidth = 128;
const float DustViewHeight = 64;

typedef struct {
    float x;
    float y;
    float alpha;
} DustPoint;


- (id)init
{
    CGRect dustRect = CGRectMake(0, 0, DustViewWidth, DustViewHeight);
    self = [super initWithFrame:dustRect];
    if (self) {
        // Keep the view hidden for now
        self.hidden = YES;
        self.opaque = NO;

        // Array of dust to draw
        self.dustPoints = [NSMutableArray array];
    }
    return self;
}

- (void)generateDust
{
    // Some dust generation constants
    const short MaxDisplayDust = 241;
    const short MaxDustThrust = 63;
    const short DustStartHeight = 150;
    
    if (self.delegate.RADARY < DustStartHeight) {
        // Angle must be reasonable as well
        short angleD = self.delegate.ANGLED;
        if (angleD >= -45 && angleD <= 45) {
            // See if we need to display any dust
            //(DUSTB1)  Magnitude of dust determines intensity level
            short requestedThrust = self.delegate.PERTRS;
            short percentThrust = (requestedThrust > MaxDustThrust) ? MaxDustThrust : requestedThrust;
            short dustIntensity = (percentThrust >> 3) & 0x7;
            
            //(DUSTP1)  Thrust angle determines dust direction
            float angle = self.delegate.ANGLE;
            float cosAngle = cos(angle);
            float sinAngle = sin(angle);
            
            short deltaY = self.delegate.SHOWY - self.delegate.AVERT;
            float sinDeltaY = deltaY * sinAngle;
            float tanDeltaY = sinDeltaY / cosAngle;
            short __block flameDistance = tanDeltaY + deltaY;
            tanDeltaY = -tanDeltaY;
            
            //(DUSTP2)  Center the dust in the view
            //### This is a hack - fixme!
            short xCenterPos = self.delegate.SHOWX + tanDeltaY;
            short yCenterPos = 768 - self.delegate.AVERT;
            yCenterPos -= DustViewHeight / 2;
            
            // Calculate the flame distance and number of points to draw
            flameDistance -= DustStartHeight;
            if (flameDistance < 0) {
                // Convert to a positive distance (NEG)
                flameDistance = -flameDistance;
                
                // Calculate the number of dust points to draw
                short __block count = MIN(((flameDistance * requestedThrust) >> 4), MaxDisplayDust);
                if (count) {
                    // Actually have something to display, do it in the background
                    void (^createDustView)(void) = ^{
                        if (count) {
                            // Look up table used in dust generation
                            const short YThrust[] = { 0, -30, -31, -32, -34, -36, -38, -41, -44, -47, -50, -53, -56, 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1, -20, -16, -13, -10, -7, -4, -2, 0, 2, 4, 7, 10, 13, 16, 20, 0, -30, -31 };
                            const short DimYThrust = sizeof(YThrust)/sizeof(YThrust[0]);
                            assert(DimYThrust == 63);
                            
                            //(DUSTWF)
                            //(DUSTL)
                            while (count--) {
                                // Generate a random value to index the thrust vector array
                                short RET1 = (short)random();
                                RET1 &= DimYThrust;
                                
                                // X coordinate calculation
                                short xPos = YThrust[RET1];
                                RET1 += (short)random();
                                RET1 &= DimYThrust;
                                xPos &= DimYThrust;
                                
                                // Toggle the direction bit for X (COM)
                                flameDistance = ~flameDistance;
                                if (flameDistance < 0) {
                                    xPos = -xPos;
                                }
                                
                                // Adjust X to the dust view frame
                                xPos += DustViewHeight - 1;
                                
                                // Now generate the Y value (always positive)
                                short yPos = YThrust[RET1];
                                yPos &= DimYThrust;
                                
                                // Encode our dust structure and save away
                                DustPoint dust;
                                dust.x = xPos;
                                dust.y = yPos;
                                dust.alpha = dustIntensity;
                                NSValue *dustValue = [NSValue valueWithBytes:&dust objCType:@encode(CGPoint)];
                                [self.dustPoints addObject:dustValue];

                            }
                            
                            // UIKit code needs to be in the main thread
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // Set the frame coordinates and redraw
                                CGPoint newCenter = CGPointMake(xCenterPos, yCenterPos);
                                self.center = newCenter;
                                self.hidden = NO;
                                [self setNeedsDisplay];
                            });
                        }
                    };
                    
                    // Create a dispatch queue to use for background dust processing
                    dispatch_queue_t dustQueue = dispatch_queue_create("com.devtools.moonlander.dust", NULL);
                    dispatch_async(dustQueue, createDustView);
                    dispatch_release(dustQueue);
                }
            }
        }
    }
    
    // Hide the view in case we didn't draw anything
    self.hidden = YES; 
}

- (void)drawPoint:(DustPoint)point
{
    // Set up context for drawing
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    
    // Set the color ###(need this defined in one place!)
    CGContextSetRGBFillColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    CGContextSetRGBStrokeColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    CGContextSetAlpha(context, point.alpha);
    
    // Defaults for a rectangle
    CGFloat width = 1;
    CGFloat height = 1;
    
    // Draw a simple rectangle
    CGRect rect = CGRectMake(point.x, point.y, width, height);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    // Draw using the super quick point mode
    NSEnumerator *pathEnumerator = [self.dustPoints objectEnumerator];
    NSValue *currentPoint;
    while ((currentPoint = [pathEnumerator nextObject])) {
        DustPoint point;
        [currentPoint getValue:&point];
        [self drawPoint:point];
    }
    [self.dustPoints removeAllObjects];
}

@end
