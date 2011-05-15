//
//  VGButton.m
//  Moonlander
//
//  Created by Silly Goose on 5/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGButton.h"


@implementation VGButton

@synthesize drawPaths=_drawPaths;


- (id)initWithFile:(NSString *)fileName
{
    // Open the vector XML file and create the view
    NSDictionary *viewObject = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (viewObject) {
        NSArray *paths = [viewObject objectForKey:@"paths"];
        NSDictionary *frame = [viewObject objectForKey:@"frame"];
        NSDictionary *size = [frame objectForKey:@"size"];
        NSDictionary *origin = [frame objectForKey:@"origin"];
        CGRect frameRect = CGRectMake([[origin objectForKey:@"x"] floatValue], [[origin objectForKey:@"y"] floatValue], [[size objectForKey:@"width"] floatValue], [[size objectForKey:@"height"] floatValue]);
        
        self = [super initWithFrame:frameRect];
        if (self) {
            self.drawPaths = paths;
        }
    }
    else self = nil;
    return self;
}

- (void)dealloc
{
    [_drawPaths release];
    [super dealloc];
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
        NSDictionary *currentVector;
        while ((currentVector = [vectorEnumerator nextObject])) {
            // Choices are "moveto", "color", "line", "x", "y"
            if ([currentVector objectForKey:@"moveto"]) {
                NSDictionary *moveTo = [currentVector objectForKey:@"moveto"];
                CGFloat x = [[moveTo objectForKey:@"x"] floatValue];
                CGFloat y = [[moveTo objectForKey:@"y"] floatValue];
                CGContextMoveToPoint(context, midPoint.x + x, midPoint.y + y);
            }
            if ([currentVector objectForKey:@"color"]) {
                NSDictionary *colorStuff = [currentVector objectForKey:@"color"];
                CGFloat r = [[colorStuff objectForKey:@"r"] floatValue];
                CGFloat g = [[colorStuff objectForKey:@"g"] floatValue];
                CGFloat b = [[colorStuff objectForKey:@"b"] floatValue];
                CGFloat alpha = [[colorStuff objectForKey:@"alpha"] floatValue];
                CGContextSetRGBStrokeColor(context, r, g, b, alpha);
            }
            if ([currentVector objectForKey:@"line"]) {
                if ([currentVector objectForKey:@"line"]) {
                    NSDictionary *lineStuff = [currentVector objectForKey:@"line"];
                    if ([lineStuff objectForKey:@"width"]) {
                        CGFloat width = [[lineStuff objectForKey:@"width"] floatValue];
                        CGContextSetLineWidth(context, width);
                    }
                }
            }
            if ([currentVector objectForKey:@"x"]) {
                CGFloat x = [[currentVector objectForKey:@"x"] floatValue];
                CGFloat y = [[currentVector objectForKey:@"y"] floatValue];
                CGContextAddLineToPoint(context, midPoint.x + x, midPoint.y + y);
            }
        }
    }
    CGContextStrokePath(context);
}

@end
