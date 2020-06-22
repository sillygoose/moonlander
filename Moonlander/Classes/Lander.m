//
//  Lander.m
//  Moonlander
//
//  Created by Rick on 5/24/11.
//  Copyright 2011, 2012 Rick Naro. All rights reserved.
//

#import "Lander.h"


@implementation Lander

@synthesize thrust=_thrust;
@synthesize thrustPercent=_thrustPercent;
@synthesize thrustData=_thrustData;
@synthesize angleData=_angleData;
@synthesize previousAngle=_previousAngle;

@synthesize FRAND=_FRAND;
@synthesize FPSHIFT=_FPSHIFT;
@synthesize flameLine=_FlameLine;
@synthesize flameIntensity=_FlameIntensity;


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
    const CGFloat LanderWidth = 96;
    const CGFloat LanderHeight = 96;
    const CGFloat ThrustWidth = 100;
    const CGFloat ThrustHeight = 100;
    
    CGRect landerRect = CGRectMake(0, 0, LanderWidth, LanderHeight);
    self = [super initWithFrame:landerRect];
    if (self) {
        // No events for the lander
        self.userInteractionEnabled = NO;
        
        // Load from a resource file
        NSString *landerPath = [[NSBundle mainBundle] pathForResource:@"Lander" ofType:@"plist"];
        NSDictionary *landerDict = [NSDictionary dictionaryWithContentsOfFile:landerPath];
        self.drawPaths = [landerDict objectForKey:@"paths"];
#ifdef DEBUG
        self.vectorName = @"[Lander init]";
#endif
        
        // Create a view to display the thrust vectors
        const float ThrustXAdjust = -1;
        const float ThrustYAdjust = -LanderHeight / 2 + 3;
        CGRect thrustRect = CGRectMake(ThrustXAdjust, ThrustYAdjust, ThrustWidth, ThrustHeight);
        self.thrust = [[VGView alloc] initWithFrame:thrustRect];
#ifdef DEBUG
        self.thrust.vectorName = @"thrustRect";
#endif
        [self addSubview:self.thrust];
    }
    return self;
}

- (void)createThrustVectors
{
    typedef struct {
        short x;
        short y;
    } tvpoint_t;
    
    // Prepare to hide the view if we have no thrust vectors
    BOOL hideThrustView = YES;
    
    // Start by checking for thrust
    short thrustData = self.thrustData();
    if (thrustData > 0) {
        // Thrust generation tables
        const short FLEN = 12;
#define USE_ORIGINAL
#ifdef USE_ORIGINAL
        const short YTHRST[] = { 0, -30, -31, -32, -34, -36, -38, -41, -44, -47, -50, -53, -56 };
#else
        const short YTHRST[] = { 0, -19, -21, -23, -25, -27, -29, -31, -34, -37, -40, -43, -46 };
#endif
        const short YUPDWN[] = { 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1 };
        const short FLAMBT[] = { -20, -16, -13, -10, -7, -4, -2, 0, 2, 4, 7, 10, 13, 16, 20 };
        
        NSArray *paths = nil;
        short percentThrust = self.thrustPercent();
        if (percentThrust) {
            // We are displaying something
            hideThrustView = NO;
            
            //(FLAME) RET2 is the X coordinate, RET1 is the Y coordinate (length of flame)
            short RET1 = YTHRST[percentThrust / 8];
            self.FRAND += 1;
            short RET2 = self.FRAND & 0x1f;
            RET2 = YUPDWN[RET2]; 
            RET1 += RET2;
            self.FPSHIFT += RET1;
            RET2 = self.FPSHIFT & 0x03;
            //;LET RET2 POINT TO THE BYTE X TABLE

            // Start drawing now
            NSMutableArray *path = [[NSMutableArray alloc] init];
            paths = [NSArray arrayWithObject:path];
            
            // First center ourselves in the view
            NSNumber *centerValue = [NSNumber numberWithInt:0];
            NSDictionary *centerItem = [NSDictionary dictionaryWithObjectsAndKeys:centerValue, @"center", nil];
            NSDictionary *moveToCenterItem = [NSDictionary dictionaryWithObjectsAndKeys:centerItem, @"moveto", nil];
            [path addObject:moveToCenterItem];

            // Add a moveto command to position at the thrust vector drawing start point
            const tvpoint_t ReturnPosition = { -7, 21 };
            NSDictionary *moveRelItem = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ReturnPosition.x], @"x", [NSNumber numberWithInt:ReturnPosition.y], @"y", nil];
            NSDictionary *moveRelXYItem = [NSDictionary dictionaryWithObjectsAndKeys:moveRelItem, @"moverel", nil];
            [path addObject:moveRelXYItem];
      
            // Add line type and intensity for the currenrt draw cycle
            NSDictionary *lineType = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.flameLine], @"type", nil];
            NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys:lineType, @"line", nil];
            NSDictionary *intensity = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:self.flameIntensity], @"intensity", nil];
            [path addObject:line];
            [path addObject:intensity];
            
#ifdef DEBUG
            // Add a name field for debugging
            NSString *viewName = @"thrust";
            NSDictionary *name = [NSDictionary dictionaryWithObjectsAndKeys:viewName, @"name", nil];
            [path addObject:name];
#endif
            
            //(FLAMLP) Generate the drawing commands for the thrust vectors
            for (int i = 0; i < FLEN; i++) {
                // Add the thrust vector
                tvpoint_t thrustVector;
                thrustVector.x = FLAMBT[RET2++];
                thrustVector.y = RET1;
                
                // Draw the current vector
                NSDictionary *xyItem = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:thrustVector.x], @"x", [NSNumber numberWithInt:thrustVector.y], @"y", nil];
                [path addObject:xyItem];

                // Add the move back
                thrustVector.x = -thrustVector.x + 1;
                thrustVector.y = -thrustVector.y;
                NSDictionary *movetoItem = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:thrustVector.x], @"x", [NSNumber numberWithInt:thrustVector.y], @"y", nil];
                NSDictionary *movetoXYItem = [NSDictionary dictionaryWithObjectsAndKeys:movetoItem, @"moverel", nil];
                [path addObject:movetoXYItem];
            }
            
            // Bump the intensity and line type
            self.flameLine += 1;
            self.flameIntensity += 3;
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
