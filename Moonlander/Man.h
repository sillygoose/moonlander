//
//  Man.h
//  Moonlander
//
//  Created by Rick Naro on 9/7/11.
//  Copyright (c) 2011 Silly Goose Software. All rights reserved.
//

#import "VGView.h"

@interface Man : VGView {
    short           _X;
    short           _Y;
    short           _initalX;
    short           _initialY;
    
    short           _deltaX;
    short           _deltaY;
    
    short           _incrementX;
    short           _incrementY;
}

@property (nonatomic) short X;
@property (nonatomic) short Y;
@property (nonatomic) short initialX;
@property (nonatomic) short initialY;

@property (nonatomic) short deltaX;
@property (nonatomic) short deltaY;

@property (nonatomic) short incrementX;
@property (nonatomic) short incrementY;

- (id)initWithOrigin:(CGPoint)origin andDelta:(CGPoint)delta;

- (BOOL)moveMan;

@end
