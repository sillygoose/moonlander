//
//  VGSlider.m
//  Moonlander
//
//  Created by Rick on 5/15/11.
//  Copyright 2011, 2012 Rick Naro. All rights reserved.
//

#import "VGSlider.h"


@implementation VGSlider

@synthesize actualBounds=_actualBounds;

@synthesize value=_value;

@synthesize thrusterSlider=_thrusterSlider;
@synthesize thrusterIndicator=thrusterIndicator;
@synthesize thrusterValue=_thrusterValue;

// Override the enable property setter so we can enable/disable the underlying view
- (BOOL)enabled
{
    return super.enabled;
}

- (void)setEnabled:(BOOL)state
{
    super.enabled = state;
    self.userInteractionEnabled = state;
    self.thrusterSlider.userInteractionEnabled = state;
}

- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.actualBounds = CGRectMake(FLT_MAX, FLT_MAX, -FLT_MAX, -FLT_MAX);
        
        // Enable for debugging
        //self.backgroundColor = [UIColor grayColor];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self addTarget:self action:@selector(buttonDown:) forControlEvents:(UIControlEventTouchDown|UIControlEventTouchDragEnter)];
        [self addTarget:self action:@selector(buttonRepeat:) forControlEvents:(UIControlEventTouchDownRepeat|UIControlEventTouchDragInside)];
        [self addTarget:self action:@selector(buttonUp:) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel|UIControlEventTouchDragExit|UIControlEventTouchDragOutside)];
#pragma clang diagnostic pop
        
        // Thruster slider subview
        CGFloat SliderXPos = 100;
        CGFloat SliderYPos = 1;
        CGFloat SliderWidth = frameRect.size.width / 3;
        CGFloat SliderHeight = frameRect.size.height - 2 ;
        CGRect sliderFrame = CGRectMake(SliderXPos, SliderYPos, SliderWidth, SliderHeight);
        NSString *tsPath = [[NSBundle mainBundle] pathForResource:@"ThrusterControl" ofType:@"plist"];
        self.thrusterSlider = [[VGView alloc] initWithFrame:sliderFrame withPaths:tsPath];
        self.thrusterSlider.userInteractionEnabled = YES;
        self.thrusterSlider.vectorName = @"thrusterSlider";
        //self.thrusterSlider.backgroundColor = [UIColor grayColor];
        [self addSubview:self.thrusterSlider];
        
        // Thruster needle indicator subview
        CGRect needleFrame = CGRectMake(60, frameRect.size.height, frameRect.size.width / 3, 10);
        NSString *tiPath = [[NSBundle mainBundle] pathForResource:@"ThrusterNeedle" ofType:@"plist"];
        self.thrusterIndicator = [[VGView alloc] initWithFrame:needleFrame withPaths:tiPath];
        self.thrusterIndicator.userInteractionEnabled = NO;
        self.thrusterIndicator.vectorName = @"thrusterIndicator";
        //self.thrusterIndicator.backgroundColor = [UIColor grayColor];
        [self addSubview:self.thrusterIndicator];
        
        // Thruster numeric value subview
        CGRect valueFrame = CGRectMake(25, frameRect.size.height, 40, 16);
        self.thrusterValue = [[VGLabel alloc] initWithFrame:valueFrame];
        self.thrusterValue.userInteractionEnabled = NO;
        self.thrusterValue.textAlignment = NSTextAlignmentRight;
        self.thrusterValue.vectorName = @"thrusterValue";
        //self.thrusterValue.backgroundColor = [UIColor grayColor];
        [self addSubview:self.thrusterValue];
        
        // Add names for debugging
        self.thrusterIndicator.vectorName = @"thrust";
        self.thrusterValue.vectorName = @"%thrust";
        self.thrusterSlider.vectorName = @"slider";
    }
    return self;
}

- (void)setValue:(float)newValue
{
    // Save our updated thruster value
    _value = newValue;
    
    // Calculate the scale
    float scaleValue = (self.thrusterSlider.frame.size.height - 2) / 100.0;
    
    // Position the needle within the view
    const CGFloat NeedleValueX = self.thrusterIndicator.frame.origin.x;
    const CGFloat NeedleValueY = (((scaleValue * self.value)) - self.thrusterIndicator.frame.size.height / 2);
    CGRect newNeedleFrame = CGRectMake(NeedleValueX, NeedleValueY, self.thrusterIndicator.frame.size.width, self.thrusterIndicator.frame.size.height);
    [self.thrusterIndicator setFrame:newNeedleFrame];
    [self.thrusterIndicator setNeedsDisplay];
    
    // Position the thrust value within the view
    const CGFloat yAdjust = 0;//self.thrusterValue.fontSize - 12;
    const CGFloat ThrusterValueX = self.thrusterValue.frame.origin.x;
    const CGFloat ThrusterValueY = (((scaleValue * self.value)) - self.thrusterValue.frame.size.height / 2 + yAdjust);
    CGRect newValueFrame = CGRectMake(ThrusterValueX, ThrusterValueY, self.thrusterValue.frame.size.width, self.thrusterValue.frame.size.height);
    [self.thrusterValue setFrame:newValueFrame];
    
    // Update the % thrust subview by dynamically creating a draw path
    NSString *thrustValue = [NSString stringWithFormat:@"%3.0f%%", self.value];
    NSNumber *textAlign = [NSNumber numberWithInt:(int)self.thrusterValue.textAlignment];

    NSDictionary *currentThrustPath = [NSDictionary dictionaryWithObjectsAndKeys:textAlign, @"alignment", thrustValue, @"text", nil];
    NSArray *path = [NSArray arrayWithObject:currentThrustPath];
    NSArray *paths = [NSArray arrayWithObject:path];
    self.thrusterValue.drawPaths = paths;
    [self.thrusterValue setNeedsDisplay];
}



#pragma mark Touch tracking

-(void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position
{
    // Ignore any touches processed after the control is disabled
    if (theView.userInteractionEnabled) {
        // Update the indicator needle position
        self.value = (position.y / theView.bounds.size.height) * 100.0f;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
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
