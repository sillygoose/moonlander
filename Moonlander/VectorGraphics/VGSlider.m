//
//  VGSlider.m
//  Moonlander
//
//  Created by Silly Goose on 5/15/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGSlider.h"


@implementation VGSlider

@synthesize actualBounds=_actualBounds;

@synthesize value=_value;

@synthesize thrusterSlider=_thrusterSlider;
@synthesize thrusterIndicator=thrusterIndicator;
@synthesize thrusterValue=_thrusterValue;


- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.actualBounds = CGRectMake(FLT_MAX, FLT_MAX, -FLT_MAX, -FLT_MAX);
        
        // Enable for debugging
        //self.backgroundColor = [UIColor grayColor];

        [self addTarget:self action:@selector(buttonDown:) forControlEvents:(UIControlEventTouchDown|UIControlEventTouchDragEnter)];
        [self addTarget:self action:@selector(buttonRepeat:) forControlEvents:(UIControlEventTouchDownRepeat|UIControlEventTouchDragInside)];
        [self addTarget:self action:@selector(buttonUp:) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel|UIControlEventTouchDragExit|UIControlEventTouchDragOutside)];

        CGRect sliderFrame = CGRectMake(100, 0, frameRect.size.width / 3, frameRect.size.height);
        CGRect needleFrame = CGRectMake(30, frameRect.size.height, frameRect.size.width / 3, 10);
        CGRect valueFrame = CGRectMake(0, frameRect.size.height, 40, 16);
        
        // Thruster slider subview
        NSString *tsPath = [[NSBundle mainBundle] pathForResource:@"ThrusterControl" ofType:@"plist"];
        self.thrusterSlider = [[[VGView alloc] initWithFrame:sliderFrame withPaths:tsPath] autorelease];
        self.thrusterSlider.userInteractionEnabled = YES;
        [self addSubview:self.thrusterSlider];
        
        // Thruster needle indicator subview
        NSString *tiPath = [[NSBundle mainBundle] pathForResource:@"ThrusterNeedle" ofType:@"plist"];
        self.thrusterIndicator = [[[VGView alloc] initWithFrame:needleFrame withPaths:tiPath] autorelease];
        self.thrusterIndicator.userInteractionEnabled = NO;
        [self addSubview:self.thrusterIndicator];
        
        // Thruster numeric value subview
        self.thrusterValue = [[[VGLabel alloc] initWithFrame:valueFrame] autorelease];
        self.thrusterValue.userInteractionEnabled = NO;
        [self addSubview:self.thrusterValue];
    }
    return self;
}

- (void)setValue:(float)newValue
{
    // Save our updated thruster value
    _value = newValue;
    
    CGRect newNeedleFrame = CGRectMake(self.thrusterIndicator.frame.origin.x, (self.frame.size.height - (2 * self.value)) - self.thrusterIndicator.frame.size.height/2, self.thrusterIndicator.frame.size.width, self.thrusterIndicator.frame.size.height);
    [self.thrusterIndicator setFrame:newNeedleFrame];
    [self.thrusterIndicator setNeedsDisplay];
    
    CGRect newValueFrame = CGRectMake(self.thrusterValue.frame.origin.x, (self.frame.size.height - (2 * self.value)) - self.thrusterValue.frame.size.height/2, self.thrusterValue.frame.size.width, self.thrusterValue.frame.size.height);
    [self.thrusterValue setFrame:newValueFrame];
    
    // Update the % thrust subview by dynamically creating a draw path
    NSString *thrustValue = [NSString stringWithFormat:@"%3.0f%%", self.value];
    NSDictionary *currentThrustPath = [NSDictionary dictionaryWithObjectsAndKeys:thrustValue, @"text", nil];
    NSArray *path = [NSArray arrayWithObject:currentThrustPath];
    NSArray *paths = [NSArray arrayWithObject:path];
    self.thrusterValue.drawPaths = paths;
    [self.thrusterValue setNeedsDisplay];
}

- (void)dealloc
{
    [_thrusterSlider release];
    [_thrusterIndicator release];
    [_thrusterValue release];
    
    [super dealloc];
}


#pragma mark Touch tracking

-(void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position
{
    // Update the indicator needle position
    self.value = 100.0f - position.y / theView.bounds.size.height * 100.0f;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch *touch in touches) {
        if ([touch view] == self.thrusterSlider) {
            if ([self pointInside:[touch locationInView:self] withEvent:event]) {
                [self dispatchTouchEvent:[touch view] toPosition:[touch locationInView:self]];
            }
        }
	}	
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch *touch in touches) {
        if ([touch view] == self.thrusterSlider) {
            if ([self pointInside:[touch locationInView:self] withEvent:event]) {
                [self dispatchTouchEvent:[touch view] toPosition:[touch locationInView:self]];
            }
        }
	}	
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch *touch in touches) {
        if ([touch view] == self.thrusterSlider) {
            if ([self pointInside:[touch locationInView:self] withEvent:event]) {
                [self dispatchTouchEvent:[touch view] toPosition:[touch locationInView:self]];
            }
        }
	}	
}

@end
