//
//  LanderViewController.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderViewController_iPad.h"

#import "LanderMessage.h"


@implementation LanderViewController_iPad

@synthesize landerModel=_landerModel;

@synthesize landerView=_landerView;

@synthesize smallLeftArrow=_smallLeftArrow;
@synthesize smallRightArrow=_smallRightArrow;
@synthesize largeLeftArrow=_largeLeftArrow;
@synthesize largeRightArrow=_largeRightArrow;

@synthesize thrusterSlider=_thrusterSlider;

@synthesize newGameButton=_newGameButton;
@synthesize selectedTelemetry=_selectedTelemetry;

@synthesize simulationTimer=_simulationTimer;
@synthesize displayTimer=_displayTimer;

@synthesize heightData=_heightData;
@synthesize altitudeData=_altitudeData;
@synthesize distanceData=_distanceData;
@synthesize fuelLeftData=_fuelLeftData;
@synthesize weightData=_weightData;
@synthesize thrustData=_thrustData;
@synthesize thrustAngleData=_thrustAngleData;
@synthesize verticalVelocityData=_verticalVelocityData;
@synthesize horizontalVelocityData=_horizontalVelocityData;
@synthesize verticalAccelerationData=_verticalAccelerationData;
@synthesize horizontalAccelerationData=_horizontalAccelerationData;
@synthesize secondsData=_secondsData;

@synthesize instrument1=_instrument1;
@synthesize instrument2=_instrument2;
@synthesize instrument3=_instrument3;
@synthesize instrument4=_instrument4;

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
const float DisplayUpdateInterval = 0.25f;

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
    
    [_heightData release];
    [_altitudeData release];
    [_distanceData release];
    [_fuelLeftData release];
    [_weightData release];
    [_thrustData release];
    [_thrustAngleData release];
    [_verticalVelocityData release];
    [_horizontalVelocityData release];
    [_verticalAccelerationData release];
    [_horizontalAccelerationData release];
    [_secondsData release];
    
    //### release labels
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
    //###
    
    [_instrument1 release];
    [_instrument2 release];
    [_instrument3 release];
    [_instrument4 release];
    
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
    
    self.heightData.enabled = NO;
    self.altitudeData.enabled = NO;
    self.distanceData.enabled = NO;
    self.fuelLeftData.enabled = NO;
    self.weightData.enabled = NO;
    self.thrustData.enabled = NO;
    self.thrustAngleData.enabled = NO;
    self.verticalVelocityData.enabled = NO;
    self.horizontalVelocityData.enabled = NO;
    self.verticalAccelerationData.enabled = NO;
    self.horizontalAccelerationData.enabled = NO;
    self.secondsData.enabled = NO;
}

- (void)enableFlightControls
{
    self.smallLeftArrow.enabled = YES;
    self.smallRightArrow.enabled = YES;
    self.largeLeftArrow.enabled = YES;
    self.largeRightArrow.enabled = YES;
    
    self.thrusterSlider.enabled = YES;
    
    self.heightData.enabled = YES;
    self.altitudeData.enabled = YES;
    self.distanceData.enabled = YES;
    self.fuelLeftData.enabled = YES;
    self.weightData.enabled = YES;
    self.thrustData.enabled = YES;
    self.thrustAngleData.enabled = YES;
    self.verticalVelocityData.enabled = YES;
    self.horizontalVelocityData.enabled = YES;
    self.verticalAccelerationData.enabled = YES;
    self.horizontalAccelerationData.enabled = YES;
    self.secondsData.enabled = YES;
}

- (void)initGame
{
    [self enableFlightControls];
    
    [self.landerModel.delegate newGame];
    
    // Setup controls with model defaults
    self.thrusterSlider.value = [self.landerModel.dataSource thrustPercent];

    // Init displays
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];
    
    // Setup game timers
	self.simulationTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimerInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
	self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:DisplayUpdateInterval target:self selector:@selector(updateLander) userInfo:nil repeats:YES];
    
    [self updateLander];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the lander simulation model
    self.landerModel = [[LanderPhysicsModel alloc] init];
    self.landerModel.dataSource = self.landerModel;
    self.landerModel.delegate = self.landerModel;
 
    // Create the lander view with data sources
    self.landerView = [[Lander alloc] init];
    self.landerView.thrustData = Block_copy(^{ return [self.landerModel.dataSource thrustPercent];});
    self.landerView.angleData = Block_copy(^{ return [self.landerModel.dataSource angle];});
    self.landerView.positionData = Block_copy(^{ return [self.landerModel.dataSource landerPosition];});
    [self.view addSubview:self.landerView];
    
    // Create the roll control arrows
    NSString *slaPath = [[NSBundle mainBundle] pathForResource:@"SmallLeftArrow" ofType:@"plist"];
    self.smallLeftArrow = [[VGButton alloc] initWithFrame:CGRectMake(500, 400, 24, 24) withPaths:slaPath andRepeat:0.5f];
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
    self.largeLeftArrow = [[VGButton alloc] initWithFrame:CGRectMake(475, 450, 48, 24) withPaths:llaPath andRepeat:0.5f];
	[self.largeLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.largeLeftArrow];
    
    NSString *lraPath = [[NSBundle mainBundle] pathForResource:@"LargeRightArrow" ofType:@"plist"];
    self.largeRightArrow = [[VGButton alloc] initWithFrame:CGRectMake(550, 450, 48, 24) withPaths:lraPath andRepeat:0.5f];
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
    
    // Create the telemetry items
    self.heightData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 400, 100, 20)];
    self.heightData.titleLabel.text = @"HEIGHT";
    self.heightData.format = @"%6.0f %@";
    self.heightData.data = Block_copy(^{return [self.landerModel.dataSource height];});
	[self.heightData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.heightData];
    
    self.altitudeData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 420, 100, 20)];
    self.altitudeData.titleLabel.text = @"ALTITUDE";
    self.altitudeData.format = @"%6.0f %@";
    self.altitudeData.data = Block_copy(^{ return [self.landerModel.dataSource altitude];});
	[self.altitudeData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.altitudeData];
    
    self.distanceData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 440, 100, 20)];
    self.distanceData.titleLabel.text = @"DISTANCE";
    self.distanceData.format = @"%6.0f %@";
    self.distanceData.data = Block_copy(^{ return [self.landerModel.dataSource distance];});
	[self.distanceData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.distanceData];
    

    self.fuelLeftData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 460, 100, 20)];
    self.fuelLeftData.titleLabel.text = @"FUEL LEFT";
    self.fuelLeftData.format = @"%6.0f %@";
    self.fuelLeftData.data = Block_copy(^{ return [self.landerModel.dataSource fuel];});
	[self.fuelLeftData addTarget:self 
                         action:@selector(telemetrySelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fuelLeftData];
    
    self.weightData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 480, 100, 20)];
    self.weightData.titleLabel.text = @"WEIGHT";
    self.weightData.format = @"%6.0f %@";
    self.weightData.data = Block_copy(^{ return [self.landerModel.dataSource weight];});
	[self.weightData addTarget:self 
                                   action:@selector(telemetrySelected:) 
                         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weightData];

    self.thrustData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 500, 100, 20)];
    self.thrustData.titleLabel.text = @"THRUST";
    self.thrustData.format = @"%6.0f %@";
    self.thrustData.data = Block_copy(^{ return [self.landerModel.dataSource thrust];});
	[self.thrustData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.thrustData];
    
    self.thrustAngleData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 520, 100, 20)];
    self.thrustAngleData.titleLabel.text = @"ANGLE";
    self.thrustAngleData.format = @"%6.0f %@";
    self.thrustAngleData.data = Block_copy(^{ return [self.landerModel.dataSource angleDegrees];});
	[self.thrustAngleData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.thrustAngleData];
    
    self.verticalVelocityData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 540, 100, 20)];
    self.verticalVelocityData.titleLabel.text = @"VER VEL";
    self.verticalVelocityData.format = @"%6.0f %@";
    self.verticalVelocityData.data = Block_copy(^{ return [self.landerModel.dataSource vertVel];});
	[self.verticalVelocityData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.verticalVelocityData];
    
    self.horizontalVelocityData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 560, 100, 20)];
    self.horizontalVelocityData.titleLabel.text = @"HOR VEL";
    self.horizontalVelocityData.format = @"%6.0f %@";
    self.horizontalVelocityData.data = Block_copy(^{ return [self.landerModel.dataSource horizVel];});
	[self.horizontalVelocityData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.horizontalVelocityData];
    
    self.verticalAccelerationData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 580, 100, 20)];
    self.verticalAccelerationData.titleLabel.text = @"VER ACC";
    self.verticalAccelerationData.format = @"%6.0f %@";
    self.verticalAccelerationData.data = Block_copy(^{ return [self.landerModel.dataSource vertAccel];});
	[self.verticalAccelerationData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.verticalAccelerationData];
    
    self.horizontalAccelerationData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 600, 100, 20)];
    self.horizontalAccelerationData.titleLabel.text = @"HOR ACC";
    self.horizontalAccelerationData.format = @"%6.0f %@";
    self.horizontalAccelerationData.data = Block_copy(^{ return [self.landerModel.dataSource horizAccel];});
	[self.horizontalAccelerationData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.horizontalAccelerationData];
    
    self.secondsData = [[Telemetry alloc] initWithFrame:CGRectMake(600, 620, 100, 20)];
    self.secondsData.titleLabel.text = @"SECONDS";
    self.secondsData.format = @"%6.0f %@";
    self.secondsData.data = Block_copy(^{ return [self.landerModel.dataSource time];});
	[self.secondsData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.secondsData];
    
    // Create the user labels
    self.instrument1 = [[Instrument alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
    self.instrument1.instrument = self.heightData;
	[self.instrument1 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument1];
    
    self.instrument2 = [[Instrument alloc] initWithFrame:CGRectMake(250, 0, 200, 24)];
    self.instrument2.instrument = self.distanceData;
	[self.instrument2 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument2];
    
    self.instrument3 = [[Instrument alloc] initWithFrame:CGRectMake(500, 0, 200, 24)];
    self.instrument3.instrument = self.verticalVelocityData;
	[self.instrument3 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument3];
    
    self.instrument4 = [[Instrument alloc] initWithFrame:CGRectMake(750, 0, 200, 24)];
    self.instrument4.instrument = self.horizontalVelocityData;
	[self.instrument4 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument4];

    // Start the game
    [self initGame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.heightData = nil;
    self.altitudeData = nil;
    self.distanceData = nil;
    self.fuelLeftData = nil;
    self.weightData = nil;
    self.thrustData = nil;
    self.thrustAngleData = nil;
    self.verticalVelocityData = nil;
    self.horizontalVelocityData = nil;
    self.verticalAccelerationData = nil;
    self.horizontalAccelerationData = nil;
    self.secondsData = nil;
    
    self.instrument1 = nil;
    self.instrument2 = nil;
    self.instrument3 = nil;
    self.instrument4 = nil;
    
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

- (IBAction)telemetrySelected:(Telemetry *)sender
{
    if (sender == self.selectedTelemetry) {
        sender.titleLabel.blink = NO;
        self.selectedTelemetry = nil;
    }
    else if (self.selectedTelemetry) {
        self.selectedTelemetry.titleLabel.blink = NO;
        sender.titleLabel.blink = YES;
        self.selectedTelemetry = sender;
    }
    else {
        sender.titleLabel.blink = YES;
        self.selectedTelemetry = sender;
    }
}

- (IBAction)instrumentSelected:(Instrument *)sender
{
    if (self.selectedTelemetry) {
        sender.instrument = self.selectedTelemetry;
        self.selectedTelemetry.titleLabel.blink = NO;
        self.selectedTelemetry = nil;
    }
}

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
}

- (IBAction)newGame
{
    [self.simulationTimer invalidate];
    [self.displayTimer invalidate];
    
    [self initGame];
}

- (void)gameReset
{
}

- (void)updateLander
{
    [self.landerView updateLander];
    
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];
    
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %3.0f", [self.landerModel.dataSource time]];
    self.angleLabel.text = [NSString stringWithFormat:@"Angle: %3.0f", [self.landerModel.dataSource angleDegrees]];
    self.thrustLabel.text = [NSString stringWithFormat:@"Thrust: %3.0f", [self.landerModel.dataSource thrustPercent]];
    self.altitudeLabel.text = [NSString stringWithFormat:@"Altitude: %5.0f", [self.landerModel.dataSource altitude]];
    self.downrangeLabel.text = [NSString stringWithFormat:@"Downrange: %5.0f", [self.landerModel.dataSource distance
]];
    self.vertVelLabel.text = [NSString stringWithFormat:@"VertVel: %4.0f", [self.landerModel.dataSource vertVel]];
    self.horizVelLabel.text = [NSString stringWithFormat:@"HorizVel: %4.0f", [self.landerModel.dataSource horizVel]];
    self.vertAccelLabel.text = [NSString stringWithFormat:@"VertAccel: %3.1f", [self.landerModel.dataSource vertAccel]];
    self.horizAccelLabel.text = [NSString stringWithFormat:@"HorizAccel: %3.1f", [self.landerModel.dataSource horizAccel]];
    self.fuelRemainingLabel.text = [NSString stringWithFormat:@"Fuel: %4.0f", [self.landerModel.dataSource fuel]];
}

- (void)gameLoop
{
    [self.landerModel.delegate updateTime:GameTimerInterval];
    
    if ([self.landerModel.dataSource onSurface]) {
        // Update the thruster display
        [self.thrusterSlider setValue:[self.landerModel.dataSource thrustPercent]];
        if (self.selectedTelemetry) {
            self.selectedTelemetry.titleLabel.blink = NO;
            self.selectedTelemetry = nil;
        }
        
        // Disable flight controls
        [self disableFlightControls];
        
        [self.simulationTimer invalidate];
        self.simulationTimer = nil;
        [self.displayTimer invalidate];
        self.displayTimer = nil;
        
        [self updateLander];
    }
}

@end
