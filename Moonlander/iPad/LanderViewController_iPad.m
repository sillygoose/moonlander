//
//  LanderViewController.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderViewController_iPad.h"

#import "VGLabel.h"


@implementation LanderViewController_iPad

@synthesize landerModel=_landerModel;

@synthesize landerView=_landerView;

@synthesize smallLeftArrow=_smallLeftArrow;
@synthesize smallRightArrow=_smallRightArrow;
@synthesize largeLeftArrow=_largeLeftArrow;
@synthesize largeRightArrow=_largeRightArrow;

@synthesize thrusterSlider=_thrusterSlider;

@synthesize newGameButton=_newGameButton;

@synthesize simulationTimer=_simulationTimer;
@synthesize displayTimer=_displayTimer;

@synthesize heightLabel=_heightLabel;
@synthesize verticalDistanceLabel=_verticalDistanceLabel;
@synthesize distanceLabel=_distanceLabel;
@synthesize fuelLeftLabel=_fuelLeftLabel;
@synthesize weightLabel=_weightLabel;
@synthesize thrustProducedLabel=_thrustProducedLabel;
@synthesize thrustAngleLabel=_thrustAngleLabel;
@synthesize verticalVelocityLabel=_verticalVelocityLabel;
@synthesize horizontalVelocityLabel=_horizontalVelocityLabel;
@synthesize verticalAccelerationLabel=_verticalAccelerationLabel;
@synthesize horizontalAccelerationLabel=_horizontalAccelerationLabel;
@synthesize secondslLabel=_secondslLabel;

@synthesize user1Label=_user1Label;
@synthesize user2Label=_user2Label;
@synthesize user3Label=_user3Label;
@synthesize user4Label=_user4Label;

@synthesize timeLabel=_timeLabel;
@synthesize angleLabel=_angleLabel;
@synthesize thrustLabel=_thrustLabel;
@synthesize altitudeLabel=_altitudeLabel;
@synthesize downrangeLabel=_downrangeLabel;
@synthesize vertVelLabel=_vectVelLabel;
@synthesize horizVelLabel=_horizVelLabel;
@synthesize vertAccelLabel=_vertAccelLabel;
@synthesize horizAccelLabel=_horizAccelLabel;
@synthesize fuelRemainingLabel=_fuelRemainingLabel;


const float GameTimerInterval = 1.0 / 12.0f;
const float DisplayUpdateInterval = 1.0f;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_landerModel release];
    [_landerView release];
    
    [_smallLeftArrow release];
    [_smallRightArrow release];
    [_largeLeftArrow release];
    [_largeRightArrow release];
    
    [_thrusterSlider release];
    
    [_newGameButton release];
    
    [_simulationTimer release];
    [_displayTimer release];
    
    // release labels
    [_timeLabel release];
    [_angleLabel release];
    [_thrustLabel release];
    [_altitudeLabel release];
    [_downrangeLabel release];
    [_vertVelLabel release];
    [_horizVelLabel release];
    [_vertAccelLabel release];
    [_horizAccelLabel release];
    [_fuelRemainingLabel release];
    
    [_user1Label release];
    [_user2Label release];
    [_user3Label release];
    [_user4Label release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)disableFlightControls
{
    self.smallLeftArrow.enabled = NO;
    self.smallRightArrow.enabled = NO;
    self.largeLeftArrow.enabled = NO;
    self.largeRightArrow.enabled = NO;
    self.thrusterSlider.enabled = NO;
}

- (void)initGame
{
    [self.landerModel.delegate newGame];
    
    // Setup controls with model defaults
    self.thrusterSlider.value = [self.landerModel.dataSource thrustPercent];

    // Place the lander in the initial position
    CGAffineTransform t = [self.landerView transform];
	t = CGAffineTransformRotate(t, [self.landerModel.dataSource angle]);
	[self.landerView setTransform:t];
    
    // setup game timers
	self.simulationTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimerInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
	self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:DisplayUpdateInterval target:self selector:@selector(updateLander) userInfo:nil repeats:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.landerModel = [[LanderPhysicsModel alloc] init];
    self.landerModel.dataSource = self.landerModel;
    self.landerModel.delegate = self.landerModel;
 
#if 0
    VGLabel *txt1 = [[VGLabel alloc] initWithMessage:@"OneSmallStep"];
    [self.view addSubview:txt1];
    //VGLabel *txt2 = [[VGLabel alloc] initWithMessage:@"HitLander"];
    //[self.view addSubview:txt2];
#endif
    
    // Create the lander
    NSString *landerPath = [[NSBundle mainBundle] pathForResource:@"Lander" ofType:@"plist"];
    self.landerView = [[[VGView alloc] initWithFrame:CGRectMake(200, 200, 96, 96)] retain];
    [self.landerView addPathFile:landerPath]; 
    [self.view addSubview:self.landerView];
    
    // Create the roll control arrows
    NSString *slaPath = [[NSBundle mainBundle] pathForResource:@"SmallLeftArrow" ofType:@"plist"];
    self.smallLeftArrow = [[[VGButton alloc] initWithFrame:CGRectMake(500, 400, 24, 24) withPaths:slaPath andRepeat:0.5f] retain];//###retain?
	[self.smallLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.smallLeftArrow];
    
    NSString *sraPath = [[NSBundle mainBundle] pathForResource:@"SmallRightArrow" ofType:@"plist"];
    self.smallRightArrow = [[[VGButton alloc] initWithFrame:CGRectMake(550, 400, 24, 24) withPaths:sraPath andRepeat:0.5f] retain];
	[self.smallRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.smallRightArrow];
    
    NSString *llaPath = [[NSBundle mainBundle] pathForResource:@"LargeLeftArrow" ofType:@"plist"];
    self.largeLeftArrow = [[[VGButton alloc] initWithFrame:CGRectMake(475, 450, 48, 24) withPaths:llaPath andRepeat:0.5f] retain];
	[self.largeLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.largeLeftArrow];
    
    NSString *lraPath = [[NSBundle mainBundle] pathForResource:@"LargeRightArrow" ofType:@"plist"];
    self.largeRightArrow = [[[VGButton alloc] initWithFrame:CGRectMake(550, 450, 48, 24) withPaths:lraPath andRepeat:0.5f] retain];
	[self.largeRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.largeRightArrow];
    
    // Create the thruster control
    self.thrusterSlider = [[VGSlider alloc] initWithFrame:CGRectMake(400, 50, 200, 200)];
	[self.thrusterSlider addTarget:self 
                            action:@selector(thrusterChanged:) 
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.thrusterSlider];
    
    // Create the user labels
    self.user1Label = [[VGLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
    [self.view addSubview:self.user1Label];
    self.user2Label = [[VGLabel alloc] initWithFrame:CGRectMake(250, 0, 200, 24)];
    [self.view addSubview:self.user2Label];
    self.user3Label = [[VGLabel alloc] initWithFrame:CGRectMake(500, 0, 200, 24)];
    [self.view addSubview:self.user3Label];
    self.user4Label = [[VGLabel alloc] initWithFrame:CGRectMake(750, 0, 200, 24)];
    [self.view addSubview:self.user4Label];

#if 0
    NSString *labelsPath = [[NSBundle mainBundle] pathForResource:@"Labels" ofType:@"plist"];
    NSDictionary *labelsDict = [NSDictionary dictionaryWithContentsOfFile:labelsPath];
    
                                
    // Create the labels for the display selection
    self.heightLabel = [[VGButton alloc] initWithFrame:CGRectMake(550, 450, 48, 24)];
    self.heightLabel.drawPaths = nil;
    [self.view addSubview:self.heightLabel];
	[self.heightLabel addTarget:self 
                            action:@selector(buttonPressed:) 
                  forControlEvents:UIControlEventValueChanged];
    self.verticalDistanceLabel = [[VGButton alloc] initWithLabel:@"VertDistance" fromFile:@"Labels"];
    [self.view addSubview:self.verticalDistanceLabel];
    self.distanceLabel = [[VGButton alloc] initWithLabel:@"Distance" fromFile:@"Labels"];
    [self.view addSubview:self.distanceLabel];
    self.fuelLeftLabel = [[VGButton alloc] initWithLabel:@"Fuel" fromFile:@"Labels"];
    [self.view addSubview:self.fuelLeftLabel];
    self.weightLabel = [[VGButton alloc] initWithLabel:@"Weight" fromFile:@"Labels"];
    [self.view addSubview:self.weightLabel];
    self.thrustProducedLabel = [[VGButton alloc] initWithLabel:@"Thrust" fromFile:@"Labels"];
    [self.view addSubview:self.thrustProducedLabel];
    self.thrustAngleLabel = [[VGButton alloc] initWithLabel:@"Angle" fromFile:@"Labels"];
    [self.view addSubview:self.thrustAngleLabel];
    self.verticalVelocityLabel = [[VGButton alloc] initWithLabel:@"VertVel" fromFile:@"Labels"];
    [self.view addSubview:self.verticalVelocityLabel];
    self.horizontalVelocityLabel = [[VGButton alloc] initWithLabel:@"HorizVel" fromFile:@"Labels"];
    [self.view addSubview:self.horizontalVelocityLabel];
    self.verticalAccelerationLabel = [[VGButton alloc] initWithLabel:@"VertAccel" fromFile:@"Labels"];
    [self.view addSubview:self.verticalAccelerationLabel];
    self.horizontalAccelerationLabel = [[VGButton alloc] initWithLabel:@"HorizAccel" fromFile:@"Labels"];
    [self.view addSubview:self.horizontalAccelerationLabel];
    self.secondslLabel = [[VGButton alloc] initWithLabel:@"Seconds" fromFile:@"Labels"];
    [self.view addSubview:self.secondslLabel];
#endif
    
    [self initGame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.heightLabel = nil;
    self.verticalDistanceLabel = nil;
    self.distanceLabel = nil;
    self.fuelLeftLabel = nil;
    self.weightLabel = nil;
    self.thrustProducedLabel = nil;
    self.thrustAngleLabel = nil;
    self.verticalVelocityLabel = nil;
    self.horizontalVelocityLabel = nil;
    self.verticalAccelerationLabel = nil;
    self.horizontalAccelerationLabel = nil;
    self.secondslLabel = nil;
    
    self.user1Label = nil;
    self.user2Label = nil;
    self.user3Label = nil;
    self.user4Label = nil;
    
    self.newGameButton = nil;
    
    self.smallLeftArrow = nil;
    self.smallRightArrow = nil;
    self.largeLeftArrow = nil;
    self.largeRightArrow = nil;
    
    self.thrusterSlider = nil;
    
    self.landerView = nil;
    
    [self.simulationTimer invalidate];
    [self.displayTimer invalidate];
    self.simulationTimer = nil;
    self.displayTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#if 0
- (IBAction)buttonPressed:(VGButton *)sender
{
}
#endif

- (IBAction)thrusterChanged:(VGSlider *)sender
{
    [self.landerModel.dataSource setThrust:sender.value];
    [self.thrusterSlider setValue:[self.landerModel.dataSource thrustPercent]];
}

- (IBAction)rotateLander:(id)sender
{
    float deltaAngle = 0.0f;
    VGButton *buttonInUse = (VGButton *)sender;
    if ( buttonInUse == self.smallLeftArrow) {
        deltaAngle = -1.0f * M_PI / 180.0f;
    }
    else if (buttonInUse == self.smallRightArrow)
    {
        deltaAngle = 1.0f * M_PI / 180.0f;
    }
    else if (buttonInUse == self.largeLeftArrow) {
        deltaAngle = -5.0f * M_PI / 180.0f;
    }
    else if ( buttonInUse == self.largeRightArrow) {
        deltaAngle = 5.0f * M_PI / 180.0f;
    }
    else {
        assert(TRUE);
    }
    
    [self.landerModel.dataSource setAngle:([self.landerModel.dataSource angle] + deltaAngle)];
    
	CGAffineTransform t = [self.landerView transform];
	t = CGAffineTransformRotate(t, deltaAngle);
	[self.landerView setTransform:t];
}

- (IBAction)newGame
{
    [self.simulationTimer invalidate];
    [self.displayTimer invalidate];
    
    // Restore the lander in the initial position
    CGAffineTransform t = [self.landerView transform];
	t = CGAffineTransformRotate(t, -[self.landerModel.dataSource angle]);
	[self.landerView setTransform:t];
   
    [self initGame];
}

- (void)gameReset
{
}

- (void)updateLander
{
    self.user1Label.text = [NSString stringWithFormat:@"%6.0f HEIGHT", [self.landerModel.dataSource altitude]];
    self.user2Label.text = [NSString stringWithFormat:@"%6.0f DISTANCE", [self.landerModel.dataSource range]];
    self.user3Label.text = [NSString stringWithFormat:@"%6.0f VER VEL", [self.landerModel.dataSource vertVel]];
    self.user4Label.text = [NSString stringWithFormat:@"%6.0f HOR VEL", [self.landerModel.dataSource horizVel]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %3.0f", [self.landerModel.dataSource time]];
    self.angleLabel.text = [NSString stringWithFormat:@"Angle: %3.0f", [self.landerModel.dataSource angleDegrees]];
    self.thrustLabel.text = [NSString stringWithFormat:@"Thrust: %3.0f", [self.landerModel.dataSource thrustPercent]];
    self.altitudeLabel.text = [NSString stringWithFormat:@"Altitude: %5.0f", [self.landerModel.dataSource altitude]];
    self.downrangeLabel.text = [NSString stringWithFormat:@"Downrange: %5.0f", [self.landerModel.dataSource range]];
    self.vertVelLabel.text = [NSString stringWithFormat:@"VertVel: %4.0f", [self.landerModel.dataSource vertVel]];
    self.horizVelLabel.text = [NSString stringWithFormat:@"HorizVel: %4.0f", [self.landerModel.dataSource horizVel]];
    self.vertAccelLabel.text = [NSString stringWithFormat:@"VertAccel: %3.1f", [self.landerModel.dataSource vertAccel]];
    self.horizAccelLabel.text = [NSString stringWithFormat:@"HorizAccel: %3.1f", [self.landerModel.dataSource horizAccel]];
    self.fuelRemainingLabel.text = [NSString stringWithFormat:@"Fuel: %4.0f", [self.landerModel.dataSource fuel]];
}

- (void)gameLoop
{
    [self.landerModel.delegate updateTime:GameTimerInterval];
    
    if ([self.landerModel.dataSource altitude] == 0.0f) {
        [self.thrusterSlider setValue:[self.landerModel.dataSource thrustPercent]];
        [self disableFlightControls];
        
        [self.simulationTimer invalidate];
        self.simulationTimer = nil;
        [self.displayTimer invalidate];
        self.displayTimer = nil;
        
        [self updateLander];
    }
}

@end
