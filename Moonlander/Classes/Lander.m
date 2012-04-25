//
//  Lander.m
//  Moonlander
//
//  Created by Rick on 5/24/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "Lander.h"


@implementation Lander

@synthesize thrust=_thrust;
@synthesize thrustPercent=_thrustPercent;
@synthesize thrustData=_thrustData;
@synthesize angleData=_angleData;
@synthesize previousAngle=_previousAngle;

@synthesize FRAND=_FRAND;
@synthesize FSHIFT=_FSHIFT;
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

- (void)setThrustPercent:(thrust_percent_t)codeBlock
{
    _thrustPercent = codeBlock;
}

- (void)setThrustData:(thrust_data_t)codeBlock
{
    _thrustData = codeBlock;
}

- (void)setAngleData:(angle_data_t)codeBlock
{
    _angleData = codeBlock;
}


- (id)init
{
    const float LanderWidth = 96;
    const float LanderHeight = 96;
    const float ThrustWidth = 100;
    const float ThrustHeight = 100;
    
    CGRect landerRect = CGRectMake(0, 0, LanderWidth, LanderHeight);
    self = [super initWithFrame:landerRect];
    if (self) {
        // No events for the lander
        self.userInteractionEnabled = NO;
        
        // Load from a resource file
        NSString *landerPath = [[NSBundle mainBundle] pathForResource:@"Lander" ofType:@"plist"];
        NSDictionary *landerDict = [NSDictionary dictionaryWithContentsOfFile:landerPath];
        self.drawPaths = [landerDict objectForKey:@"paths"];
        self.vectorName = @"[Lander init]";
        
        // Create a view to display the thrust vectors
        const float ThrustXAdjust = -1;
        const float ThrustYAdjust = -LanderHeight / 2 + 3;
        CGRect thrustRect = CGRectMake(ThrustXAdjust, ThrustYAdjust, ThrustWidth, ThrustHeight);
        self.thrust = [[VGView alloc] initWithFrame:thrustRect];
        self.thrust.vectorName = @"thrustRect";
        [self addSubview:self.thrust];
    }
    return self;
}

- (void)createThrustVectors
{
    // Prepare to hide the view if we have no thrust vectors
    BOOL hideThrustView = YES;
    short thrustData = self.thrustData();
    if (thrustData > 0) {
        // Thrust generation tables
        const int FLEN = 12;
        // Not exact but looks more like simulator version
        const int YThrust[] = { 0, -19, -21, -23, -25, -27, -29, -31, -34, -37, -40, -43, -46 };
        const int YUpDown[] = { 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1 };
        const short DimYUpDown = sizeof(YUpDown)/sizeof(YUpDown[0]);
        const int FlameBT[] = { -20, -16, -13, -10, -7, -4, -2, 0, 2, 4, 7, 10, 13, 16, 20 };
        
        NSArray *paths = nil;
        short percentThrust = self.thrustPercent();
        if (percentThrust) {
            // We are displaying something
            hideThrustView = NO;
            
            //(FLAME) RET2 is the X coordinate, RET1 is the Y coordinate
            int RET1 = YThrust[percentThrust / 8];
            self.FRAND++;
            int RET2 = YUpDown[self.FRAND % DimYUpDown]; 
            RET1 += RET2;

            //
            self.FSHIFT += RET1;
            RET2 = self.FSHIFT & 0x03;

            NSMutableArray *xCoordinates = [[NSMutableArray alloc] init];
            NSMutableArray *yCoordinates = [[NSMutableArray alloc] init];
            //(FLAMLP)
            for (int i = 0; i < FLEN; i++) {
                //int deltaX = FlameBT[RET2] - prevX;
                //int deltaY = RET1 - prevY;
                [xCoordinates addObject:[NSNumber numberWithInt:FlameBT[RET2++]]];
                [yCoordinates addObject:[NSNumber numberWithInt:RET1]];
            }

            // Bump the intensity and line type
            self.flameLine += 1;
            self.flameIntensity += 3;

            // Start drawing now
            NSMutableArray *path = [[NSMutableArray alloc] init];
            paths = [NSArray arrayWithObject:path];
            
            // First center ourselves in the view
            NSNumber *centerValue = [NSNumber numberWithInt:0];
            NSDictionary *centerItem = [NSDictionary dictionaryWithObjectsAndKeys:centerValue, @"center", nil];
            NSDictionary *moveToCenterItem = [NSDictionary dictionaryWithObjectsAndKeys:centerItem, @"moveto", nil];
            [path addObject:moveToCenterItem];

            // Add a moveto command to return the thrust vector starting point
            const CGPoint ReturnPosition = CGPointMake(-7, 21);
            self.x = [NSNumber numberWithInt:ReturnPosition.x];
            self.y = [NSNumber numberWithInt:ReturnPosition.y];
            NSDictionary *moveRelItem = [NSDictionary dictionaryWithObjectsAndKeys:self.x, @"x", self.y, @"y", nil];
            NSDictionary *moveRelXYItem = [NSDictionary dictionaryWithObjectsAndKeys:moveRelItem, @"moverel", nil];
            [path addObject:moveRelXYItem];
      
#define DEBUG_NAMES
#ifdef DEBUG_NAMES
            // Add a name field for debugging
            NSString *viewName = @"thrust";
            NSDictionary *name = [NSDictionary dictionaryWithObjectsAndKeys:viewName, @"name", nil];
            [path addObject:name];
#endif
            
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
    
    // Display (or not) the flame vectors
    self.thrust.hidden = hideThrustView;
}

- (void)updateLander
{
    // Create the thrust view
    [self createThrustVectors];

    // Check if we have rotated and need to update the display
    float angle = self.angleData();
    if (self.previousAngle != angle) {
        CGAffineTransform t = self.transform;
        t = CGAffineTransformRotate(t, -(angle - self.previousAngle));
        self.transform = t;
        self.previousAngle = angle;
        
        // Update the view
        [self setNeedsDisplay];
    }
}

@end