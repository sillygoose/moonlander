//
//  VGLabel.m
//  Moonlander
//
//  Created by Silly Goose on 5/18/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGLabel.h"


@implementation VGLabel

- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithMessage:(NSString *)msgName
{
    
    NSString *msgsFile = [[NSBundle mainBundle] pathForResource:@"LanderMessages" ofType:@"plist"];
    NSDictionary *landerMessages = [NSDictionary dictionaryWithContentsOfFile:msgsFile];
    NSDictionary *msgs = [landerMessages objectForKey:@"messages"];
    NSDictionary *msg = [msgs objectForKey:msgName];

    NSDictionary *frame = [msg objectForKey:@"frame"];
    NSDictionary *origin = [frame objectForKey:@"origin"];
    NSDictionary *size = [frame objectForKey:@"size"];

    CGRect frameRect ;
    frameRect.origin.x = [[origin objectForKey:@"x"] floatValue];
    frameRect.origin.y = [[origin objectForKey:@"y"] floatValue];
    frameRect.size.width = [[size objectForKey:@"width"] floatValue];
    frameRect.size.height = [[size objectForKey:@"height"] floatValue];
    self = [self initWithFrame:frameRect];
    
    self.drawPaths = [msg objectForKey:@"text"];
    self.vectorName = [msg objectForKey:@"name"];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
	CGPoint prevPoint = CGPointMake(0.0f, 0.0f);
    self.minX = FLT_MAX;
    self.minY = FLT_MAX;
    self.maxX = -FLT_MAX;
    self.maxY = -FLT_MAX;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias (context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    
    NSEnumerator *pathEnumerator = [self.drawPaths objectEnumerator];
    NSArray *currentPath;
    while ((currentPath = [pathEnumerator nextObject])) {
        NSEnumerator *vectorEnumerator = [currentPath objectEnumerator];
        NSDictionary *currentVector;
        while ((currentVector = [vectorEnumerator nextObject])) {
            // Choices are "moveto", "color", "line", "x", "y", "center"
            if ([currentVector objectForKey:@"stop"]) {
                BOOL stopCommand = [[currentVector objectForKey:@"stop"] boolValue];
                if (stopCommand) break;
            }
            
            if ([currentVector objectForKey:@"break"]) {
                BOOL breakCommand = [[currentVector objectForKey:@"break"] boolValue];
                if (breakCommand) {
                    NSLog(@"Set breakpoint point here");;
                }
            }
            
            // Move to a point
            if ([currentVector objectForKey:@"moveto"]) {
                NSDictionary *moveTo = [currentVector objectForKey:@"moveto"];
                if ([moveTo objectForKey:@"center"]) {
                    // Centering uses the view bounds and is not scaled
                    CGPoint midPoint = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
                    CGContextMoveToPoint(context, midPoint.x, midPoint.y);
                    //NSLog(@"Move (%3.0f,%3.0f)", midPoint.x, midPoint.y);
                    prevPoint = midPoint;
                    //CGContextStrokePath(context);
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
                    self.minX = MIN(newPoint.x, self.minX);
                    self.minY = MIN(newPoint.y, self.minY);
                    self.maxX = MAX(newPoint.x, self.maxX);
                    self.maxY = MAX(newPoint.x, self.maxY);
                    //CGContextStrokePath(context);
                }
            }
            
            // Move to a point relative to the current position
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
                    self.minX = MIN(newPoint.x, self.minX);
                    self.minY = MIN(newPoint.y, self.minY);
                    self.maxX = MAX(newPoint.x, self.maxX);
                    self.maxY = MAX(newPoint.x, self.maxY);
                    //CGContextStrokePath(context);
                }
            }
            
            // Process color stuff
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
            
            // Process line stuff
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
            
            // Process a new path segment
            if ([currentVector objectForKey:@"x"]) {
                CGFloat x = [[currentVector objectForKey:@"x"] floatValue];
                CGFloat y = [[currentVector objectForKey:@"y"] floatValue];
                CGPoint newPoint = CGPointMake(prevPoint.x + x, prevPoint.y + y);
                // ### Scaling here
                CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
                //NSLog(@"Draw from %-3.0f,%-3.0f to %-3.0f,%-3.0f", prevPoint.x, prevPoint.y, newPoint.x, newPoint.y);
                prevPoint = newPoint;
                self.minX = MIN(newPoint.x, self.minX);
                self.minY = MIN(newPoint.y, self.minY);
                self.maxX = MAX(newPoint.x, self.maxX);
                self.maxY = MAX(newPoint.x, self.maxY);
            }
        }
    }
    CGContextStrokePath(context);
    NSLog(@"Max coordinates for %@: (%3.0f,%3.0f), (%3.0f,%3.0f)", self.vectorName, self.minX, self.minY, self.maxX, self.maxY);
}

@end
