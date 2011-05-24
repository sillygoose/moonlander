//
//  Lander.m
//  Moonlander
//
//  Created by Rick on 5/24/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "Lander.h"


@implementation Lander

@synthesize thrust=_thrust;
@synthesize thrustData=_thrustData;
@synthesize angleData=_angleData;
@synthesize positionData=_positionData;
@synthesize previousAngle=_previousAngle;


- (void)setThrustData:(thrust_data_t)codeBlock
{
    _thrustData = codeBlock;
}

- (void)setAngleData:(angle_data_t)codeBlock
{
    _angleData = codeBlock;
}

- (void)setPositionData:(position_data_t)codeBlock
{
    _positionData = codeBlock;
}

- (id)init
{
    CGRect landerRect = CGRectMake(200, 200, 96, 96);
    self = [super initWithFrame:landerRect];
    if (self) {
        NSString *landerPath = [[NSBundle mainBundle] pathForResource:@"Lander" ofType:@"plist"];
        NSDictionary *landerDict = [NSDictionary dictionaryWithContentsOfFile:landerPath];
        self.drawPaths = [landerDict objectForKey:@"paths"];
        self.vectorName = @"[Lander initWithFrame]";
        
        CGRect thrustRect = CGRectMake(32, 72, 64, 24);
        self.thrust = [[VGView alloc] initWithFrame:thrustRect];
        //##
        NSString *thrustValue = [NSString stringWithFormat:@"AAAAA"];
        NSDictionary *currentThrustPath = [NSDictionary dictionaryWithObjectsAndKeys:thrustValue, @"text", nil];
        NSArray *path = [NSArray arrayWithObject:currentThrustPath];
        NSArray *paths = [NSArray arrayWithObject:path];
        self.thrust.drawPaths = paths;
        //##
        [self addSubview:self.thrust];
    }
    return self;
}

-(void)updateLander
{
    float thrust = self.thrustData();
    float angle = self.angleData();
    //###CGPoint position = self.positionData();
    //NSLog(@"thrust: %03f%%, angle: %03f, position:%@", thrust, angle, NSStringFromCGPoint(position));
    
    //##
    NSString *tString;
    if (thrust < 30) {
        tString = [NSString stringWithFormat:@"AAA"];
    }
    else if (thrust < 70) {
        tString = [NSString stringWithFormat:@"AAAAA"];
    }
    else {
        tString = [NSString stringWithFormat:@"AAAAAAA"];
    }
    NSString *thrustValue = [NSString stringWithFormat:@"%@", tString];
    NSDictionary *currentThrustPath = [NSDictionary dictionaryWithObjectsAndKeys:thrustValue, @"text", nil];
    NSArray *path = [NSArray arrayWithObject:currentThrustPath];
    NSArray *paths = [NSArray arrayWithObject:path];
    self.thrust.drawPaths = paths;
    [self.thrust setNeedsDisplay];
    //##
    
    if (self.previousAngle != angle) {
        CGAffineTransform t = [self transform];
        t = CGAffineTransformRotate(t, angle - self.previousAngle);
        [self setTransform:t];
        self.previousAngle = angle;
    }
    [self setNeedsDisplay];
}


@end
