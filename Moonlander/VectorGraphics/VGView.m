//
//  VGView.m
//  Moonlander
//
//  Created by Silly Goose on 5/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGView.h"


@implementation VGView

@synthesize drawPaths=_drawPaths;
@synthesize vectorName=_vectorName;
@synthesize actualBounds=_actualBounds;


- (id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        self.actualBounds = CGRectMake(FLT_MAX, FLT_MAX, -FLT_MAX, -FLT_MAX);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName
{
    self = [self initWithFrame:frameRect];

    NSDictionary *viewObject = [NSDictionary dictionaryWithContentsOfFile:fileName];
    self.vectorName = [viewObject objectForKey:@"name"];
    self.drawPaths = [viewObject objectForKey:@"paths"];
    return self;
}

- (void)addPathFile:(NSString *)fileName
{
    NSDictionary *viewObject = [NSDictionary dictionaryWithContentsOfFile:fileName];
    self.vectorName = [viewObject objectForKey:@"name"];
    self.drawPaths = [viewObject objectForKey:@"paths"];
}

- (void)drawRect:(CGRect)rect
{
	CGPoint prevPoint = CGPointMake(0.0f, 0.0f);
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias (context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    
    NSEnumerator *pathEnumerator = [self.drawPaths objectEnumerator];
    NSArray *currentPath;
    while ((currentPath = [pathEnumerator nextObject])) {
        NSEnumerator *vectorEnumerator = [currentPath objectEnumerator];
        NSDictionary *currentVector;
        while ((currentVector = [vectorEnumerator nextObject])) {
            // "stop' allows early termination of a display list
            if ([currentVector objectForKey:@"stop"]) {
                BOOL stopCommand = [[currentVector objectForKey:@"stop"] boolValue];
                if (stopCommand) break;
            }
            
            // "break" allows for complex breakpoints in a display list
            if ([currentVector objectForKey:@"break"]) {
                BOOL breakCommand = [[currentVector objectForKey:@"break"] boolValue];
                if (breakCommand) {
                    NSLog(@"Set breakpoint point here");;
                }
            }
            
            // "moveto" is used to a move to a point in the current rect
            if ([currentVector objectForKey:@"moveto"]) {
                NSDictionary *moveTo = [currentVector objectForKey:@"moveto"];
                if ([moveTo objectForKey:@"center"]) {
                    // Centering uses the view bounds and is not scaled
                    CGPoint midPoint = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
                    CGContextMoveToPoint(context, midPoint.x, midPoint.y);
                    prevPoint = midPoint;
                }
                else if ([moveTo objectForKey:@"x"]) {
                    // Moving to a point in the view requires scaling
                    CGFloat x = [[moveTo objectForKey:@"x"] floatValue];
                    CGFloat y = [[moveTo objectForKey:@"y"] floatValue];
                    CGPoint newPoint = CGPointMake(x, y);
                    
                    // ### Scaling here
                    CGContextMoveToPoint(context, newPoint.x, newPoint.y);
                    
                    //NSLog(@"Move To (%3.0f,%3.0f)", newPoint.x, newPoint.y);
                    prevPoint = newPoint;
                    self.actualBounds = CGRectMake(MIN(newPoint.x, self.actualBounds.origin.x), MIN(newPoint.y, self.actualBounds.origin.y), MAX(newPoint.x, self.actualBounds.size.width), MAX(newPoint.y, self.actualBounds.size.height));
                }
            }
            
            // "moverel" is used to move to a point relative to the current position
            if ([currentVector objectForKey:@"moverel"]) {
                NSDictionary *moveRelative = [currentVector objectForKey:@"moverel"];
                if ([moveRelative objectForKey:@"x"]) {
                    // Moving to a point in the view requires scaling
                    CGFloat x = [[moveRelative objectForKey:@"x"] floatValue];
                    CGFloat y = [[moveRelative objectForKey:@"y"] floatValue];
                    CGPoint newPoint = CGPointMake(prevPoint.x + x, prevPoint.y + y);
                    // ### Scaling here
                    CGContextMoveToPoint(context, newPoint.x, newPoint.y);
                    
                    //NSLog(@"Move Relative (%3.0f,%3.0f)", newPoint.x, newPoint.y);
                    prevPoint = newPoint;
                    self.actualBounds = CGRectMake(MIN(newPoint.x, self.actualBounds.origin.x), MIN(newPoint.y, self.actualBounds.origin.y), MAX(newPoint.x, self.actualBounds.size.width), MAX(newPoint.y, self.actualBounds.size.height));
                }
            }
            
            // "color" is used to set the current color
            if ([currentVector objectForKey:@"color"]) {
                NSDictionary *colorStuff = [currentVector objectForKey:@"color"];
                CGFloat r = [[colorStuff objectForKey:@"r"] floatValue];
                CGFloat g = [[colorStuff objectForKey:@"g"] floatValue];
                CGFloat b = [[colorStuff objectForKey:@"b"] floatValue];
                CGFloat alpha = [[colorStuff objectForKey:@"alpha"] floatValue];
                CGContextStrokePath(context);
                CGContextSetRGBStrokeColor(context, r, g, b, alpha);
                CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
            }
            
            // "line" is used to set the line information
            if ([currentVector objectForKey:@"line"]) {
                if ([currentVector objectForKey:@"line"]) {
                    NSDictionary *lineStuff = [currentVector objectForKey:@"line"];
                    if ([lineStuff objectForKey:@"width"]) {
                        CGFloat width = [[lineStuff objectForKey:@"width"] floatValue];
                        CGContextStrokePath(context);
                        CGContextSetLineWidth(context, width);
                        CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
                    }
                }
            }
            
            // "x" and "y" specify a new point on the path
            if ([currentVector objectForKey:@"x"]) {
                CGFloat x = [[currentVector objectForKey:@"x"] floatValue];
                CGFloat y = [[currentVector objectForKey:@"y"] floatValue];
                CGPoint newPoint = CGPointMake(prevPoint.x + x, prevPoint.y + y);
                
                // ### Scaling here
                CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
                
                prevPoint = newPoint;
                self.actualBounds = CGRectMake(MIN(newPoint.x, self.actualBounds.origin.x), MIN(newPoint.y, self.actualBounds.origin.y), MAX(newPoint.x, self.actualBounds.size.width), MAX(newPoint.y, self.actualBounds.size.height));
            }
        }
    }
    CGContextStrokePath(context);
    NSLog(@"Max coordinates for %@: %@", self.vectorName, NSStringFromCGRect(self.actualBounds));
}

- (void)dealloc
{
    [_drawPaths release];
    [_vectorName release];
    [super dealloc];
}

@end
