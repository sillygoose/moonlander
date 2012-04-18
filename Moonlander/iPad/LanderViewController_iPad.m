//
//  LanderViewController.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderViewController_iPad.h"

#import "LanderMessage.h"


@interface LanderViewController_iPad ()
- (CGRect) convertRectFromGameToView:(CGRect)gameRect;
@end

@implementation LanderViewController_iPad

@synthesize landerModel=_landerModel;

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

@synthesize smallLeftArrow=_smallLeftArrow;
@synthesize smallRightArrow=_smallRightArrow;
@synthesize largeLeftArrow=_largeLeftArrow;
@synthesize largeRightArrow=_largeRightArrow;

@synthesize thrusterSlider=_thrusterSlider;

@synthesize selectedTelemetry=_selectedTelemetry;

@synthesize simulationTimer=_simulationTimer;
@synthesize displayTimer=_displayTimer;
@synthesize palsyTimer=_palsyTimer;

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


const float GameTimerInterval = 1.0 / 12.0f;
const float DisplayUpdateInterval = 0.05f;

#ifndef SHORT_DELAYS
// Timings for normal operation
const float SplashScreenInterval = 10.0f;
const float landingDelay = 4.0f;
const float moveInterval = 0.16f;
const float initialFoodDelay = 8.0f;
const float secondFoodDelay = 2.0f;
const float launchDelay = 2.0f;
const float endDelay = 3.0f;
const float newGameDelay = 3.0f;
const float flagFinalDelay = 10.0f;
const float explodeDelay = 5.0f;
const float offcomDelay = 5.0f;
#else
// sped up timings for debug
const float SplashScreenInterval = 2.0f;
const float landingDelay = 0.5f;
const float moveInterval = 0.03f;
const float initialFoodDelay = 1.0f;
const float secondFoodDelay = 0.5f;
const float launchDelay = 0.5f;
const float endDelay = 1.0f;
const float newGameDelay = 1.0f;
const float flagFinalDelay = 2.0f;
const float explodeDelay = 2.0f;
const float offcomDelay = 2.0f;
#endif


- (CGRect)convertRectFromGameToView:(CGRect)gameRect;
{
    CGRect viewRect = gameRect;
    //NSLog(@"gameRect:%@    viewFrame:%@", NSStringFromCGRect(gameRect), NSStringFromCGRect(self.view.frame));
    //NSLog(@"gameRect:%@    viewBounds:%@", NSStringFromCGRect(gameRect), NSStringFromCGRect(self.view.bounds));
    viewRect.origin.y = self.view.bounds.size.width - gameRect.origin.y - gameRect.size.height;
    //NSLog(@"gameRect:%@    viewRect:%@", NSStringFromCGRect(gameRect), NSStringFromCGRect(viewRect));
	return viewRect;
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

- (short)TIME
{
    return [self.landerModel.dataSource time];
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


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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

- (void)getStarted
{
    // Start with a normal view
    [self.moonView useNormalView];
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
    
    // Starting posiition
    self.SHOWX = 0;
    self.SHOWY = 0;
    self.didFuelAlert = NO;
    
    self.landerView.hidden = NO;
    
    // Enable all our flight controls
    [self enableFlightControls];
    
    // Setup controls with model defaults
    self.thrusterSlider.value = self.PERTRS;
    
    // Init displays
    self.instrument1.instrument = self.heightData;
    self.instrument2.instrument = self.distanceData;
    self.instrument3.instrument = self.verticalVelocityData;
    self.instrument4.instrument = self.horizontalVelocityData;
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];
    
#ifdef DEBUG
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
    
    // Setup game timers
	self.simulationTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimerInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
	self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:DisplayUpdateInterval target:self selector:@selector(updateLander) userInfo:nil repeats:YES];
    
    // Start off the display updates
    [self updateLander];
}

- (void)initGame
{
    // Splash screen
    [self.palsyTimer invalidate];
    self.palsyTimer = nil;
    
#ifdef NO_SPLASH_SCREEN
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(initGame2) userInfo:nil repeats:NO];
#else
    [self.landerMessages addSystemMessage:@"SplashScreen"];
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:SplashScreenInterval target:self selector:@selector(initGame2) userInfo:nil repeats:NO];
#endif
}

- (void)initGame2
{
    // Remove splash screen (if present)
    [self.palsyTimer invalidate];
    self.palsyTimer = nil;
    [self.landerMessages removeSystemMessage:@"SplashScreen"];
    
    // Unhide the views to get started after splash screen
    self.moonView.hidden = NO;
    self.landerMessages.hidden = NO;
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
    
    self.landerView.hidden = NO;

    [self getStarted];
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [super viewDidLoad];
    
    // We need to change the coordinate space to (0,0) in the lower left
    //### doesn't do anything! self.view.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);

    // Create the lander simulation model
    self.landerModel = [[LanderPhysicsModel alloc] init];
    self.landerModel.dataSource = self.landerModel;
    self.landerModel.delegate = self.landerModel;
    
    // Create the moon view
    //### use the frame bounds for this
    self.moonView = [[Moon alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(0, 0, 1024, 768)]];
    self.moonView.dataSource = self.moonView;
    self.moonView.userInteractionEnabled = NO;
    self.moonView.hidden = YES;
    [self.moonView useNormalView];
    [self.view addSubview:self.moonView];

    // Create the message manager
    self.landerMessages = [[LanderMessages alloc] init];
    self.landerMessages.hidden = NO;
    [self.view addSubview:self.landerMessages];
    
    // Create the roll control arrows
    const float RollButtonRepeatInterval = 0.25;
    const float SmallRollArrowWidth = 24;
    const float SmallRollArrowHeight = 12;
    NSString *slaPath = [[NSBundle mainBundle] pathForResource:@"SmallLeftArrow" ofType:@"plist"];
    self.smallLeftArrow = [[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(925, 375, SmallRollArrowWidth, SmallRollArrowHeight)]  withPaths:slaPath andRepeat:RollButtonRepeatInterval];
	[self.smallLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    self.smallLeftArrow.hidden = YES;
    self.smallLeftArrow.brighten = YES;
    [self.view addSubview:self.smallLeftArrow];
    
    NSString *sraPath = [[NSBundle mainBundle] pathForResource:@"SmallRightArrow" ofType:@"plist"];
    self.smallRightArrow = [[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(955, 375, SmallRollArrowWidth, SmallRollArrowHeight)] withPaths:sraPath andRepeat:RollButtonRepeatInterval];
	[self.smallRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    self.smallRightArrow.hidden = YES;
    self.smallRightArrow.brighten = YES;
    [self.view addSubview:self.smallRightArrow];
    
    const float LargeRollArrowWidth = 48;
    const float LargeRollArrowHeight = 24;
    NSString *llaPath = [[NSBundle mainBundle] pathForResource:@"LargeLeftArrow" ofType:@"plist"];
    self.largeLeftArrow = [[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(905, 330, LargeRollArrowWidth, LargeRollArrowHeight)] withPaths:llaPath andRepeat:RollButtonRepeatInterval];
	[self.largeLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    self.largeLeftArrow.hidden = YES;
    self.largeLeftArrow.brighten = YES;
    [self.view addSubview:self.largeLeftArrow];
    
    NSString *lraPath = [[NSBundle mainBundle] pathForResource:@"LargeRightArrow" ofType:@"plist"];
    self.largeRightArrow = [[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(955, 330, LargeRollArrowWidth, LargeRollArrowHeight)] withPaths:lraPath andRepeat:RollButtonRepeatInterval];
	[self.largeRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    self.largeRightArrow.hidden = YES;
    self.largeRightArrow.brighten = YES;
    [self.view addSubview:self.largeRightArrow];
    
    // Create the thruster control
    const float ThrusterSliderWidth = 200;
    const float ThrusterSliderHeight = 200;
    self.thrusterSlider = [[VGSlider alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(820, 450, ThrusterSliderWidth, ThrusterSliderHeight)]];
	[self.thrusterSlider addTarget:self 
                            action:@selector(thrusterChanged:) 
                  forControlEvents:UIControlEventValueChanged];
    self.thrusterSlider.hidden = YES;
    [self.view addSubview:self.thrusterSlider];
    
    // Create the telemetry items
	const short TelemetryXPos = 930;
    const short TelemetryXSize = 100;
    const short TelemetryYSize = 20;
    self.heightData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 247, TelemetryXSize, TelemetryYSize)]];
    self.heightData.titleLabel.text = @"HEIGHT";
    self.heightData.format = @"%6d %@";
    self.heightData.data = [^{ return self.RADARY;} copy];
	[self.heightData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    self.heightData.hidden = YES;
    [self.view addSubview:self.heightData];
    
    self.altitudeData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 225, TelemetryXSize, TelemetryYSize)]];
    self.altitudeData.titleLabel.text = @"ALTITUDE";
    self.altitudeData.format = @"%6d %@";
    self.altitudeData.data = [^{ return self.VERDIS;} copy];
	[self.altitudeData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    self.altitudeData.hidden = YES;
    [self.view addSubview:self.altitudeData];
    
    self.distanceData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 203, TelemetryXSize, TelemetryYSize)]];
    self.distanceData.titleLabel.text = @"DISTANCE";
    self.distanceData.format = @"%6d %@";
    self.distanceData.data = [^{ return self.HORDIS;} copy];
	[self.distanceData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    self.distanceData.hidden = YES;
    [self.view addSubview:self.distanceData];
    

    self.fuelLeftData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 181, TelemetryXSize, TelemetryYSize)]];
    self.fuelLeftData.titleLabel.text = @"FUEL LEFT";
    self.fuelLeftData.format = @"%6d %@";
    self.fuelLeftData.data = [^{ return self.FUEL;} copy];
	[self.fuelLeftData addTarget:self 
                         action:@selector(telemetrySelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.fuelLeftData.hidden = YES;
    [self.view addSubview:self.fuelLeftData];
    
    self.weightData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 159, TelemetryXSize, TelemetryYSize)]];
    self.weightData.titleLabel.text = @"WEIGHT";
    self.weightData.format = @"%6d %@";
    self.weightData.data = [^{ return self.WEIGHT;} copy];
	[self.weightData addTarget:self 
                                   action:@selector(telemetrySelected:) 
                         forControlEvents:UIControlEventTouchUpInside];
    self.weightData.hidden = YES;
    [self.view addSubview:self.weightData];

    self.thrustData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 137, TelemetryXSize, TelemetryYSize)]];
    self.thrustData.titleLabel.text = @"THRUST";
    self.thrustData.format = @"%6d %@";
    self.thrustData.data = [^{ return self.THRUST;} copy];
	[self.thrustData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.thrustData.hidden = YES;
    [self.view addSubview:self.thrustData];
    
    self.thrustAngleData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 115, TelemetryXSize, TelemetryYSize)]];
    self.thrustAngleData.titleLabel.text = @"ANGLE";
    self.thrustAngleData.format = @"%6d %@";
    self.thrustAngleData.data = [^{ return self.ANGLED;} copy];
	[self.thrustAngleData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.thrustAngleData.hidden = YES;
    [self.view addSubview:self.thrustAngleData];
    
    self.verticalVelocityData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 93, TelemetryXSize, TelemetryYSize)]];
    self.verticalVelocityData.titleLabel.text = @"VER VEL";
    self.verticalVelocityData.format = @"%6d %@";
    self.verticalVelocityData.data = [^{ return self.VERVEL;} copy];
	[self.verticalVelocityData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.verticalVelocityData.hidden = YES;
    [self.view addSubview:self.verticalVelocityData];
    
    self.horizontalVelocityData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 71, TelemetryXSize, TelemetryYSize)]];
    self.horizontalVelocityData.titleLabel.text = @"HOR VEL";
    self.horizontalVelocityData.format = @"%6d %@";
    self.horizontalVelocityData.data = [^{ return self.HORVEL;} copy];
	[self.horizontalVelocityData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.horizontalVelocityData.hidden = YES;
    [self.view addSubview:self.horizontalVelocityData];
    
    self.verticalAccelerationData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 49, TelemetryXSize, TelemetryYSize)]];
    self.verticalAccelerationData.titleLabel.text = @"VER ACC";
    self.verticalAccelerationData.format = @"%6d %@";
    self.verticalAccelerationData.data = [^{ return self.VERACC;} copy];
	[self.verticalAccelerationData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.verticalAccelerationData.hidden = YES;
    [self.view addSubview:self.verticalAccelerationData];
    
    self.horizontalAccelerationData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 27, TelemetryXSize, TelemetryYSize)]];
    self.horizontalAccelerationData.titleLabel.text = @"HOR ACC";
    self.horizontalAccelerationData.format = @"%6d %@";
    self.horizontalAccelerationData.data = [^{ return self.HORACC;} copy];
	[self.horizontalAccelerationData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.horizontalAccelerationData.hidden = YES;
    [self.view addSubview:self.horizontalAccelerationData];
    
    self.secondsData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(TelemetryXPos, 5, TelemetryXSize, TelemetryYSize)]];
    self.secondsData.titleLabel.text = @"SECONDS";
    self.secondsData.format = @"%6d %@";
    self.secondsData.data =[^{ return self.TIME;} copy];
	[self.secondsData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.secondsData.hidden = YES;
    [self.view addSubview:self.secondsData];
 
    // Create the instrumentation labels
    const float InstrumentSizeWidth = 200;
    const float InstrumentSizeHeight = 24;
    const float InstrumentYCoordinate = 20;
    const float InstrumentYCoordinate2 = InstrumentYCoordinate + InstrumentSizeHeight;
    self.instrument1 = [[Instrument alloc] initWithFrame:CGRectMake(0, InstrumentYCoordinate, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument1.instrument = self.heightData;
	[self.instrument1 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument1];
    
    self.instrument2 = [[Instrument alloc] initWithFrame:CGRectMake(250, InstrumentYCoordinate, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument2.instrument = self.distanceData;
	[self.instrument2 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument2];
    
    self.instrument3 = [[Instrument alloc] initWithFrame:CGRectMake(500, InstrumentYCoordinate, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument3.instrument = self.verticalVelocityData;
	[self.instrument3 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument3];
    
    self.instrument4 = [[Instrument alloc] initWithFrame:CGRectMake(750, InstrumentYCoordinate, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument4.instrument = self.horizontalVelocityData;
	[self.instrument4 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument4];

    self.instrument5 = [[Instrument alloc] initWithFrame:CGRectMake(0, InstrumentYCoordinate2, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument5.instrument = self.altitudeData;
	[self.instrument5 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument5.hidden = YES;
    [self.view addSubview:self.instrument5];
    
    self.instrument6 = [[Instrument alloc] initWithFrame:CGRectMake(250, InstrumentYCoordinate2, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument6.instrument = self.fuelLeftData;
	[self.instrument6 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument6.hidden = YES;
    [self.view addSubview:self.instrument6];
    
    self.instrument7 = [[Instrument alloc] initWithFrame:CGRectMake(500, InstrumentYCoordinate2, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument7.instrument = self.thrustAngleData;
	[self.instrument7 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument7.hidden = YES;
    [self.view addSubview:self.instrument7];
    
    self.instrument8 = [[Instrument alloc] initWithFrame:CGRectMake(750, InstrumentYCoordinate2, InstrumentSizeWidth, InstrumentSizeHeight)];
    self.instrument8.instrument = self.secondsData;
	[self.instrument8 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument8.hidden = YES;
    [self.view addSubview:self.instrument8];
    
    // Create the lander view with data sources
    self.landerView = [[Lander alloc] init];
    self.landerView.userInteractionEnabled = NO;
    self.landerView.contentMode = UIViewContentModeRedraw;
    self.landerView.thrustPercent = [^{ return self.PERTRS;} copy];
    self.landerView.thrustData = [^{ return self.THRUST;} copy];
    self.landerView.angleData = [^{ return self.ANGLE;} copy];
    self.landerView.hidden = YES;
    [self.view addSubview:self.landerView];
    
    // Start the game
    [self initGame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Kill any active timers
    [self.simulationTimer invalidate];
    self.simulationTimer = nil;
    [self.displayTimer invalidate];
    self.displayTimer = nil;
    [self.palsyTimer invalidate];
    self.palsyTimer = nil;
    
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
    
    self.smallLeftArrow = nil;
    self.smallRightArrow = nil;
    self.largeLeftArrow = nil;
    self.largeRightArrow = nil;
    
    self.thrusterSlider = nil;
    
    self.landerView = nil;
    self.dustView = nil;
    self.manView = nil;
    self.flagView = nil;
    
    self.landerMessages = nil;
    self.anotherGameDialog = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
    
    short deltaAngle = 0;
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
    
    // Update the model with the change in roll angle
    self.ANGLED += deltaAngle;
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
    [self.landerView updateLander];
    
    // Update the displayed instruments
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];
    
#ifdef DEBUG
    [self.instrument5 display];
    [self.instrument6 display];
    [self.instrument7 display];
    [self.instrument8 display];
#endif
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

    // Remove dust view
    if (self.dustView) {
        self.dustView.drawPaths = nil;
        [self.dustView removeFromSuperview];
        self.dustView = nil;
    }
    
    // Final lander view update
    [self updateLander];
}

- (void)DUST
{
    // Some dust generation constants
    const short DustStartHeight = 150;
    const short MaxDisplayDust = 241;
    const float DustViewWidth = 128;
    const float DustViewHeight = 64;
    const short MaxDustThrust = 63;
    
    // Assume we will remove the dust view
    BOOL removeDustView = YES;

    // Wait till 150 feet above surface before kicking up dust
    if (self.RADARY < DustStartHeight) {
        // Angle must be reasonable as well
        if (self.ANGLED >= -45 && self.ANGLED <= 45) {
            //(DUSTB1)  Magnitude of dust determines intensity level
            short requestedThrust = self.PERTRS;
            short percentThrust = (requestedThrust > MaxDustThrust) ? MaxDustThrust : requestedThrust;
            short dustIntensity = (percentThrust >> 3) & 0x7;
            
            //(DUSTP1)  Thrust angle determines dust direction
            float angle = self.ANGLE;
            float cosAngle = cos(angle);
            float sinAngle = sin(angle);

            short deltaY = self.SHOWY - self.AVERT;
            float sinDeltaY = deltaY * sinAngle;
            float tanDeltaY = sinDeltaY / cosAngle;
            short flameDistance = tanDeltaY + deltaY;
            tanDeltaY = -tanDeltaY;
            
            //(DUSTP2)  Center the dust in the view
            //### This is a hack - fixme!
            short xCenterPos = self.SHOWX + tanDeltaY;
            short yCenterPos = 768 - self.AVERT;
            xCenterPos -= DustViewWidth / 2;
            yCenterPos -= DustViewHeight;
            
            // Calculate the flame distance and number of points to draw
            flameDistance -= DustStartHeight;
            if (flameDistance < 0) {
                // Convert to a positive distance (NEG)
                flameDistance = -flameDistance;
                
                // Calculate the number of dust points to draw
                short count = MIN(((flameDistance * requestedThrust) >> 4), MaxDisplayDust);
                if (count) {
                    // Keep the dust view as we have something to draw
                    removeDustView = NO;
                    
                    // Allocate our path array
                    NSMutableArray *path = [[NSMutableArray alloc] init];
                    NSArray *paths = [NSArray arrayWithObject:path];
                    
                    // Prep the intensity and line type info
                    NSNumber *intensity = [NSNumber numberWithInt:dustIntensity];
                    
                    // Look up table used in dust generation
                    const short YThrust[] = { 0, -30, -31, -32, -34, -36, -38, -41, -44, -47, -50, -53, -56, 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1, -20, -16, -13, -10, -7, -4, -2, 0, 2, 4, 7, 10, 13, 16, 20, 0, -30, -31 };
                    const short DimYThrust = sizeof(YThrust)/sizeof(YThrust[0]);
                    assert(DimYThrust == 63);
                    
                    //(DUSTWF)
                    //(DUSTL)
                    while (count--) {
                        // Generate a random value to index the thrust vector array
                        short RET1 = (short)random();
                        RET1 &= DimYThrust;
                        
                        // X coordinate calculation
                        short xPos = YThrust[RET1];
                        RET1 += (short)random();
                        RET1 &= DimYThrust;
                        xPos &= DimYThrust;
                        
                        // Toggle the direction bit for X (COM)
                        flameDistance = ~flameDistance;
                        if (flameDistance < 0) {
                            xPos = -xPos;
                        }
                        
                        // Adjust X to the dust view frame
                        xPos += DustViewHeight - 1;
                        
                        // Now generate the Y value (always positive)
                        short yPos = YThrust[RET1];
                        yPos &= DimYThrust;
                        
                        // Create the point command and add to the draw list
                        NSNumber *x = [NSNumber numberWithFloat:xPos];
                        NSNumber *y = [NSNumber numberWithFloat:yPos];
                        
                        // Default size for a rectangle is 1 x 1
                        NSDictionary *originItem = [NSDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil];
                        NSDictionary *rectItem = [NSDictionary dictionaryWithObjectsAndKeys:originItem, @"origin", nil];
                        NSDictionary *pathItem = [NSDictionary dictionaryWithObjectsAndKeys:rectItem, @"rect", intensity, @"intensity", nil];
                        [path addObject:pathItem];
                    }
                    
                    // Create the view if needed
                    if (!self.dustView) {
                        CGRect frameRect = CGRectMake(xCenterPos, yCenterPos, DustViewWidth, DustViewHeight);
                        self.dustView = [[Dust alloc] initWithFrame:frameRect];
                        [self.view addSubview:self.dustView];
                    }
                    else if (self.dustView.frame.origin.x != xCenterPos || self.dustView.frame.origin.y != yCenterPos) {
                        // Remove old dust view and create a new one
                        [self.dustView removeFromSuperview];
                        CGRect frameRect = CGRectMake(xCenterPos, yCenterPos, DustViewWidth, DustViewHeight);
                        self.dustView = [[Dust alloc] initWithFrame:frameRect];
                        [self.view addSubview:self.dustView];
                    }
                    
                    // Add the draw paths and update the display
                    self.dustView.drawPaths = paths;
                    [self.dustView setNeedsDisplay];
                }
            }
        }
    }
    
    // Remove the dust view if nothing was drawn
    if (removeDustView == YES) {
        if (self.dustView) {
            self.dustView.drawPaths = nil;
            [self.dustView removeFromSuperview];
            self.dustView = nil;
        }
    }
}

- (void)startGameDelay
{
    // Kill the timer and start the new game
    if (self.palsyTimer) {
        [self.palsyTimer invalidate];
        self.palsyTimer = nil;
    }
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
        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:newGameDelay target:self selector:@selector(startGameDelay) userInfo:nil repeats:NO];
    }
    else {
        // Return to the main menu
        // Filled by UI code
    }
}

- (void)waitNewGame
{
    // Remove any messages that might be left over
    [self.landerMessages removeAllLanderMessages];
    
    // Kill the timers that might be running
    [self.palsyTimer invalidate];
    self.palsyTimer = nil;
    [self.simulationTimer invalidate];
    self.simulationTimer = nil;
    [self.displayTimer invalidate];
    self.displayTimer = nil;
    
    // Setup our dialog for a new game
    CGRect dialogRect = CGRectMake(450, 300, 200, 100);
    self.anotherGameDialog = [[VGDialog alloc] initWithFrame:dialogRect addTarget:self onSelection:@selector(getYesNo)];
    [self.view addSubview:self.anotherGameDialog];
}

- (void)prepareForNewGame
{
    [self performSelector:@selector(waitNewGame) withObject:nil afterDelay:newGameDelay];
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

        // Kill the timers, we are done
        [self.palsyTimer invalidate];
        self.palsyTimer = nil;
        [self.simulationTimer invalidate];
        self.simulationTimer = nil;
        [self.displayTimer invalidate];
        self.displayTimer = nil;

        // Wait a bit before continuing
        [self performSelector:@selector(prepareForNewGame) withObject:nil afterDelay:endDelay];
    }
}

- (void)prepareForLiftoff
{
    // Remove the man view
    [self.manView removeFromSuperview];
    self.manView = nil;
    
    // No more messages at this point
    [self.landerMessages removeAllLanderMessages];

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
    [self performSelector:@selector(landerLiftoff) withObject:nil afterDelay:DisplayUpdateInterval];
}

- (void)waitFlagMan
{
    // Kill the timers - we are done
    [self.displayTimer invalidate];
    self.displayTimer = nil;
    [self.simulationTimer invalidate];
    self.simulationTimer = nil;
    
    // Don't need the man anymore
    [self.manView removeFromSuperview];
    self.manView = nil;
    
    // Remove messages and add the lander to the terrain data
    [self.landerMessages removeAllLanderMessages];
    [self.moonView addFeature:TF_OldLander atIndex:self.INDEXL];

    // Let's delay a bit before presenting the new game dialog
    [self performSelector:@selector(waitNewGame) withObject:nil afterDelay:newGameDelay];
}

- (void)moveMan
{
    const short ManCenterX = 8;
    const short ManCenterY = 18;
    const short ManHeightOffFloor = 4;
    const UIViewAnimationOptions animateOptions = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    
    if (self.moonView.displayHasMcDonalds) {
        // Put the man in position to head for lunch
        CGPoint start = CGPointMake(self.SHOWX - ManCenterX, self.view.frame.size.width - self.SHOWY - ManCenterY);//###
        self.manView = [[Man alloc] initWithOrigin:start];
        CGPoint manViewCenter = self.manView.center;
        [self.view addSubview:self.manView];
        
        // Select a direction at random
        const float McDonaldsStartDownDuration = 1.5;
        const float McDonaldsOverDuration = 3;
        const float McDonaldsBackDuration = 3;
        const float McDonaldsUpDuration = 1.5;

        // Move the man out of the lander to the ground
        __block CGPoint destination = CGPointMake(self.moonView.MACX, self.view.frame.size.width - self.moonView.MACY - ManHeightOffFloor);
        __block short direction = (destination.x < start.x) ? -1 : 1;
        __block short deltaX;
        __block short deltaY;
        __block CGPoint delta;

        // Blocks used in the flag plant animation
        void (^moveMan)(void) = ^{
            self.manView.center = delta;
        };
        void (^moveComplete)(BOOL) = ^(BOOL f) {
            [self performSelector:@selector(prepareForLiftoff) withObject:nil afterDelay:launchDelay];
        };
        void (^moveManUp)(BOOL) = ^(BOOL f) {
            // Complete the move up into the lander
            delta.x = manViewCenter.x;
            delta.y = manViewCenter.y;
            [Man animateWithDuration:McDonaldsUpDuration delay:0 options:animateOptions animations:moveMan completion:moveComplete];
        };
        void (^moveManBack)(BOOL) = ^(BOOL f) {
            // Remove our message and head back to the lander
            [self.landerMessages removeSystemMessage:@"YourOrder"];
            
            // Complete the move back to the lander
            delta.x = manViewCenter.x + 48 * direction;
            delta.y = destination.y;
            [Man animateWithDuration:McDonaldsBackDuration delay:0 options:animateOptions animations:moveMan completion:moveManUp];
        };
        void (^getLunch)(BOOL) = ^(BOOL f) {
            // Order some food and wait
            [self.landerMessages addSystemMessage:@"YourOrder"];
            
            // We are moving back after a delay
            delta.x = destination.x + 1 * direction;
            delta.y = destination.y;
            [Man animateWithDuration:McDonaldsOverDuration delay:initialFoodDelay options:animateOptions animations:moveMan completion:moveManBack];
        };
        void (^moveManOver)(BOOL) = ^(BOOL f) {
            // Get our current position
            delta = destination;
            [Man animateWithDuration:McDonaldsOverDuration delay:0.0 options:animateOptions animations:moveMan completion:getLunch];
        };
        
        // First move down to the base of the lander and out to plant a flag
        deltaX = start.x + 48 * direction;
        deltaY = destination.y;
        delta = CGPointMake(deltaX, deltaY);
        [Man animateWithDuration:McDonaldsStartDownDuration delay:0.0 options:animateOptions animations:moveMan completion:moveManOver];
    }
    else {
        // Put the man in position, random decision on direction
        CGPoint start = CGPointMake(self.SHOWX - ManCenterX, self.view.frame.size.width - self.SHOWY - ManCenterY);//###
        self.manView = [[Man alloc] initWithOrigin:start];
        [self.view addSubview:self.manView];
        
        // Select a direction at random
        short direction = (random() % 2) ? 1 : -1;
        const float FlagAnimationDuration = 2.5;
        
        // Move the man out of the lander to the ground
        __block float deltaX;
        __block float deltaY;
        __block CGPoint delta;
        
        // Blocks used in the flag plant animation
        void (^moveMan)(void) = ^{ self.manView.center = delta; };
        void (^plantFlag)(BOOL) = ^(BOOL f) {
            // Plant the flag
            short flagX = self.manView.center.x + 24 * direction;
            CGPoint origin = CGPointMake(flagX, self.manView.center.y);
            self.flagView = [[Flag alloc] initWithOrigin:origin];
            [self.view addSubview:self.flagView];
            
            // Add the flag  to the terrain and display our message
            short flagIndex = self.INDEXL + 2 * direction;
            [self.moonView addFeature:TF_OldFlag atIndex:flagIndex];
            [self.landerMessages addSystemMessage:@"OneSmallStep"];
            
            // Delay a bit before finishing the game
            [self performSelector:@selector(waitFlagMan) withObject:nil afterDelay:flagFinalDelay];
        };
        void (^moveComplete)(BOOL) = ^(BOOL f) {
            delta = self.manView.center;
            deltaX = direction * 48;
            deltaY = 0;
            delta.x += deltaX;
            delta.y += deltaY;
            [Man animateWithDuration:FlagAnimationDuration delay:0.0 options:animateOptions animations:moveMan completion:plantFlag];
        };
        
        // First move down to the base of the lander and out to plant a flag
        deltaX = direction * 48;
        deltaY = 48;
        delta = CGPointMake(start.x + deltaX, start.y + deltaY - ManHeightOffFloor);
        [Man animateWithDuration:FlagAnimationDuration delay:0.0 options:animateOptions animations:moveMan completion:moveComplete];
    }
}

- (void)PALSY
{
    // Start with a delay of 4 seconds
    [self performSelector:@selector(moveMan) withObject:nil afterDelay:landingDelay];
}

- (void)BELL
{
    const int BeepSound = 1052;
    AudioServicesPlayAlertSound(BeepSound);
}

- (void)explosionComplete
{
    if (self.explosionManager.explosionComplete) {
        // Kill the timer er have been using
        [self.palsyTimer invalidate];
        self.palsyTimer = nil;
        
        // Start the delay timer
        [self performSelector:@selector(waitNewGame) withObject:nil afterDelay:explodeDelay];
    }
}

- (void)EXPLOD
{
    // We are down hard, hide and lander and shut down the model
    self.landerView.hidden = YES;

    // Turn off fuel, flames, and dust
    [self landerDown];

    //(EXPLOD)  Shut down things and ring bell
    [self BELL];

    //(EXPLD1)  Setup the explosion animation manager
    float xPos = self.SHOWX;
    float yPos = self.SHOWY;
    self.explosionManager = [[ExplosionManager alloc] initWithView:self.view atPoint:CGPointMake(xPos, yPos)];
    
    // Use a timer to test for completion
    const float AnimateExplosionTimer = 0.25f;
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:AnimateExplosionTimer target:self selector:@selector(explosionComplete) userInfo:nil repeats:YES];
}

- (void)ALTER:(short)alterValue
{
    [self.moonView alterMoon:alterValue atIndex:self.BIGXCT];
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
                    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:explodeDelay target:self selector:@selector(waitNewGame) userInfo:nil repeats:NO];
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
                    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:explodeDelay target:self selector:@selector(waitNewGame) userInfo:nil repeats:NO];
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
            short thl = (short)([self.moonView.dataSource terrainHeight:self.INDEXL]);
            short thr = (short)([self.moonView.dataSource terrainHeight:(self.INDEXL+1)]);
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
            self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:explodeDelay target:self selector:@selector(waitNewGame) userInfo:nil repeats:NO];
        }
    }
    
    if (QUICK) {
        // Deform the moon surface and explode
        [self ALTER:32];
        [self EXPLOD];
    }
}

- (void)gameLoop
{
    // Update simulation time
    [self.landerModel.delegate updateTime:GameTimerInterval];

    if (![self.landerModel onSurface]) {
        // Display a low fuel message
        if (self.FUEL <= 0) {
            [self.landerMessages removeFuelMessage];
        }
        else if (self.FUEL < 200) {
            if (!self.didFuelAlert) {
                // Only do this once
                self.didFuelAlert = YES;

                // Add message and ring bell
                [self.landerMessages addFuelMessage];
                [self BELL];
            }
        }
        
        //(SHOWNT) Test for extreme game events that end the simulation
        self.BIGXCT = (self.HORDIS + 22400) / 32;

        // Get the terrain information
        short tIndex = self.BIGXCT;
        short thl = [self.moonView.dataSource terrainHeight:tIndex];
        short thr = [self.moonView.dataSource terrainHeight:tIndex+1];
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
            //(CLSEUP) Find our horizontal position in the closeup view
            if (![self.moonView viewIsDetailed]) {
                // Select the closeup view
                self.LEFTEDGE = self.BIGXCT - 9;
                self.LEFEET = self.LEFTEDGE * 32 - 22400;
                [self.moonView useCloseUpView:self.LEFTEDGE];
            }

            //(CLSEC1) Check if we are at the left/right edge and need to redraw
            short xPos = self.HORDIS - self.LEFEET;
            if (xPos <= 30) {
                //(CLOL) Move the closeup view left
                self.LEFTEDGE = self.BIGXCT - 17;
                self.LEFEET = self.LEFTEDGE * 32 - 22400;
                xPos = self.HORDIS - self.LEFEET;
                [self.moonView useCloseUpView:self.LEFTEDGE];
            }
            else if (xPos > 580) {
                // Move the closeup view right
                self.LEFTEDGE = self.BIGXCT - 1;
                self.LEFEET = self.LEFTEDGE * 32 - 22400;
                xPos = self.HORDIS - self.LEFEET;
                [self.moonView useCloseUpView:self.LEFTEDGE];
            }
            
            //(CLSEOK)
            self.SHOWX = (xPos * 3) / 2;
            
            // Index to terrain/feature to left of lander
            self.INDEXL = self.LEFTEDGE + (self.SHOWX / 48);
            self.INDEXLR = self.SHOWX % 48;
            short IN1 = 48 - self.INDEXLR;
            
            // Get the terrain information
            short thl = (short)([self.moonView.dataSource terrainHeight:self.INDEXL]);
            thl *= IN1;
            short thr = (short)([self.moonView.dataSource terrainHeight:(self.INDEXL+1)]);
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
            
            short RET2 = ((self.VERDIS * 3) / 2) + 23;
            self.SHOWY = RET2;
            self.SHOWY += 24;
            
            //(CLSEF3)
            RET2 -= self.AVERT;
            
            //(CLSEF4)
            self.RADARY = (RET2 * 2) / 3;
            [self INTEL];
            [self DUST];

            // Redraw surface if changed
            [self.moonView useCloseUpView:self.LEFTEDGE];

            // Move the lander
            CGPoint newFrame = self.landerView.center;
            newFrame.x = self.SHOWX;
            //### use of width for height is troublesome
            newFrame.y = self.view.frame.size.width - self.SHOWY + 4;
            self.landerView.center = newFrame;
        }
        else {
            // Make sure the view is displayed (we might have drifted up)
            [self.moonView useNormalView];
            
            // Move the lander
            self.SHOWX = self.BIGXCT;
            self.SHOWY = self.VERDIS / 32 + 43;
            CGPoint newFrame = self.landerView.center;
            newFrame.x = self.SHOWX;
            newFrame.y = self.view.frame.size.width - self.SHOWY;//###
            self.landerView.center = newFrame;
            
            // Test for contact with surface
            if ((self.RADARY - 16) < 0) {
                // Deform the moon surface and explode
                [self ALTER:640];
                [self EXPLOD];
            }
        }
    }
}

@end
