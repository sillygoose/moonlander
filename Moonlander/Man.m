//
//  Man.m
//  Moonlander
//
//  Created by Rick Naro on 9/7/11.
//  Copyright (c) 2011 Silly Goose Software. All rights reserved.
//

#import "Man.h"

@implementation Man

@synthesize X=_X;
@synthesize Y=_Y;
@synthesize initialX=_initialX;
@synthesize initialY=_initialY;
@synthesize deltaX=_deltaX;
@synthesize deltaY=_deltaY;
@synthesize incrementX=_incrementX;
@synthesize incrementY=_incrementY;


- (id)initWithOrigin:(CGPoint)origin andDelta:(CGPoint)delta
{
    CGRect manRect = CGRectMake(origin.x, origin.y, 20, 20);
    self = [super initWithFrame:manRect];
    if (self) {
        // No events for the man
        self.userInteractionEnabled = NO;
        
        NSString *manPath = [[NSBundle mainBundle] pathForResource:@"Man" ofType:@"plist"];
        NSDictionary *manDict = [NSDictionary dictionaryWithContentsOfFile:manPath];
        self.drawPaths = [manDict objectForKey:@"paths"];
        self.vectorName = @"[Man init]";
        
        // Save our initial position and how we move
        self.initialX = self.X = origin.x;
        self.initialY = self.Y = origin.y;
        
        self.deltaX = delta.x;
        self.deltaY = delta.y;
        
        self.incrementX = 1;
        if (self.deltaX < 0) {
            self.deltaX = -self.deltaX;
            self.incrementX = -1;
        }
        self.incrementY = 1;
        if (self.deltaY < 0) {
            self.deltaY = -self.deltaY;
            self.incrementY = -1;
        }
    }
    return self;
}


- (BOOL)moveMan
{
    BOOL done;
    if (self.deltaY == 0) {
        if (self.deltaX > 0) {
            self.X += self.incrementX;
            self.deltaX -= 1;
            
            // MOVLUP:
            CGPoint pos = self.center;
            pos.x += self.incrementX;
            self.center = pos;
        }
        done = (self.deltaX == 0);
    }
    else {
        self.X += self.incrementX;
        self.Y += self.incrementY;
        self.deltaX -= 1;
        self.deltaY -= 1;
        
        // MOVLUP:
        CGPoint pos = self.center;
        pos.x += self.incrementX;
        pos.y += self.incrementY;
        self.center = pos;
        
        done = (self.deltaY == 0);
    }
    return done;
}

@end
