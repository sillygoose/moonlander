//
//  LanderViewController.m
//  Moonlander
//
//  Created by Rick on 5/10/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "LanderViewController.h"

#import "LanderMessage.h"

// Add any custom debugging options
#if defined(TARGET_IPHONE_SIMULATOR) && defined(DEBUG)
//#define DEBUG_SHORT_DELAYS
//#define DEBUG_NO_SPLASH
//#define DEBUG_EXTRA_INSTRUMENTS
//#define DEBUG_GRAB_EMPTY_SCREEN
//#define DEBUG_ENHANCED
//#define DEBUG_MESSAGES
#endif


@implementation LanderViewController

@synthesize landerModel=_landerModel;
@synthesize landerType=_landerType;

@synthesize moonView=_moonView;
@synthesize landerView=_landerView;
@synthesize dustView=_dustView;
@synthesize explosionManager=_explosionManager;
@synthesize manView=_manView;
@synthesize flagView=_flagView;

@synthesize SHOWX=_SHOWX;
@synthesize SHOWY=_SHOWY;
@synthesize BIGXCT=_BIGXCT;
@synthesize LEFTEDGE=_LEFTEDGE;
@synthesize LEFEET=_LEFEET;
@synthesize INDEXL=_INDEXL;
@synthesize INDEXLR=_INDEXLR;
@synthesize RADARY=_RADARY;
@synthesize AVERY=_AVERY;
@synthesize AVERT=_AVERT;
@synthesize DUSTX=_DUSTX;

@synthesize lastTime=_lastTime;

@synthesize smallLeftArrow=_smallLeftArrow;
@synthesize smallRightArrow=_smallRightArrow;
@synthesize largeLeftArrow=_largeLeftArrow;
@synthesize largeRightArrow=_largeRightArrow;

@synthesize thrusterSlider=_thrusterSlider;

@synthesize selectedTelemetry=_selectedTelemetry;

@synthesize landerModelTimer=_landerModelTimer;
@synthesize gameLogicTimer=_gameLogicTimer;
@synthesize landerUpdateTimer=_landerUpdateTimer;
@synthesize positionUpdateTimer=_positionUpdateTimer;
@synthesize instrumentUpdateTimer=_instrumentUpdateTimer;

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

@synthesize instrument5=_instrument5;
@synthesize instrument6=_instrument6;
@synthesize instrument7=_instrument7;
@synthesize instrument8=_instrument8;

@synthesize landerMessages=_landerMessages;

@synthesize anotherGameDialog=_anotherGameDialog;

@synthesize didFuelAlert=_didFuelAlert;

@synthesize beepSound=_beepSound;
@synthesize explosionSound=_explosionSound;


// Simulation constants
const float GameLogicTimerInterval = 0.10;          // How often the game logic checks run (10 hz)
const float LanderViewUpdateInterval = 0.10f;       // How often the lander view is updated (affects rotation and thrust vector drawing)
const float PositionUpdateInterval = 0.01;          // How often the lander position is updated
const float InstrumentUpdateInterval = 0.2;         // How often the instrument displays are updated
const float LanderModelUpdateInterval = 0.02;       // How often the lander model is updated (aka PDP11 line clock)

const float RollButtonRepeatInterval = 0.20;        // Timer value for roll button hold down



- (float)getDelay:(MoonlanderDelay)delayItem
{
#if defined(DEBUG) && defined(DEBUG_SHORT_DELAYS)
    static float Delays[DelayLast][2] = {
        {  0.0,  0.0 },   // DelayZero
        {  2.0,  2.0 },   // DelaySplashScreen
        {  0.5,  0.5 },   // DelayLanding
        {  0.01, 0.01 },  // DelayMoveMan
        {  0.5,  0.5 },   // DelayOrderFood
        {  0.5,  0.5 },   // DelayPickupFood
        {  0.5,  0.5 },   // DelayTakeoff
        {  1.0,  1.0 },   // DelayGameover
        {  1.0,  1.0 },   // DelayNewGame
        {  2.0,  2.0 },   // DelayFlagPlanted
        {  2.0,  2.0 },   // DelayExplode
        {  2.0,  2.0 },   // DelayOffcom
    };
#else
    static float Delays[DelayLast][2] = {
        {  0.0,  0.0 },   // DelayZero
        { 10.0,  7.0 },   // DelaySplashScreen
        {  4.0,  3.0 },   // DelayLanding
        {  0.08, 0.07 },  // DelayMoveMan
        {  8.0,  3.0 },   // DelayOrderFood
        {  2.0,  1.0 },   // DelayPickupFood
        {  2.0,  1.0 },   // DelayTakeoff
        {  3.0,  2.0 },   // DelayGameover
        {  3.0,  3.0 },   // DelayNewGame
        { 10.0,  4.0 },   // DelayFlagPlanted
        {  5.0,  5.0 },   // DelayExplode
    };
#endif
    assert(sizeof(Delays)/sizeof(Delays[0]) == DelayLast);
    
    // This will give us more modern delays and speed things up
    float delay = Delays[delayItem][LanderTypeModern];
    return delay;
}


#pragma -
#pragma mark Delegate
- (void)beep
{
    AudioServicesPlayAlertSound(self.beepSound);
}

- (void)explosion
{
    AudioServicesPlayAlertSound(self.explosionSound);
}

- (BOOL)WallpaperController
{
    return NO;
}


#pragma -
#pragma mark Data source

- (CGFloat)gameFontSize
{
    return 15;
}

- (LanderType)landerType
{
    return LanderTypeClassic;
}

- (CGPoint)LANDER
{
    return [self.landerModel.dataSource landerPosition];
}

- (short)VERDIS
{
    return [self.landerModel.dataSource altitude];
}

- (void)setVERDIS:(short)value
{
    [self.landerModel.dataSource setAltitude:value];
}

- (short)HORDIS
{
    return [self.landerModel.dataSource distance];
}

- (void)setHORDIS:(short)value
{
    [self.landerModel.dataSource setDistance:value];
}

- (short)PERTRS
{
    return [self.landerModel.dataSource thrustPercent];
}

- (void)setPERTRS:(short)value
{
    [self.landerModel.dataSource setThrust:value];
    [self.thrusterSlider setValue:self.PERTRS];
}

- (float)ANGLE
{
    return [self.landerModel.dataSource angle];
}

- (short)ANGLED
{
    return [self.landerModel.dataSource angleDegrees];
}

- (void)setANGLED:(short)value
{
    [self.landerModel.dataSource setAngleDegrees:value];
}

- (short)HORVEL
{
    return [self.landerModel.dataSource horizVel];
}

- (void)setHORVEL:(short)value
{
    [self.landerModel.dataSource setHorizVel:value];
}

- (short)VERVEL
{
    return [self.landerModel.dataSource vertVel];
}

- (void)setVERVEL:(short)value
{
    [self.landerModel.dataSource setVertVel:value];
}

- (short)VERACC
{
    return [self.landerModel.dataSource vertAccel];
}

- (short)HORACC
{
    return [self.landerModel.dataSource horizAccel];
}

- (short)THRUST
{
    return [self.landerModel.dataSource thrust];
}

- (void)setTHRUST:(short)value
{
    [self.landerModel.dataSource setThrust:value];
}

- (short)MAXTHRUST
{
    return [self.landerModel.dataSource maximumThrust];
}

- (float)TIME
{
    return [self.landerModel.dataSource time];
}

- (float)GRAVITY
{
    return [self.landerModel.dataSource moonGravity];
}

- (short)WEIGHT
{
    return [self.landerModel.dataSource weight];
}

- (short)FUEL
{
    return [self.landerModel.dataSource fuel];
}

- (void)setFUEL:(short)value
{
    [self.landerModel.dataSource setFuel:value];
}

- (short)INITIALFUEL
{
    return [self.landerModel.dataSource initialFuel];
}


#pragma -
#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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

- (void)disableRollFlightControls
{
    self.smallLeftArrow.enabled = NO;
    self.smallRightArrow.enabled = NO;
    self.largeLeftArrow.enabled = NO;
    self.largeRightArrow.enabled = NO;
}

- (void)enableRollFlightControls
{
    self.smallLeftArrow.enabled = YES;
    self.smallRightArrow.enabled = YES;
    self.largeLeftArrow.enabled = YES;
    self.largeRightArrow.enabled = YES;
}

- (void)disableThrustFlightControls
{
    self.thrusterSlider.enabled = NO;
}

- (void)enableThrustFlightControls
{
    self.thrusterSlider.enabled = YES;
}

- (void)getStarted
{
    // Start with a normal view
    [self.landerModel newGame];
    
    // Remove the flag if present
    if (self.flagView) {
        [self.flagView removeFromSuperview];
        self.flagView = nil;
    }
    
    // Remove the man if present
    if (self.manView) {
        [self.manView removeFromSuperview];
        self.manView = nil;
    }
    
    // No fuel alert issued
    self.didFuelAlert = NO;
    
    // Enable all flight controls
    [self enableFlightControls];
    
    // Setup controls with model defaults
    self.thrusterSlider.value = self.PERTRS;
    
    // Defaultinstrument displays
    self.instrument1.instrument = self.heightData;
    self.instrument2.instrument = self.distanceData;
    self.instrument3.instrument = self.verticalVelocityData;
    self.instrument4.instrument = self.horizontalVelocityData;
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];
    
#ifdef DEBUG_EXTRA_INSTRUMENTS
    // These are hidden normally
    self.instrument5.instrument = self.altitudeData;
    self.instrument5.hidden = NO;
    self.instrument6.instrument = self.fuelLeftData;
    self.instrument6.hidden = NO;
    self.instrument7.instrument = self.thrustAngleData;
    self.instrument7.hidden = NO;
    self.instrument8.instrument = self.secondsData;
    self.instrument8.hidden = NO;
    [self.instrument5 display];
    [self.instrument6 display];
    [self.instrument7 display];
    [self.instrument8 display];
#endif
    
    // Setup the game timers
    [self setupTimers];

    // Starting position
    self.SHOWX = -4096;
    self.SHOWY = -4096;
    self.landerView.center = CGPointMake(self.SHOWX, self.SHOWY);

    // Add the lander to the view
    self.landerView.hidden = NO;
}

- (void)initGame:(BOOL)splash
{
    if (splash) {
        // Splash screen
#if defined(DEBUG_NO_SPLASH) || defined(DEBUG_MESSAGES)
#if defined(DEBUG_MESSAGES)
        // Put each message on the screen to allow checking
        [self.landerMessages test];
#endif
        [self performSelector:@selector(initGame2) withObject:nil afterDelay:0];
#else
        if ([self.landerMessages hasSystemMessage] == NO) {
#if !defined(DEBUG)
            [self.landerMessages addSystemMessage:@"SplashScreen"];
#endif
        }
        
        self.landerMessages.hidden = NO;
    }
#if defined(DEBUG)
    float delayInterval = 0;
#else
    float delayInterval = (splash) ? [self getDelay:DelaySplashScreen] : [self getDelay:DelayZero];
#endif
    [self performSelector:@selector(initGame2) withObject:nil afterDelay:delayInterval];
#endif
}

- (void)initGame2
{
    // Remove splash screen (if present)
    [self.landerMessages removeAllLanderMessages];

    // Enable message display
    self.landerMessages.hidden = NO;
    
    // Enable instrumentation
    self.instrument1.hidden = NO;
    self.instrument2.hidden = NO;
    self.instrument3.hidden = NO;
    self.instrument4.hidden = NO;

    // Unhide the views to get started after splash screen
    self.smallLeftArrow.hidden = NO;
    self.smallRightArrow.hidden = NO;
    self.largeLeftArrow.hidden = NO;
    self.largeRightArrow.hidden = NO;
    self.thrusterSlider.hidden = NO;

    self.heightData.hidden = NO;
    self.altitudeData.hidden = NO;
    self.distanceData.hidden = NO;
    self.fuelLeftData.hidden = NO;
    self.weightData.hidden = NO;
    self.thrustData.hidden = NO;
    self.thrustAngleData.hidden = NO;
    self.verticalVelocityData.hidden = NO;
    self.horizontalVelocityData.hidden = NO;
    self.verticalAccelerationData.hidden = NO;
    self.horizontalAccelerationData.hidden = NO;
    self.secondsData.hidden = NO;

    [self getStarted];
}

- (void)loadFlightControls
{
    // Create the roll control arrows
    const float SmallRollArrowWidth = 35;
    const float SmallRollArrowHeight = 40;
    const CGFloat SmallRollYPos = (self.landerType == LanderTypeClassic) ? 355 : 410;
    NSString *slaPath = [[NSBundle mainBundle] pathForResource:@"SmallLeftArrow" ofType:@"plist"];
    self.smallLeftArrow = [[VGButton alloc] initWithFrame:CGRectMake(920, SmallRollYPos, SmallRollArrowWidth, SmallRollArrowHeight)  withPaths:slaPath andRepeat:RollButtonRepeatInterval];
	[self.smallLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    self.smallLeftArrow.hidden = YES;
    self.smallLeftArrow.brighten = YES;
    self.smallLeftArrow.titleLabel.vectorName = @"sla";
    [self.view addSubview:self.smallLeftArrow];
    
    NSString *sraPath = [[NSBundle mainBundle] pathForResource:@"SmallRightArrow" ofType:@"plist"];
    self.smallRightArrow = [[VGButton alloc] initWithFrame:CGRectMake(960, SmallRollYPos, SmallRollArrowWidth, SmallRollArrowHeight) withPaths:sraPath andRepeat:RollButtonRepeatInterval];
	[self.smallRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    self.smallRightArrow.hidden = YES;
    self.smallRightArrow.brighten = YES;
    self.smallRightArrow.titleLabel.vectorName = @"sra";
    [self.view addSubview:self.smallRightArrow];
    
    const float LargeRollArrowWidth = 50;
    const float LargeRollArrowHeight = 40;
    const CGFloat LargeRollYPos = (self.landerType == LanderTypeClassic) ? 310: 360;
    NSString *llaPath = [[NSBundle mainBundle] pathForResource:@"LargeLeftArrow" ofType:@"plist"];
    self.largeLeftArrow = [[VGButton alloc] initWithFrame:CGRectMake(905, LargeRollYPos, LargeRollArrowWidth, LargeRollArrowHeight) withPaths:llaPath andRepeat:RollButtonRepeatInterval];
	[self.largeLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    self.largeLeftArrow.hidden = YES;
    self.largeLeftArrow.brighten = YES;
    self.largeLeftArrow.titleLabel.vectorName = @"lla";
    [self.view addSubview:self.largeLeftArrow];
    
    NSString *lraPath = [[NSBundle mainBundle] pathForResource:@"LargeRightArrow" ofType:@"plist"];
    self.largeRightArrow = [[VGButton alloc] initWithFrame:CGRectMake(960, LargeRollYPos, LargeRollArrowWidth, LargeRollArrowHeight) withPaths:lraPath andRepeat:RollButtonRepeatInterval];
	[self.largeRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    self.largeRightArrow.hidden = YES;
    self.largeRightArrow.brighten = YES;
    self.largeRightArrow.titleLabel.vectorName = @"lra";
    [self.view addSubview:self.largeRightArrow];
    
    // Create the thruster control
    const short ThrusterSliderWidth = 200;
    const short ThrusterSliderHeight = (self.landerType == LanderTypeClassic) ? 252 : 232;
    const short ThrusterXPos = 826;
    const short ThrusterYPos = (self.landerType == LanderTypeClassic) ? 450 : 470;
    self.thrusterSlider = [[VGSlider alloc] initWithFrame:CGRectMake(ThrusterXPos, ThrusterYPos, ThrusterSliderWidth, ThrusterSliderHeight)];
	[self.thrusterSlider addTarget:self 
                            action:@selector(thrusterChanged:) 
                  forControlEvents:UIControlEventValueChanged];
    self.thrusterSlider.hidden = YES;
    self.thrusterSlider.thrusterValue.fontSize = self.gameFontSize;
    [self.view addSubview:self.thrusterSlider];
}

- (void)loadTelemetry
{
    // Create the telemetry items
	const CGFloat TelemetryXPos = 920;
    const CGFloat TelemetryXSize = 100;
    const CGFloat TelemetryYSize = 24;
    __weak LanderViewController *weakSelf = self;

    short instrumentID = (self.landerType == LanderTypeModern) ? 1 : 0;
    short instrumentY = (self.landerType == LanderTypeModern) ? 320 : 250;
    short instrumentYDelta = (self.landerType == LanderTypeModern) ? 27 : 22;;

    self.heightData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.heightData.titleLabel.text = @"HEIGHT";
    self.heightData.format = @"%6d %@";
    self.heightData.data = [^{ return weakSelf.RADARY;} copy];
	[self.heightData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.heightData.titleLabel.fontSize = self.gameFontSize;
    self.heightData.titleLabel.vectorName = @"heightData";
    [self.view addSubview:self.heightData];
    
    self.altitudeData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.altitudeData.titleLabel.text = @"ALTITUDE";
    self.altitudeData.format = @"%6d %@";
    self.altitudeData.data = [^{ return weakSelf.VERDIS;} copy];
	[self.altitudeData addTarget:self 
                          action:@selector(telemetrySelected:) 
                forControlEvents:UIControlEventTouchUpInside];
    self.altitudeData.titleLabel.fontSize = self.gameFontSize;
    self.altitudeData.titleLabel.vectorName = @"altitudeData";
    [self.view addSubview:self.altitudeData];
    
    self.distanceData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.distanceData.titleLabel.text = @"DISTANCE";
    self.distanceData.format = @"%6d %@";
    self.distanceData.data = [^{ return weakSelf.HORDIS;} copy];
	[self.distanceData addTarget:self 
                          action:@selector(telemetrySelected:) 
                forControlEvents:UIControlEventTouchUpInside];
    self.distanceData.titleLabel.fontSize = self.gameFontSize;
    self.distanceData.titleLabel.vectorName = @"distanceData";
    [self.view addSubview:self.distanceData];
    
    
    self.fuelLeftData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.fuelLeftData.titleLabel.text = @"FUEL LEFT";
    self.fuelLeftData.format = @"%6d %@";
    self.fuelLeftData.data = [^{ return weakSelf.FUEL;} copy];
	[self.fuelLeftData addTarget:self 
                          action:@selector(telemetrySelected:) 
                forControlEvents:UIControlEventTouchUpInside];
    self.fuelLeftData.titleLabel.fontSize = self.gameFontSize;
    self.fuelLeftData.titleLabel.vectorName = @"fuelLeftData";
    [self.view addSubview:self.fuelLeftData];
    
    self.weightData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.weightData.titleLabel.text = @"WEIGHT";
    self.weightData.format = @"%6d %@";
    self.weightData.data = [^{ return weakSelf.WEIGHT;} copy];
	[self.weightData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.weightData.titleLabel.fontSize = self.gameFontSize;
    self.weightData.titleLabel.vectorName = @"weightData";
    [self.view addSubview:self.weightData];
    
    self.thrustData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.thrustData.titleLabel.text = @"THRUST";
    self.thrustData.format = @"%6d %@";
    self.thrustData.data = [^{ return weakSelf.THRUST;} copy];
	[self.thrustData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.thrustData.titleLabel.fontSize = self.gameFontSize;
    self.thrustData.titleLabel.vectorName = @"thrustData";
    [self.view addSubview:self.thrustData];
    
    self.thrustAngleData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.thrustAngleData.titleLabel.text = @"ANGLE";
    self.thrustAngleData.format = @"%6d %@";
    self.thrustAngleData.data = [^{ return weakSelf.ANGLED;} copy];
	[self.thrustAngleData addTarget:self 
                             action:@selector(telemetrySelected:) 
                   forControlEvents:UIControlEventTouchUpInside];
    self.thrustAngleData.titleLabel.fontSize = self.gameFontSize;
    self.thrustAngleData.titleLabel.vectorName = @"thrustAngleData";
    [self.view addSubview:self.thrustAngleData];
    
    self.verticalVelocityData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.verticalVelocityData.titleLabel.text = @"VER VEL";
    self.verticalVelocityData.format = @"%6d %@";
    self.verticalVelocityData.data = [^{ return weakSelf.VERVEL;} copy];
	[self.verticalVelocityData addTarget:self 
                                  action:@selector(telemetrySelected:) 
                        forControlEvents:UIControlEventTouchUpInside];
    self.verticalVelocityData.titleLabel.fontSize = self.gameFontSize;
    self.verticalVelocityData.titleLabel.vectorName = @"verticalVelocityData";
    [self.view addSubview:self.verticalVelocityData];
    
    self.horizontalVelocityData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.horizontalVelocityData.titleLabel.text = @"HOR VEL";
    self.horizontalVelocityData.format = @"%6d %@";
    self.horizontalVelocityData.data = [^{ return weakSelf.HORVEL;} copy];
	[self.horizontalVelocityData addTarget:self 
                                    action:@selector(telemetrySelected:) 
                          forControlEvents:UIControlEventTouchUpInside];
    self.horizontalVelocityData.titleLabel.fontSize = self.gameFontSize;
    self.horizontalVelocityData.titleLabel.vectorName = @"horizontalVelocityData";
    [self.view addSubview:self.horizontalVelocityData];
    
    self.verticalAccelerationData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.verticalAccelerationData.titleLabel.text = @"VER ACC";
    self.verticalAccelerationData.format = @"%6d %@";
    self.verticalAccelerationData.data = [^{ return weakSelf.VERACC;} copy];
	[self.verticalAccelerationData addTarget:self 
                                      action:@selector(telemetrySelected:) 
                            forControlEvents:UIControlEventTouchUpInside];
    self.verticalAccelerationData.titleLabel.fontSize = self.gameFontSize;
    self.verticalAccelerationData.titleLabel.vectorName = @"verticalAccelerationData";
    [self.view addSubview:self.verticalAccelerationData];
    
    self.horizontalAccelerationData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.horizontalAccelerationData.titleLabel.text = @"HOR ACC";
    self.horizontalAccelerationData.format = @"%6d %@";
    self.horizontalAccelerationData.data = [^{ return weakSelf.HORACC;} copy];
	[self.horizontalAccelerationData addTarget:self 
                                        action:@selector(telemetrySelected:) 
                              forControlEvents:UIControlEventTouchUpInside];
    self.horizontalAccelerationData.titleLabel.fontSize = self.gameFontSize;
    self.horizontalAccelerationData.titleLabel.vectorName = @"horizontalAccelerationData";
    [self.view addSubview:self.horizontalAccelerationData];
    
    self.secondsData = [[Telemetry alloc] initWithFrame:CGRectMake(TelemetryXPos, (instrumentY - instrumentYDelta * instrumentID++), TelemetryXSize, TelemetryYSize)];
    self.secondsData.titleLabel.text = @"SECONDS";
    self.secondsData.format = @"%6d %@";
    self.secondsData.data =[^{ return (short)weakSelf.TIME;} copy];
	[self.secondsData addTarget:self 
                         action:@selector(telemetrySelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.secondsData.titleLabel.fontSize = self.gameFontSize;
    self.secondsData.titleLabel.vectorName = @"secondsData";
    [self.view addSubview:self.secondsData];
}

- (void)loadInstruments
{
    // Create the instrumentation labels
    const float InstrumentSizeWidth = 200;
    const float InstrumentSizeHeight = 24;
    const float InstrumentYCoordinate = 720;
    const float InstrumentYCoordinate2 = InstrumentYCoordinate - InstrumentSizeHeight;
    self.instrument1 = [[Instrument alloc] initWithFrame:CGRectMake(0, InstrumentYCoordinate, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument1.instrument = self.heightData;
	[self.instrument1 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument1.titleLabel.fontSize = self.gameFontSize;
    self.instrument1.titleLabel.vectorName = @"instrument1";
    [self.view addSubview:self.instrument1];
    
    self.instrument2 = [[Instrument alloc] initWithFrame:CGRectMake(250, InstrumentYCoordinate, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument2.instrument = self.distanceData;
	[self.instrument2 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument2.titleLabel.fontSize = self.gameFontSize;
    self.instrument2.titleLabel.vectorName = @"instrument2";
    [self.view addSubview:self.instrument2];
    
    self.instrument3 = [[Instrument alloc] initWithFrame:CGRectMake(500, InstrumentYCoordinate, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument3.instrument = self.verticalVelocityData;
	[self.instrument3 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument3.titleLabel.fontSize = self.gameFontSize;
    self.instrument3.titleLabel.vectorName = @"instrument3";
    [self.view addSubview:self.instrument3];
    
    self.instrument4 = [[Instrument alloc] initWithFrame:CGRectMake(750, InstrumentYCoordinate, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument4.instrument = self.horizontalVelocityData;
	[self.instrument4 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument4.titleLabel.fontSize = self.gameFontSize;
    self.instrument4.titleLabel.vectorName = @"instrument4";
    [self.view addSubview:self.instrument4];
    
    self.instrument5 = [[Instrument alloc] initWithFrame:CGRectMake(0, InstrumentYCoordinate2, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument5.instrument = self.altitudeData;
	[self.instrument5 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument5.titleLabel.fontSize = self.gameFontSize;
    self.instrument5.titleLabel.vectorName = @"instrument5";
    [self.view addSubview:self.instrument5];
    
    self.instrument6 = [[Instrument alloc] initWithFrame:CGRectMake(250, InstrumentYCoordinate2, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument6.instrument = self.fuelLeftData;
	[self.instrument6 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument6.titleLabel.fontSize = self.gameFontSize;
    self.instrument6.titleLabel.vectorName = @"instrument6";
    [self.view addSubview:self.instrument6];
    
    self.instrument7 = [[Instrument alloc] initWithFrame:CGRectMake(500, InstrumentYCoordinate2, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument7.instrument = self.thrustAngleData;
	[self.instrument7 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument7.titleLabel.fontSize = self.gameFontSize;
    self.instrument7.titleLabel.vectorName = @"instrument7";
    [self.view addSubview:self.instrument7];
    
    self.instrument8 = [[Instrument alloc] initWithFrame:CGRectMake(750, InstrumentYCoordinate2, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument8.instrument = self.secondsData;
	[self.instrument8 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument8.titleLabel.fontSize = self.gameFontSize;
    self.instrument8.titleLabel.vectorName = @"instrument8";
    [self.view addSubview:self.instrument8];
}

- (void)viewDidLoad
{
    // Have our super view do its work
    [super viewDidLoad];

    // Set out lander type
    self.landerType = LanderTypeClassic;
    
    // Setup the transform we need to match the original
    self.view.transform = CGAffineTransformConcat(self.view.transform, CGAffineTransformMake(1, 0, 0, -1, 0, 0));

    // Create the lander simulation model
    self.landerModel = [[LanderPhysicsModel alloc] init];
    self.landerModel.modernModel = self.landerType;
    
    // Create the dust view
    self.dustView = [[Dust alloc] init];
    self.dustView.delegate = self;
    [self.view addSubview:self.dustView];
    
    // Create the message manager
    self.landerMessages = [[LanderMessages alloc] init];
    self.landerMessages.delegate = self;
    [self.view addSubview:self.landerMessages];
    
    // Create the flight controls, telemerty, and instrument panel
    [self loadFlightControls];
    [self loadTelemetry];
    [self loadInstruments];
    
    // Create the lander view with data sources
    __weak LanderViewController *weakSelf = self;
    self.landerView = [[Lander alloc] init];
    self.landerView.userInteractionEnabled = NO;
    self.landerView.contentMode = UIViewContentModeRedraw;
    self.landerView.thrustPercent = [^{ return weakSelf.PERTRS;} copy];
    self.landerView.thrustData = [^{ return weakSelf.THRUST;} copy];
    self.landerView.angleData = [^{ return weakSelf.ANGLE;} copy];
    self.landerView.hidden = YES;
    [self.view addSubview:self.landerView];
    
    // Audio resource initialization
    CFURLRef beepFileURL = (__bridge CFURLRef) [[NSBundle mainBundle] URLForResource: @"beep-med" withExtension: @"caf"];
    AudioServicesCreateSystemSoundID(beepFileURL, &_beepSound);
    CFURLRef explodeFileURL = (__bridge CFURLRef) [[NSBundle mainBundle] URLForResource: @"explosion-med" withExtension: @"caf"];
    AudioServicesCreateSystemSoundID(explodeFileURL, &_explosionSound);
    
    // Setup initial conditions
    [self initGame:YES];
    
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    if ([self WallpaperController] == NO) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), @""]];
    }
#endif
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // This works best here.  If is viewWillAppear it works for classic/modern but not for menu background
    if (self.moonView == nil) {
        self.moonView = [[Moon alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.moonView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Pause simulation when not visible
    [self cleanupTimers]; 
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        // See if the user wished to continue
        [self performSelector:@selector(continueGame) withObject:nil afterDelay:0];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)prepareToUnload
{
    // Kill any active timers
    [self cleanupTimers];
    
    // Disable telemetry
    self.selectedTelemetry = nil;
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
    
    // Disable instruments
    self.instrument1 = nil;
    self.instrument2 = nil;
    self.instrument3 = nil;
    self.instrument4 = nil;
    
    self.instrument5 = nil;
    self.instrument6 = nil;
    self.instrument7 = nil;
    self.instrument8 = nil;
    
    // Flight controls
    self.smallLeftArrow = nil;
    self.smallRightArrow = nil;
    self.largeLeftArrow = nil;
    self.largeRightArrow = nil;
    self.thrusterSlider = nil;
    
    // Model
    self.landerModel = nil;
    
    // Views
    self.moonView = nil;
    self.landerView = nil;
    self.dustView = nil;
    self.explosionManager = nil;
    self.manView = nil;
    self.flagView = nil;
    
    self.landerMessages = nil;
    self.anotherGameDialog = nil;
    
    // Audio resources
    AudioServicesDisposeSystemSoundID(self.beepSound);
    AudioServicesDisposeSystemSoundID(self.explosionSound);
}

- (void)setupTimers
{
    if (self.landerModelTimer == nil) {
        self.landerModelTimer = [NSTimer scheduledTimerWithTimeInterval:LanderModelUpdateInterval target:self selector:@selector(landerModelTimerEvent) userInfo:nil repeats:YES];
    }
    if (self.gameLogicTimer == nil) {
        self.gameLogicTimer = [NSTimer scheduledTimerWithTimeInterval:GameLogicTimerInterval target:self selector:@selector(gameLogicTimerEvent) userInfo:nil repeats:YES];
    }
    if (self.landerUpdateTimer == nil) {
        self.landerUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:LanderViewUpdateInterval target:self selector:@selector(updateLander) userInfo:nil repeats:YES];
    }
    if (self.positionUpdateTimer == nil) {
        self.positionUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:PositionUpdateInterval target:self selector:@selector(updateLanderPosition) userInfo:nil repeats:YES];
    }
    if (self.instrumentUpdateTimer == nil) {
        self.instrumentUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:InstrumentUpdateInterval target:self selector:@selector(updateInstruments) userInfo:nil repeats:YES];
    }
}

- (void)cleanupTimers
{
    [self.landerModelTimer invalidate];
    self.landerModelTimer = nil;
    [self.gameLogicTimer invalidate];
    self.gameLogicTimer = nil;
    [self.landerUpdateTimer invalidate];
    self.landerUpdateTimer = nil;
    [self.positionUpdateTimer invalidate];
    self.positionUpdateTimer = nil;
    [self.instrumentUpdateTimer invalidate];
    self.instrumentUpdateTimer = nil;
}

- (void)cleanupControls
{
    // Disable the flight controls
    [self disableFlightControls];
    
    // Make sure no controls are left blinking
    self.heightData.titleLabel.blink = NO;
    self.altitudeData.titleLabel.blink = NO;
    self.distanceData.titleLabel.blink = NO;
    self.fuelLeftData.titleLabel.blink = NO;
    self.weightData.titleLabel.blink = NO;
    self.thrustData.titleLabel.blink = NO;
    self.thrustAngleData.titleLabel.blink = NO;
    self.verticalVelocityData.titleLabel.blink = NO;
    self.horizontalVelocityData.titleLabel.blink = NO;
    self.verticalAccelerationData.titleLabel.blink = NO;
    self.horizontalAccelerationData.titleLabel.blink = NO;
    self.secondsData.titleLabel.blink = NO;
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
    // Update the model with the new thrust setting and read back what was actually set
    self.PERTRS = (short)sender.value;
    [self.thrusterSlider setValue:self.PERTRS];
}

//
// Need to emulate better, original code uses +-15 and +-100 degrees per second for the roll
// rates using the calculation
//
// new_angle += (rate_of_turn * clock_ticks) / clock_frequency
//
// or something like
//
//    (100 * ticks) / 50
//
- (IBAction)rotateLander:(id)sender
{
    // Roll rates in degrees
    const float MajorRollRate = 5;
    const float MinorRollRate = 1;
    
    float deltaAngle = 0;
    VGButton *buttonInUse = (VGButton *)sender;
    if ( buttonInUse == self.smallLeftArrow) {
        deltaAngle = -MinorRollRate;
    }
    else if (buttonInUse == self.smallRightArrow)
    {
        deltaAngle = MinorRollRate;
    }
    else if (buttonInUse == self.largeLeftArrow) {
        deltaAngle = -MajorRollRate;
    }
    else if ( buttonInUse == self.largeRightArrow) {
        deltaAngle = MajorRollRate;
    }
    else {
        assert(TRUE);
    }
    
    // Calculate the change in roll angle
    deltaAngle = deltaAngle;
    
    // Update the model with the change in roll angle
    self.ANGLED += (short)deltaAngle;
}

- (void)newGame
{
    // Make sure we didn't leave any messages displayed
    [self.landerMessages removeAllLanderMessages];
    
    // Start over
    [self initGame2];
}

- (void)updateLander
{
    // Update the lander
    [self.landerView updateLander];
}

- (void)OFFCOM:(float)xPosition withMessage:(NSString *)message
{
    // This code is used to handle the display boundary violations
    short newHDistance = xPosition * 32 - 22400;
    short newVertVel = self.VERDIS / 40;
    if (newVertVel >= 0) {
        newVertVel = -newVertVel;
    }

    // Setup for a crash
    self.HORDIS = newHDistance;
    self.FUEL = 0;
    self.HORVEL = 0;
    self.VERVEL = newVertVel;

    // Add the message to the display
    [self.landerMessages addSystemMessage:message];
}

- (short)DFAKE:(short)yValue
{
    return (yValue * 3) / 8 + 23;
}

- (void)landerDown
{
    // Disable flight controls
    [self disableRollFlightControls];
    
    // Tell model we are on surface
    [self.landerModel landerDown];
    
    // Update the thruster display so it shows our updated value
    [self.thrusterSlider setValue:self.PERTRS];

    // Remove a low fuel message
    [self.landerMessages removeFuelMessage];

    // Final lander view update
    [self updateLander];
}

- (void)startGameDelay
{
    [self newGame];
}

- (void)getYesNo
{
    // Get the user's input
    BOOL result = [self.anotherGameDialog dialogResult];
    
    // Remove the dialog
    [self.anotherGameDialog removeFromSuperview];
    self.anotherGameDialog = nil;

    // Decide what to do
    if (result == YES) {
        // Delay a bit before starting the new game
        [self performSelector:@selector(startGameDelay) withObject:nil afterDelay:[self getDelay: DelayNewGame]];
    }
    else {
        // Return to the main menu
        [self prepareToUnload];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)waitNewGame
{
    // Setup the yes/no dialog for a new game
    const CGFloat DialogWidth = 250;
    const CGFloat DialogHeight = 250;
    const CGFloat DialogX = self.view.bounds.size.width / 2 - DialogWidth / 2;
    const CGFloat DialogY = self.view.bounds.size.height / 2 - DialogHeight / 2;
    CGRect dialogRect = CGRectMake(DialogX, DialogY, DialogWidth, DialogHeight);
    self.anotherGameDialog = [[VGDialog alloc] initWithFrame:dialogRect addTarget:self onSelection:@selector(getYesNo)];
    [self.view addSubview:self.anotherGameDialog];
}

- (void)getContinueYesNo
{
    // Get the user's input
    BOOL result = [self.anotherGameDialog dialogResult];
    
    // Remove the dialog
    [self.anotherGameDialog removeFromSuperview];
    self.anotherGameDialog = nil;
    
    // Decide what to do
    if (result == YES) {
        // Do nothing - keep playing
        [self setupTimers];
    }
    else {
        // Clean up any timers and flight controls
        [self cleanupTimers];
        [self cleanupControls];
        
        // Remove any messages that might be left over
        [self.landerMessages removeAllLanderMessages];
        
        // Return to the main menu
        [self prepareToUnload];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)continueGame
{
    // Stop game play while we wait
    [self cleanupTimers];

    // Setup our yes/no dialog for a new game
    const CGFloat DialogWidth = 250;
    const CGFloat DialogHeight = 250;
    const CGFloat DialogX = self.view.bounds.size.width / 2 - DialogWidth / 2;
    const CGFloat DialogY = self.view.bounds.size.height / 2 - DialogHeight / 2;
    CGRect dialogRect = CGRectMake(DialogX, DialogY, DialogWidth, DialogHeight);
    self.anotherGameDialog = [[VGDialog alloc] initWithFrame:dialogRect addTarget:self onSelection:@selector(getContinueYesNo)];
    self.anotherGameDialog.dialogText.text = @"Continue?";
    [self.view addSubview:self.anotherGameDialog];
}

- (void)prepareForNewGame
{
    // Clean up any timers and flight controls
    [self cleanupTimers];
    [self cleanupControls];
    
    // Remove any messages that might be left over
    [self.landerMessages removeAllLanderMessages];
    
    // Short delay and then restart
    [self performSelector:@selector(waitNewGame) withObject:nil afterDelay:[self getDelay:DelayNewGame]];
}

- (void)landerLiftoff
{
    // Remove any messages that pop up
    [self.landerMessages removeAllLanderMessages];
    
    // Force the controls to the departure values
    self.HORVEL = 0;
    self.THRUST = 30;
    self.ANGLED = 0;
    [self.thrusterSlider setValue:self.PERTRS];
    
    // Check if we have gotten out of the detailed view
    if (![self.moonView viewIsDetailed]) {
        // Hide the lander 
        self.landerView.hidden = YES;

        // Wait a bit before continuing
        [self performSelector:@selector(prepareForNewGame) withObject:nil afterDelay:[self getDelay: DelayTakeoff]];
    }
    else {
        // Keep waiting for screen change
        const float PollLiftoffInterval = 0.4;
        [self performSelector:@selector(landerLiftoff) withObject:nil afterDelay:PollLiftoffInterval];
    }
}

- (float)durationFrom:(CGPoint)start toEnd:(CGPoint)end
{
    float xDiff = start.x - end.x;
    float yDiff = start.y - end.y;
    float distance = sqrt(xDiff * xDiff + yDiff * yDiff);
    float animationDuration = [self getDelay:DelayMoveMan] * distance;
    return animationDuration;
}

- (void)moveMan
{
    // Animation constants
    const float ManHeightOffFloor = 8;
    const float ManVerticalAdjust = -3;
  
    const UIViewAnimationOptions animateOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    
    // Animation constants for tweaking getting in and out of the lander
    const float LanderMoveX = 32;
    const float LanderMoveY = 26;
    
    // Our animation block variables
    __block CGPoint delta;
    __block short direction;
    __block CGPoint destination;
    __block float animationDuration;
    
    // Put the man in position to head for lunch or plant the flag
    CGPoint start = CGPointMake(self.SHOWX, self.SHOWY + ManVerticalAdjust);
    self.manView = [[Man alloc] initWithOrigin:start];
    [self.view addSubview:self.manView];
    
    // Remember the starting center so we can retrace our path
    CGPoint startCenter = self.manView.center;
    
    // What is it - plant a flag or visit Mcdonalds?
    if (self.moonView.displayHasMcDonalds) {
        // Move the man out of the lander to the ground
        __block CGPoint destination = CGPointMake(self.moonView.MACX, self.moonView.MACY + ManHeightOffFloor);
        direction = (destination.x < start.x) ? -1 : 1;

        // Blocks used in the McDonalds animation
        void (^moveMan)(void) = ^{
            self.manView.center = delta;
        };

        void (^prepareForLiftoff)(void) = ^{
            // Remove the man view
            [self.manView removeFromSuperview];
            self.manView = nil;
            
            // No more messages at this point
            [self.landerMessages removeAllLanderMessages];

            // Calculate the score
            int landingScore = 1000;
            float fuelRatio = (self.FUEL / (float)self.INITIALFUEL);
            int fuelScore = 100 * (0.5 - fuelRatio);
            if (fuelScore < 0)
                fuelScore = 0;
            landingScore -= fuelScore;
            landingScore -= 2 * abs(self.HORDIS);
            landingScore -= 10 * abs(self.ANGLED);
            landingScore -= 10 * abs(self.VERVEL);
            landingScore -= 10 * abs(self.HORVEL);

            // Don't allow the menu background to submit scores
            if ([self WallpaperController] == NO) {
                // Post the score for Game Center
                [[NSNotificationCenter defaultCenter] postNotificationName:@"mcdonaldsScorePosted" object:[NSNumber numberWithInt:landingScore]];
            }

            // Now take off with the food and some extra fuel
            self.VERDIS += 4;
            self.FUEL += 200;
            self.ANGLED = 0;
            self.VERVEL = 0;
            self.HORVEL = 0;
            self.THRUST = 30;
            
            // Renable roll flightr controls
            [self enableRollFlightControls];
            
            // Tell model we are taking off from the surface
            [self.landerModel landerTakeoff];
            
            // Wait a bit before continuing
            [self landerLiftoff];
        };
        
        void (^moveComplete)(BOOL) = ^(BOOL f) {
            // Slight delay before taking off again
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, [self getDelay:DelayTakeoff] * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), prepareForLiftoff);
        };
        
        void (^moveManUp)(BOOL) = ^(BOOL f) {
            // Complete the move up into the lander
            delta = startCenter;
            animationDuration = [self durationFrom:self.manView.center toEnd:delta];
            [Man animateWithDuration:animationDuration delay:[self getDelay:DelayZero] options:animateOptions animations:moveMan completion:moveComplete];
        };
        
        void (^moveManBack)(BOOL) = ^(BOOL f) {
            // Dismiss our message and head back to the lander
            [self.landerMessages removeSystemMessage:@"YourOrder"];
            
            // Complete the move back to the lander
            delta.x = startCenter.x + LanderMoveX * direction;
            delta.y = destination.y;
            animationDuration = [self durationFrom:self.manView.center toEnd:delta];
            [Man animateWithDuration:animationDuration delay:[self getDelay:DelayZero] options:animateOptions animations:moveMan completion:moveManUp];
        };
        
        void (^getLunch)(BOOL) = ^(BOOL f) {
            // Order some food and wait
            [self.landerMessages addSystemMessage:@"YourOrder"];
            
            // Trick to do a minicule move so use the deal option
            delta.x = destination.x + 1 * direction;
            delta.y = destination.y;
            [Man animateWithDuration:[self getDelay:DelayZero] delay:[self getDelay:DelayOrderFood] options:animateOptions animations:moveMan completion:moveManBack];
        };
        
        void (^moveManOver)(BOOL) = ^(BOOL f) {
            // Get our current position
            delta = destination;
            animationDuration = [self durationFrom:self.manView.center toEnd:delta];
            [Man animateWithDuration:animationDuration delay:[self getDelay:DelayZero] options:animateOptions animations:moveMan completion:getLunch];
        };
        
        // First move down to the base of the lander and out to plant a flag
        delta = CGPointMake(startCenter.x + LanderMoveX * direction, destination.y);
        animationDuration = [self durationFrom:startCenter toEnd:delta];
        [Man animateWithDuration:animationDuration delay:[self getDelay:DelayZero] options:animateOptions animations:moveMan completion:moveManOver];
    }
    else {
        // Select a direction at random to plant the flag
        direction = (random() % 2) ? 1 : -1;
        
        // Destination is the flag plant spot
        destination = startCenter;
        destination.x -= LanderMoveX * direction * 2;
        destination.y -= LanderMoveY;
        
        // Blocks used in the flag plant animation
        void (^moveMan)(void) = ^{ self.manView.center = delta; };
        void (^waitFlagMan)(void) = ^{
            // Don't need the man anymore
            [self.manView removeFromSuperview];
            self.manView = nil;
            
            // Remove messages and add the lander to the terrain data
            [self.landerMessages removeAllLanderMessages];
            [self.moonView addFeature:TF_OldLander atIndex:self.INDEXL];
            
            // Let's delay a bit before presenting the new game dialog
            [self performSelector:@selector(prepareForNewGame) withObject:nil afterDelay:[self getDelay: DelayNewGame]];
        };
        
        void (^plantFlag)(BOOL) = ^(BOOL f) {
            // Add the flag to the terrain and display our message
            short flagIndex = self.INDEXL - 2 * direction;
            [self.moonView addFeatureToView:TF_OldFlag atTerrainIndex:flagIndex];
            [self.moonView addFeature:TF_OldFlag atIndex:flagIndex refresh:NO];
            [self.landerMessages addSystemMessage:@"OneSmallStep"];
            
            // Delay a bit before finishing the game
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, [self getDelay: DelayFlagPlanted] * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), waitFlagMan);
        };
        
        // Move the man over to the flag
        void (^moveManOver)(BOOL) = ^(BOOL f) {
            delta = destination;
            animationDuration = [self durationFrom:self.manView.center toEnd:delta];
            [Man animateWithDuration:animationDuration delay:[self getDelay:DelayZero] options:animateOptions animations:moveMan completion:plantFlag];
        };
        
        // First move down to the base of the lander
        delta = startCenter;
        delta.x -= direction * LanderMoveX / 2;
        delta.y -= LanderMoveY;
        animationDuration = [self durationFrom:startCenter toEnd:delta];
        [Man animateWithDuration:animationDuration delay:[self getDelay:DelayZero] options:animateOptions animations:moveMan completion:moveManOver];
    }
}

- (void)PALSY
{
    // This is a successful landing
    if ([self WallpaperController] == NO) {
        // Post the Game Center leaderboards numbers
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fuelScorePosted" object:[NSNumber numberWithInt:self.FUEL]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"distanceScorePosted" object:[NSNumber numberWithInt:abs(self.HORDIS)]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fastestScorePosted" object:[NSNumber numberWithFloat:self.TIME]];
        
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Landed at %d, distance (%d), vervel (%d), horvel (%d), fuel (%d)", (short)self.TIME, self.HORDIS, self.VERVEL, self.HORVEL, self.FUEL]];
#endif
    }
    
    // Start with a delay of 4 seconds
    [self performSelector:@selector(moveMan) withObject:nil afterDelay:[self getDelay: DelayLanding]];
}

- (void)EXPLOD
{
    // We are down hard, hide and lander and shut down the model
    self.landerView.hidden = YES;

    // Turn off fuel, flames, and dust
    [self landerDown];

    // Completion code for explosion manager
    void (^completionBlock)(void) = ^{
        [self performSelector:@selector(prepareForNewGame) withObject:nil afterDelay:[self getDelay:DelayExplode]];
    };
    
    //(EXPLD1)  Setup the explosion animation manager
    ExplosionManager *explosionManager = [[ExplosionManager alloc] init];
    explosionManager.parentView = self.view;
    explosionManager.completionBlock = completionBlock;
    explosionManager.delegate = self;
    [explosionManager start];
}

- (void)ALTER:(short)alterValue
{
    [self.moonView alterMoon:alterValue atIndex:(self.landerType == LanderTypeClassic) ? self.BIGXCT : self.BIGXCT-1];
}

- (void)INTEL
{
    BOOL MAYBE = NO;
    BOOL QUICK = NO;
    BOOL AHAHC = NO;
    
    //(INTELM)
    if (self.RADARY < -10) {
        //(DEAD)
        [self.landerMessages addSystemMessage:@"DeadLanding"];
        QUICK = YES;
    }
    else if (self.RADARY <= 3) {
        //(VERYLO)  We landed or crashed, turn off fuel, flames, and dust
        [self landerDown];
        
        //(VD)
        short vervel = self.VERVEL;
        if (vervel < -60) {
            [self.landerMessages addSystemMessage:@"DeadLanding"];
            QUICK = YES;
        }
        else if (vervel < -30) {
            [self.landerMessages addSystemMessage:@"CrippledLanding"];
            MAYBE = YES;
        }
        else if (vervel < -15) {
            [self.landerMessages addSystemMessage:@"RoughLanding"];
            MAYBE = YES;
        }
        else if (vervel < -8) {
            [self.landerMessages addSystemMessage:@"GoodLanding"];
            MAYBE = YES;
        }
        else {
            [self.landerMessages addSystemMessage:@"GreatLanding"];
            MAYBE = YES;
        }
    }
    else {
        short vervel = self.VERVEL;
        if (vervel < -60) {
            //(AHAH)
            [self.landerMessages addSystemMessage:@"VeryFast"];
            AHAHC = YES;
        }
        else if (vervel < -30) {
            //(AHAH2)
            [self.landerMessages addSystemMessage:@"Fast"];
            AHAHC = YES;
        }
        else if (vervel < -15) {
            //(AHAH3)
            [self.landerMessages addSystemMessage:@"Not2Fast"];
            AHAHC = YES;
        }
        else {
            // Delete not too fast message if displayed
            [self.landerMessages removeSystemMessage:@"Not2Fast"];
            AHAHC = YES;
        }
    }
        
    if (AHAHC) {
        // Check for features we might have hit
        TerrainFeature tf = [self.moonView featureAtIndex:self.INDEXL];
        if (tf == TF_OldLander) {
            if (self.RADARY <= 26) {
                if (self.VERVEL <= -60) {
                    //GODEAD
                    [self.landerMessages addSystemMessage:@"DeadLanding"];
                    QUICK = YES;
                }
                else {
                    [self.landerMessages addSystemMessage:@"HitLander"];
                    if (self.HORVEL < 0)
                        [self.moonView addFeature:TF_OldLanderTippedLeft atIndex:self.INDEXL];
                    else
                        [self.moonView addFeature:TF_OldLanderTippedRight atIndex:self.INDEXL];
                    
                    // Adjust vertical position on the old lander
                    self.SHOWY += 4;
                    
                    // Turn off fuel, flames, and dust
                    [self landerDown];

                    // Let's delay a bit before presenting the new game dialog
                    [self performSelector:@selector(prepareForNewGame) withObject:nil afterDelay:[self getDelay:DelayExplode]];
                }
            }
        }
        else if (tf == TF_OldLanderTippedLeft || tf == TF_OldLanderTippedRight) {
            if (self.RADARY <= 17) {
                if (self.VERVEL <= -60) {
                    //GODEAD
                    [self.landerMessages addSystemMessage:@"DeadLanding"];
                    QUICK = YES;
                }
                else {
                    // Hit a crashed lander
                    [self.landerMessages addSystemMessage:@"HitCrashedLander"];
                    
                    // Adjust vertical position on rhe old lander
                    self.SHOWY += 4;
                    
                    // Turn off fuel, flames, and dust
                    [self landerDown];
                    
                    // Let's delay a bit before presenting the new game dialog
                    [self performSelector:@selector(prepareForNewGame) withObject:nil afterDelay:[self getDelay:DelayExplode]];
                }
            }
        }
        else if (tf == TF_Rock) {
            //AHROCK
            if (self.RADARY <= 15) {
                if (self.VERVEL <= -60) {
                    //GODEAD
                    [self.landerMessages addSystemMessage:@"DeadLanding"];
                    QUICK = YES;
                }
                else {
                    [self.landerMessages addSystemMessage:@"HitRock"];
                    [self EXPLOD];
                }
            }
        }
        else if (tf == TF_OldFlag) {
            if (self.RADARY <= 26) {
                if (self.THRUST) {
                    [self.moonView removeFeature:TF_OldFlag atIndex:self.INDEXL];
                    [self.landerMessages addSystemMessage:@"HitOldFlag"];
                }
            }
        }
        else if (tf == TF_McDonalds || tf == TF_McDonaldsEdge) {
            if (self.RADARY <= 30) {
                [self.moonView removeFeature:TF_McDonalds atIndex:self.INDEXL];
                [self.landerMessages addSystemMessage:@"HitMcdonalds"];
                QUICK = YES;
            }
        }
    }
    
    if (MAYBE) {
        // None is 0, left is < 0, right is > 0
        int TiltDirection = 0;
        
        // Check horizonatal velocity, roll angle, and terrain slope
        short horizvel = self.HORVEL;
        short angle = self.ANGLED;
        if (horizvel < -10 || horizvel > 10) {
            // Too much horizontal velocity - tipped
            [self.landerMessages addFlameMessage:@"FastSideways"];
            TiltDirection = horizvel;
        }
        else if (angle < -15 || angle > 15) {
            // Too much roll angle - tipped
            [self.landerMessages addFlameMessage:@"TippedOver"];
            TiltDirection = angle;
        }
        else {
            // Check terrain slope using difference between left and right terrain elevations
            short thl = (short)([self.moonView terrainHeight:self.INDEXL]);
            short thr = (short)([self.moonView terrainHeight:(self.INDEXL+1)]);
            short tdiff = thl - thr;
            if (tdiff < -48 || tdiff > 48) {
                // Terrain slope too great - tipped
                [self.landerMessages addFlameMessage:@"BumpyLanding"];
                TiltDirection = tdiff;
            }
            else {
                // Got it done, plant a flag or get a burger
                [self PALSY];
            }
        }
        
        // Tilt the ship if indicated
        if (TiltDirection != 0) {
            // We are down but tipped for some reason remove the lander
            self.landerView.hidden = YES;
            [self.landerModel landerDown];
            
            // Add the appropriate tipped lander to the feature database
            short index = self.INDEXL;
            if (TiltDirection < 0) {
                [self.moonView addFeature:TF_OldLanderTippedLeft atIndex:index];
            }
            else {
                [self.moonView addFeature:TF_OldLanderTippedRight atIndex:index];
            }
            
            // Let's delay a bit before presenting the new game dialog
            [self performSelector:@selector(prepareForNewGame) withObject:nil afterDelay:[self getDelay:DelayExplode]];
        }
    }
    
    if (QUICK) {
        // Deform the moon surface and explode
        [self ALTER:32];
        [self EXPLOD];
    }
}

- (void)landerModelTimerEvent
{
    // Update simulation time
#ifdef DEBUG_GRAB_EMPTY_SCREEN
    // Hide the lander and don't update the model
    self.landerView.hidden = YES;
#else
    [self.landerModel.delegate updateTime:LanderModelUpdateInterval];
#endif
   
}

- (void)gameLogicTimerEvent
{
    if (![self.landerModel onSurface]) {
        // Display a low fuel message
        if (self.FUEL <= 0) {
            [self.landerMessages removeFuelMessage];
        }
        else if (self.FUEL < 200) {
            if (!self.didFuelAlert) {
                // Only do this once
                self.didFuelAlert = YES;

                // Add low fuel message and ring bell
                [self.landerMessages addFuelMessage];
                [self beep];
            }
        }
        
        //(SHOWNT) Test for extreme game events that end the simulation
        self.BIGXCT = ((float)self.HORDIS + 22400.0) / 32.0;

        // Get the terrain information
        short tIndex = (short)self.BIGXCT;
        short thl = [self.moonView terrainHeight:tIndex];
        short thr = [self.moonView terrainHeight:tIndex+1];
        self.AVERY = (thl + thr) / 2;
        self.RADARY = self.VERDIS - self.AVERY;
        
        //(YSFLAM) Test for the edges
        if (self.BIGXCT < 10) {
            // Off the left edge
            [self OFFCOM:13 withMessage:@"LeftEdge"];
        }
        else if (self.BIGXCT > 890) {
            // Off the right edge
            [self OFFCOM:887 withMessage:@"RightEdge"];
        }
        else if (self.VERDIS > 25000) {
            // Off the top edge
            [self OFFCOM:self.SHOWX withMessage:@"TopEdge"];
        }
        
        // Switch views if we hit a critical altitude
        if (self.VERDIS < 450) {
            // Make sure the view is displayed (we might have drifted up)
            //(CLSEUP) Find our horizontal position in the closeup view
            if (![self.moonView viewIsDetailed]) {
                // Select the closeup view
                self.LEFTEDGE = (short)self.BIGXCT - 9;
                self.LEFEET = self.LEFTEDGE * 32 - 22400;
                [self.moonView useCloseUpView:self.LEFTEDGE];
            }

            //(CLSEC1) Check if we are at the left/right edge and need to redraw
            short xPos = self.HORDIS - self.LEFEET;
            if (xPos <= 30) {
                //(CLOL) Move the closeup view left
                self.LEFTEDGE = (short)self.BIGXCT - 17;
                self.LEFEET = self.LEFTEDGE * 32 - 22400;
                xPos = self.HORDIS - self.LEFEET;
                [self.moonView useCloseUpView:self.LEFTEDGE];
            }
            else if (xPos > 580) {
                // Move the closeup view right
                self.LEFTEDGE = (short)self.BIGXCT - 1;
                self.LEFEET = self.LEFTEDGE * 32 - 22400;
                xPos = self.HORDIS - self.LEFEET;
                [self.moonView useCloseUpView:self.LEFTEDGE];
            }
            
            //(CLSEOK)
            self.SHOWX = (xPos * 3.0) / 2.0;
            
            // Index to terrain/feature to left of lander
            self.INDEXL = self.LEFTEDGE + ((short)self.SHOWX / 48);
            self.INDEXLR = (short)self.SHOWX % 48;
            short IN1 = 48 - self.INDEXLR;
            
            // Get the terrain information
            short thl = (short)([self.moonView terrainHeight:self.INDEXL]);
            thl *= IN1;
            short thr = (short)([self.moonView terrainHeight:(self.INDEXL+1)]);
            thr *= self.INDEXLR;
            short th = thl + thr;
            if (th < 0) {
                th = -th;
                th = th / 48;
                th = -th;
            }
            
            //(CLSEF1)
            th = th / 48;
            
            //(CLSEF2)
            self.AVERY = th >> 2;
            self.AVERT = [self DFAKE:th];
            
            self.SHOWY = (((short)self.VERDIS * 3.0) / 2.0) + 23.0;
            short RET2 = self.SHOWY;
            self.SHOWY += 24.0;
            
            //(CLSEF3)
            RET2 -= self.AVERT;
            
            //(CLSEF4)
            self.RADARY = (RET2 * 2) / 3;
            [self INTEL];
            
            // Wait till 150 feet above surface before kicking up dust
            [self.dustView generateDust:self.landerType];

            // Redraw surface if changed
            [self.moonView useCloseUpView:self.LEFTEDGE];
        }
        else {
            if (![self.moonView viewIsNormal]) {
                // Make sure the view is displayed (we might have drifted up)
                [self.moonView useNormalView];
            }
            
            // Calculate the position with detail
            self.SHOWX = self.BIGXCT;
            self.SHOWY = (float)self.VERDIS / 32.0 + 43.0;
            
            // Test for contact with surface
            if ((self.RADARY - 16) < 0) {
                // Deform the moon surface and explode
                [self ALTER:640];
                [self EXPLOD];
            }
        }
    }
}

- (void)updateInstruments
{
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];
#ifdef DEBUG_EXTRA_INSTRUMENTS
    [self.instrument5 display];
    [self.instrument6 display];
    [self.instrument7 display];
    [self.instrument8 display];
#endif
}

- (void)updateLanderPosition
{
    // Move the lander
    const float LanderVerticalAdjust = -4;
    CGPoint landerPosition = CGPointMake(self.SHOWX, self.SHOWY + LanderVerticalAdjust);
    self.landerView.center = landerPosition;
}

@end
