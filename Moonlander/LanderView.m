//
//  LanderView.m
//  Moonlander
//
//  Created by Silly Goose on 5/13/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderView.h"


@implementation LanderView

@synthesize landerData=_landerData;

#define NEW_VECTOR  CGFLOAT_MAX
#define NEW_INTENSITY  CGFLOAT_MIN

const CGPoint landerTop[] = {
    { NEW_VECTOR, NEW_VECTOR },
    { -6.0f, 0.0f },
    { -14.0f, -8.0f },
    { -14.0f, -20.0f },
    { -6.0f, -29.0f },
    { 6.0f, -29.0f },
    { 14.0f, -20.0f },
    { 14.0f, -8.0f },
    { 6.0f, 0.0f },
    { -6.0f, 0.0f },
    { NEW_VECTOR, NEW_VECTOR },
    { -17.0f, 0.0f },
    { -17.0f, 16.0f },
    { 17.0f, 16.0f },
    { 17.0f, 0.0f },
    { -17.0f, 0.0f },
    { NEW_VECTOR, NEW_VECTOR },
    { -17.0f, 0.0f },
    { -32.0f, 24.0f },
    { NEW_VECTOR, NEW_VECTOR },
    { 17.0f, 0.0f },
    { 32.0f, 24.0f },
    { NEW_VECTOR, NEW_VECTOR },
    { 36.0f, 24.0f },
    { 28.0f, 24.0f },
    { NEW_VECTOR, NEW_VECTOR },
    { -28.0f, 24.0f },
    { -36.0f, 24.0f },
    { NEW_VECTOR, NEW_VECTOR },
    { -17.0f, 14.0f },
    { -28.0f, 18.0f },
    { NEW_VECTOR, NEW_VECTOR },
    { 17.0f, 14.0f },
    { 28.0f, 18.0f },
    { NEW_VECTOR, NEW_VECTOR },
    { -3.0f, 16.0f },
    { -7.0f, 21.0f },
    { 7.0f, 21.0f },
    { 3.0f, 16.0f },
};


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.landerData = [[NSArray alloc] initWithObjects:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGPoint midPoint;
	midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
	midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextSetLineWidth(context, 1.5f);
    CGContextSetRGBStrokeColor(context, 0.0260f, 1.0f, 0.00121f, 1.0f);
    
    CGContextBeginPath(context);
    
    // Set intensity to level 4 - upper lander
    CGContextMoveToPoint(context, midPoint.x + landerTop[0].x, midPoint.y + landerTop[0].y);
    for (unsigned k = 0; k < sizeof(landerTop)/sizeof(landerTop[0]); k++) {
        if ( landerTop[k].x == NEW_VECTOR ) {
            k++;
            CGContextMoveToPoint(context, midPoint.x + landerTop[k].x, midPoint.y + landerTop[k].y);
            continue;
        }
        CGContextAddLineToPoint(context, midPoint.x + landerTop[k].x, midPoint.y + landerTop[k].y);
    }
    CGContextStrokePath(context);
}

- (void)dealloc
{
    [_landerData release];
    [super dealloc];
}

@end
