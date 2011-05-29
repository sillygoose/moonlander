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

@synthesize flameRandom=_flameRandom;
@synthesize flameShift=_FlameShift;
@synthesize flameLine=_FlameLine;
@synthesize flameIntensity=_FlameIntensity;
@synthesize x=_x;
@synthesize y=_y;


- (void)setFlameLine:(int)flameLine
{
    _FlameLine = flameLine;
    _FlameLine &= 0x3;
}

- (void)setFlameIntensity:(int)flameIntensity
{
    _FlameIntensity = flameIntensity;
    _FlameIntensity &= 0x7;
}

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
        self.vectorName = @"[Lander init]";
        
        CGRect thrustRect = CGRectMake(0, 0, 100, 100);
        self.thrust = [[VGView alloc] initWithFrame:thrustRect];
        self.thrust.vectorName = @"thrustRect";
        [self addSubview:self.thrust];
    }
    return self;
}

- (void)createThrustVectors
{
    const int FLEN = 12;
    const int YThrust[] = { 0, -30, -31, -32, -34, -36, -38, -41, -44, -47, -50, -53, -56 };
    const int YUpDown[] = { 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1 };
    const int FlameBT[] = { -20, -16, -13, -10, -7, -4, -2, 0, 2, 4, 7, 10, 13, 16, 20 };
    
    NSArray *paths = nil;
    unsigned percentThrust = (unsigned)self.thrustData();
    if (percentThrust) {
        int RET1 = YThrust[percentThrust / 8];
        self.flameRandom++;
        int RET2 = YUpDown[(self.flameRandom % (sizeof(YUpDown)/sizeof(YUpDown[0])))]; 
        RET1 += RET2;
        RET1 = -RET1;

        self.flameShift += RET1;
        RET2 = self.flameShift;
        RET2 &= 3;

        NSMutableArray *xCoordinates = [[NSMutableArray alloc] init];
        NSMutableArray *yCoordinates = [[NSMutableArray alloc] init];
        for (int i = 0; i < FLEN; i++) {
            //int deltaX = FlameBT[RET2] - prevX;
            //int deltaY = RET1 - prevY;
            [xCoordinates addObject:[NSNumber numberWithInt:FlameBT[RET2++]]];
            [yCoordinates addObject:[NSNumber numberWithInt:RET1]];
        }

        self.flameLine += 1;
        self.flameIntensity += 3;

        // Start drawing now
        NSMutableArray *path = [[NSMutableArray alloc] init];
        paths = [NSArray arrayWithObject:path];
        
    #if 0
        NSLog(@"X(%3.0f): %@", self.thrustData(), xCoordinates);
        NSLog(@"Y(%3.0f): %@", self.thrustData(), yCoordinates);
        NSNumber *breakValue = [NSNumber numberWithBool:YES];
        NSDictionary *breakItem = [NSDictionary dictionaryWithObjectsAndKeys:breakValue, @"break", nil];
        [path addObject:breakItem];
    #endif
        
        NSNumber *centerValue = [NSNumber numberWithInt:0];
        NSDictionary *centerItem = [NSDictionary dictionaryWithObjectsAndKeys:centerValue, @"center", nil];
        NSDictionary *moveToCenterItem = [NSDictionary dictionaryWithObjectsAndKeys:centerItem, @"moveto", nil];
        [path addObject:moveToCenterItem];
        
        //int prevX = 0;
        //int prevY = 0;
        //prevX = FlameBT[RET2++];
        //prevY = RET1;

        self.x = [NSNumber numberWithInt:-7];
        self.y = [NSNumber numberWithInt:21];
        NSDictionary *moveRelItem = [NSDictionary dictionaryWithObjectsAndKeys:self.x, @"x", self.y, @"y", nil];
        NSDictionary *moveRelXYItem = [NSDictionary dictionaryWithObjectsAndKeys:moveRelItem, @"moverel", nil];
        [path addObject:moveRelXYItem];
        
        for (int i = 0; i < xCoordinates.count; i++) {
            // Add line type and intensity
            NSDictionary *lineType = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.flameLine], @"type", nil];
            NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys:lineType, @"line", nil];
            NSDictionary *intensity = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.flameIntensity], @"intensity", nil];
            [path addObject:line];
            [path addObject:intensity];

            NSDictionary *xyItem = [NSDictionary dictionaryWithObjectsAndKeys:[xCoordinates objectAtIndex:i], @"x", [yCoordinates objectAtIndex:i], @"y", nil];
            [path addObject:xyItem];

            int moveToX = [[xCoordinates objectAtIndex:i] intValue];
            int moveToY = [[yCoordinates objectAtIndex:i] intValue];
            moveToX = -moveToX + 1;
            moveToY = -moveToY;

            self.x = [NSNumber numberWithInt:moveToX];
            self.y = [NSNumber numberWithInt:moveToY];
            NSDictionary *moveRelItem = [NSDictionary dictionaryWithObjectsAndKeys:self.x, @"x", self.y, @"y", nil];
            NSDictionary *moveRelXYItem = [NSDictionary dictionaryWithObjectsAndKeys:moveRelItem, @"moverel", nil];
            [path addObject:moveRelXYItem];
        }
    }
    
    self.thrust.drawPaths = paths;
    [self.thrust setNeedsDisplay];
}

- (void)updateLander
{
    [self createThrustVectors];
    
    //float thrust = self.thrustData();
    float angle = self.angleData();
    //###CGPoint position = self.positionData();
    //NSLog(@"thrust: %03f%%, angle: %03f, position:%@", thrust, angle, NSStringFromCGPoint(position));
    
    if (self.previousAngle != angle) {
        CGAffineTransform t = [self transform];
        t = CGAffineTransformRotate(t, (angle - self.previousAngle));
        self.transform = t;
        self.previousAngle = angle;
    }
    [self setNeedsDisplay];
}

@end
