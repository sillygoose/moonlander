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


- (id)initWithFrame:(CGRect)frame using:(NSArray *)paths
{
    self = [super initWithFrame:frame];
    if (self) {
        self.drawPaths = paths;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGPoint midPoint;
	midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
	midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSEnumerator *pathEnumerator = [self.drawPaths objectEnumerator];
    NSArray *currentPath;
    while ((currentPath = [pathEnumerator nextObject])) {
        NSEnumerator *vectorEnumerator = [currentPath objectEnumerator];
        NSDictionary *currentVector = [vectorEnumerator nextObject];
        for (unsigned i = 0; currentVector; i++, currentVector = [vectorEnumerator nextObject]) {
            // Choices are "color", "line", "x", "y"
            if ([currentVector objectForKey:@"color"]) {
                NSDictionary *colorStuff = [currentVector objectForKey:@"color"];
                CGFloat r = [[colorStuff objectForKey:@"r"] floatValue];
                CGFloat g = [[colorStuff objectForKey:@"g"] floatValue];
                CGFloat b = [[colorStuff objectForKey:@"b"] floatValue];
                CGFloat alpha = [[colorStuff objectForKey:@"alpha"] floatValue];
                
                // Set color stuff
                CGContextSetRGBStrokeColor(context, r, g, b, alpha);
            }
            if ([currentVector objectForKey:@"line"]) {
                // Set line stuff
            }
            
            if ([currentVector objectForKey:@"x"]) {
                CGFloat x = [[currentVector objectForKey:@"x"] floatValue];
                CGFloat y = [[currentVector objectForKey:@"y"] floatValue];

                // First point is move to, rest are line to operations
                if ( i == 0 ) {
                    CGContextMoveToPoint(context, midPoint.x + x, midPoint.y + y);
                }
                else {
                    CGContextAddLineToPoint(context, midPoint.x + x, midPoint.y + y);
                }
            }
        }
    }

    CGContextStrokePath(context);
}

- (void)dealloc
{
    [_drawPaths release];
    
    [super dealloc];
}

@end
