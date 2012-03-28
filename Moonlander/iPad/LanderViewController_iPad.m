//
//  LanderViewController.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderViewController_iPad.h"

#import "LanderMessage.h"

const int BeepSound = 1052;


@interface LanderViewController_iPad ()
- (CGPoint) convertPointFromGameToView:(CGPoint)gamePoint;
- (CGPoint) convertPointFromViewToGame:(CGPoint)viewPoint;
- (CGSize) convertSizeFromGameToView:(CGSize)gameSize;
- (CGSize) convertSizeFromViewToGame:(CGSize)viewSize;
- (CGRect) convertRectFromGameToView:(CGRect)gameRect;
- (CGRect) convertRectFromViewToGame:(CGRect)viewRect;
@end

@implementation LanderViewController_iPad

@synthesize landerModel=_landerModel;

@synthesize moonView=_moonView;
@synthesize landerView=_landerView;
@synthesize dustView=_dustView;
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

#if 0
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



//### marked for deletion
- (CGPoint)convertPointFromGameToView:(CGPoint)gamePoint
{
    CGPoint viewPoint = CGPointZero;
    viewPoint.x = gamePoint.x * self.view.bounds.size.width;
	viewPoint.y = gamePoint.y * self.view.bounds.size.height;
	return viewPoint;
}

- (CGPoint)convertPointFromViewToGame:(CGPoint)viewPoint;
{
    CGPoint gamePoint = CGPointZero;
    gamePoint.x = viewPoint.x / self.view.bounds.size.width;
	gamePoint.y = viewPoint.y / self.view.bounds.size.height;
	return gamePoint;
}

- (CGSize)convertSizeFromGameToView:(CGSize)gameSize;
{
    CGSize viewSize = CGSizeZero;
    viewSize.width = gameSize.width * self.view.bounds.size.width;
	viewSize.height = gameSize.height * self.view.bounds.size.height;
	return viewSize;
}

- (CGSize)convertSizeFromViewToGame:(CGSize)viewSize;
{
    CGSize gameSize = CGSizeZero;
    gameSize.width = viewSize.width * self.view.bounds.size.width;
	gameSize.height = viewSize.height * self.view.bounds.size.height;
	return gameSize;
}

- (CGRect)convertRectFromGameToView:(CGRect)gameRect;
{
    CGRect viewRect = gameRect;
    //NSLog(@"gameRect:%@    viewFrame:%@", NSStringFromCGRect(gameRect), NSStringFromCGRect(self.view.frame));
    //NSLog(@"gameRect:%@    viewBounds:%@", NSStringFromCGRect(gameRect), NSStringFromCGRect(self.view.bounds));
    viewRect.origin.y = self.view.bounds.size.width - gameRect.origin.y - gameRect.size.height;
    //NSLog(@"gameRect:%@    viewRect:%@", NSStringFromCGRect(gameRect), NSStringFromCGRect(viewRect));
	return viewRect;
}

- (CGRect)convertRectFromViewToGame:(CGRect)viewRect;
{
    CGRect gameRect = CGRectZero;
    viewRect.origin.y = self.view.bounds.size.height - viewRect.origin.y;
	return gameRect;
}
//### marked for deletion

- (short)VERDIS
{
    return (short)([self.landerModel.dataSource altitude]);
}

- (void)setVERDIS:(short)value
{
    [self.landerModel.dataSource setAltitude:value];
}

- (short)HORDIS
{
    return (short)([self.landerModel.dataSource distance]);
}

- (short)PERTRS
{
    return (short)([self.landerModel.dataSource thrustPercent]);
}

- (short)ANGLE
{
    return (short)([self.landerModel.dataSource angle]);
}

- (void)setANGLE:(short)value
{
    [self.landerModel.dataSource setAngle:value];
}

- (short)ANGLED
{
    return (short)([self.landerModel.dataSource angleDegrees]);
}

- (short)HORVEL
{
    return (short)([self.landerModel.dataSource horizVel]);
}

- (void)setHORVEL:(short)value
{
    [self.landerModel.dataSource setHorizVel:value];
}

- (short)VERVEL
{
    return (short)([self.landerModel.dataSource vertVel]);
}

- (void)setVERVEL:(short)value
{
    [self.landerModel.dataSource setVertVel:value];
}

- (short)VERACC
{
    return (short)([self.landerModel.dataSource vertAccel]*10);
}

- (short)THRUST
{
    return (short)([self.landerModel.dataSource thrust]);
}

- (void)setTHRUST:(short)value
{
    [self.landerModel.dataSource setThrust:value];
}

- (short)TIME
{
    return (short)([self.landerModel.dataSource time]*60.0f);
}

- (short)FUEL
{
    return (short)([self.landerModel.dataSource fuel]);
}

- (void)setFUEL:(short)value
{
    [self.landerModel.dataSource setFuel:value];
}

- (void)dealloc
{
    [_landerModel release];
    
    [_moonView release];
    [_landerView release];
    [_dustView release];
    [_manView release];
    [_flagView release];
    
    [_smallLeftArrow release];
    [_smallRightArrow release];
    [_largeLeftArrow release];
    [_largeRightArrow release];
    
    [_thrusterSlider release];
    
    [_simulationTimer release];
    [_displayTimer release];
    
    [_selectedTelemetry release];
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
    
    [_instrument1 release];
    [_instrument2 release];
    [_instrument3 release];
    [_instrument4 release];
    
    [_instrument5 release];
    [_instrument6 release];
    [_instrument7 release];
    [_instrument8 release];
    
    [_landerMessages release];
    
    [_anotherGameDialog release];
    
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
    
#if 0
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
#endif
}

- (void)enableFlightControls
{
    self.smallLeftArrow.enabled = YES;
    self.smallRightArrow.enabled = YES;
    self.largeLeftArrow.enabled = YES;
    self.largeRightArrow.enabled = YES;
    
    self.thrusterSlider.enabled = YES;
    
#if 0
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
#endif
}

- (void)disableRollThrusters
{
    self.thrusterSlider.enabled = NO;
    self.smallLeftArrow.enabled = NO;
    self.smallRightArrow.enabled = NO;
    self.largeLeftArrow.enabled = NO;
    self.largeRightArrow.enabled = NO;
}

- (void)askNewGame
{
    
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
    
    [self enableFlightControls];
    
    // Setup controls with model defaults
    self.thrusterSlider.value = [self.landerModel.dataSource thrustPercent];
    
    // Init displays
    self.instrument1.instrument = self.heightData;
    self.instrument2.instrument = self.distanceData;
    self.instrument3.instrument = self.verticalVelocityData;
    self.instrument4.instrument = self.horizontalVelocityData;
    //self.instrument5.instrument = self.altitudeData;
    //self.instrument6.instrument = self.fuelLeftData;
    //self.instrument7.instrument = self.thrustAngleData;
    //self.instrument8.instrument = self.secondsData;
    
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];
    
#if 0
    // These are hidden normally
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
    
    [self.landerMessages addSystemMessage:@"SplashScreen"];
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:SplashScreenInterval target:self selector:@selector(initGame2) userInfo:nil repeats:NO];
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
//###    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [super viewDidLoad];
    
    // We need to change the coordinate space to (0,0) in the lower left
    self.view.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);

    // Create the lander simulation model
    self.landerModel = [[[LanderPhysicsModel alloc] init] autorelease];
    self.landerModel.dataSource = self.landerModel;
    self.landerModel.delegate = self.landerModel;
 
    
    // Create the moon - ###reduce frame size at some point
    self.moonView = [[[Moon alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(0, 0, 1024, 768)]] autorelease];
    self.moonView.dataSource = self.moonView;
    self.moonView.userInteractionEnabled = NO;
    self.moonView.hidden = YES;
    [self.moonView useNormalView];
    [self.view addSubview:self.moonView];

    // Create the message manager
    self.landerMessages = [[[LanderMessages alloc] init] autorelease];
    self.landerMessages.hidden = NO;
    [self.view addSubview:self.landerMessages];
    
    // Create the roll control arrows
    NSString *slaPath = [[NSBundle mainBundle] pathForResource:@"SmallLeftArrow" ofType:@"plist"];
    self.smallLeftArrow = [[[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(925, 375, 24, 12)]  withPaths:slaPath andRepeat:0.5f] autorelease];
	[self.smallLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    self.smallLeftArrow.hidden = YES;
    [self.view addSubview:self.smallLeftArrow];
    
    NSString *sraPath = [[NSBundle mainBundle] pathForResource:@"SmallRightArrow" ofType:@"plist"];
    self.smallRightArrow = [[[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(955, 375, 24, 12)] withPaths:sraPath andRepeat:0.5f] autorelease];
	[self.smallRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    self.smallRightArrow.hidden = YES;
    [self.view addSubview:self.smallRightArrow];
    
    NSString *llaPath = [[NSBundle mainBundle] pathForResource:@"LargeLeftArrow" ofType:@"plist"];
    self.largeLeftArrow = [[[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(905, 330, 48, 24)] withPaths:llaPath andRepeat:0.5f] autorelease];
	[self.largeLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    self.largeLeftArrow.hidden = YES;
    [self.view addSubview:self.largeLeftArrow];
    
    NSString *lraPath = [[NSBundle mainBundle] pathForResource:@"LargeRightArrow" ofType:@"plist"];
    self.largeRightArrow = [[[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(955, 330, 48, 24)] withPaths:lraPath andRepeat:0.5f] autorelease];
	[self.largeRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    self.largeRightArrow.hidden = YES;
    [self.view addSubview:self.largeRightArrow];
    
    // Create the thruster control
    self.thrusterSlider = [[[VGSlider alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(820, 450, 200, 200)]] autorelease];
	[self.thrusterSlider addTarget:self 
                            action:@selector(thrusterChanged:) 
                  forControlEvents:UIControlEventValueChanged];
    self.thrusterSlider.hidden = YES;
    [self.view addSubview:self.thrusterSlider];
    
    // Create the telemetry items
    const float telemetryX = 925;
    self.heightData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 247, 100, 20)]] autorelease];
    self.heightData.titleLabel.text = @"HEIGHT";
    self.heightData.format = @"%6d %@";
    self.heightData.data = Block_copy(^{return self.RADARY;});
	[self.heightData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    self.heightData.hidden = YES;
    [self.view addSubview:self.heightData];
    
    self.altitudeData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 225, 100, 20)]] autorelease];
    self.altitudeData.titleLabel.text = @"ALTITUDE";
    self.altitudeData.format = @"%6d %@";
    self.altitudeData.data = Block_copy(^{ return (short)([self.landerModel.dataSource altitude]);});
	[self.altitudeData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    self.altitudeData.hidden = YES;
    [self.view addSubview:self.altitudeData];
    
    self.distanceData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 203, 100, 20)]] autorelease];
    self.distanceData.titleLabel.text = @"DISTANCE";
    self.distanceData.format = @"%6d %@";
    self.distanceData.data = Block_copy(^{ return (short)([self.landerModel.dataSource distance]);});
	[self.distanceData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    self.distanceData.hidden = YES;
    [self.view addSubview:self.distanceData];
    

    self.fuelLeftData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 181, 100, 20)]] autorelease];
    self.fuelLeftData.titleLabel.text = @"FUEL LEFT";
    self.fuelLeftData.format = @"%6d %@";
    self.fuelLeftData.data = Block_copy(^{ return (short)([self.landerModel.dataSource fuel]);});
	[self.fuelLeftData addTarget:self 
                         action:@selector(telemetrySelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.fuelLeftData.hidden = YES;
    [self.view addSubview:self.fuelLeftData];
    
    self.weightData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 159, 100, 20)]] autorelease];
    self.weightData.titleLabel.text = @"WEIGHT";
    self.weightData.format = @"%6d %@";
    self.weightData.data = Block_copy(^{ return (short)([self.landerModel.dataSource weight]);});
	[self.weightData addTarget:self 
                                   action:@selector(telemetrySelected:) 
                         forControlEvents:UIControlEventTouchUpInside];
    self.weightData.hidden = YES;
    [self.view addSubview:self.weightData];

    self.thrustData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 137, 100, 20)]] autorelease];
    self.thrustData.titleLabel.text = @"THRUST";
    self.thrustData.format = @"%6d %@";
    self.thrustData.data = Block_copy(^{ return (short)([self.landerModel.dataSource thrust]);});
	[self.thrustData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.thrustData.hidden = YES;
    [self.view addSubview:self.thrustData];
    
    self.thrustAngleData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 115, 100, 20)]] autorelease];
    self.thrustAngleData.titleLabel.text = @"ANGLE";
    self.thrustAngleData.format = @"%6d %@";
    self.thrustAngleData.data = Block_copy(^{ return (short)([self.landerModel.dataSource angleDegrees]);});
	[self.thrustAngleData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.thrustAngleData.hidden = YES;
    [self.view addSubview:self.thrustAngleData];
    
    self.verticalVelocityData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 93, 100, 20)]] autorelease];
    self.verticalVelocityData.titleLabel.text = @"VER VEL";
    self.verticalVelocityData.format = @"%6d %@";
    self.verticalVelocityData.data = Block_copy(^{ return (short)([self.landerModel.dataSource vertVel]);});
	[self.verticalVelocityData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.verticalVelocityData.hidden = YES;
    [self.view addSubview:self.verticalVelocityData];
    
    self.horizontalVelocityData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 71, 100, 20)]] autorelease];
    self.horizontalVelocityData.titleLabel.text = @"HOR VEL";
    self.horizontalVelocityData.format = @"%6d %@";
    self.horizontalVelocityData.data = Block_copy(^{ return (short)([self.landerModel.dataSource horizVel]);});
	[self.horizontalVelocityData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.horizontalVelocityData.hidden = YES;
    [self.view addSubview:self.horizontalVelocityData];
    
    self.verticalAccelerationData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 49, 100, 20)]] autorelease];
    self.verticalAccelerationData.titleLabel.text = @"VER ACC";
    self.verticalAccelerationData.format = @"%6d %@";
    self.verticalAccelerationData.data = Block_copy(^{ return (short)([self.landerModel.dataSource vertAccel]);});
	[self.verticalAccelerationData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.verticalAccelerationData.hidden = YES;
    [self.view addSubview:self.verticalAccelerationData];
    
    self.horizontalAccelerationData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 27, 100, 20)]] autorelease];
    self.horizontalAccelerationData.titleLabel.text = @"HOR ACC";
    self.horizontalAccelerationData.format = @"%6d %@";
    self.horizontalAccelerationData.data = Block_copy(^{ return (short)([self.landerModel.dataSource horizAccel]);});
	[self.horizontalAccelerationData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.horizontalAccelerationData.hidden = YES;
    [self.view addSubview:self.horizontalAccelerationData];
    
    self.secondsData = [[[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(telemetryX, 5, 100, 20)]] autorelease];
    self.secondsData.titleLabel.text = @"SECONDS";
    self.secondsData.format = @"%6d %@";
    self.secondsData.data = Block_copy(^{ return (short)([self.landerModel.dataSource time]);});
	[self.secondsData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    self.secondsData.hidden = YES;
    [self.view addSubview:self.secondsData];
 
    // Create the instrumentation labels
    self.instrument1 = [[[Instrument alloc] initWithFrame:CGRectMake(0, 0, 200, 24)] autorelease];
    self.instrument1.instrument = self.heightData;
	[self.instrument1 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument1];
    
    self.instrument2 = [[[Instrument alloc] initWithFrame:CGRectMake(250, 0, 200, 24)] autorelease];
    self.instrument2.instrument = self.distanceData;
	[self.instrument2 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument2];
    
    self.instrument3 = [[[Instrument alloc] initWithFrame:CGRectMake(500, 0, 200, 24)] autorelease];
    self.instrument3.instrument = self.verticalVelocityData;
	[self.instrument3 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument3];
    
    self.instrument4 = [[[Instrument alloc] initWithFrame:CGRectMake(750, 0, 200, 24)] autorelease];
    self.instrument4.instrument = self.horizontalVelocityData;
	[self.instrument4 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument4];

    self.instrument5 = [[[Instrument alloc] initWithFrame:CGRectMake(0, 40, 200, 24)] autorelease];
    self.instrument5.instrument = self.altitudeData;
	[self.instrument5 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument5.hidden = YES;
    [self.view addSubview:self.instrument5];
    
    self.instrument6 = [[[Instrument alloc] initWithFrame:CGRectMake(250, 40, 200, 24)] autorelease];
    self.instrument6.instrument = self.fuelLeftData;
	[self.instrument6 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument6.hidden = YES;
    [self.view addSubview:self.instrument6];
    
    self.instrument7 = [[[Instrument alloc] initWithFrame:CGRectMake(500, 40, 200, 24)] autorelease];
    self.instrument7.instrument = self.thrustAngleData;
	[self.instrument7 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument7.hidden = YES;
    [self.view addSubview:self.instrument7];
    
    self.instrument8 = [[[Instrument alloc] initWithFrame:CGRectMake(750, 40, 200, 24)] autorelease];
    self.instrument8.instrument = self.secondsData;
	[self.instrument8 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    self.instrument8.hidden = YES;
    [self.view addSubview:self.instrument8];
    
    // Create the lander view with data sources
    self.landerView = [[[Lander alloc] init] autorelease];
    self.landerView.userInteractionEnabled = NO;
    self.landerView.contentMode = UIViewContentModeRedraw;
    self.landerView.thrustData = Block_copy(^{ return [self.landerModel.dataSource thrustPercent];});
    self.landerView.angleData = Block_copy(^{ return [self.landerModel.dataSource angle];});
    self.landerView.positionData = Block_copy(^{ return [self.landerModel.dataSource landerPosition];});
    self.landerView.hidden = YES;
    [self.view addSubview:self.landerView];
    
    // Start the game
    [self initGame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Kill any active timers
    if (self.simulationTimer) {
        [self.simulationTimer invalidate];
        self.simulationTimer = nil;
    }
    if (self.displayTimer) {
        [self.displayTimer invalidate];
        self.displayTimer = nil;
    }
    if (self.palsyTimer) {
        [self.palsyTimer invalidate];
        self.palsyTimer = nil;
    }

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
    [self.landerModel.dataSource setThrust:sender.value];
    [self.thrusterSlider setValue:[self.landerModel.dataSource thrustPercent]];
}

//
// ###Need to emulate better, original code uses +-15 and +-100 degrees per second for the roll
// rates using a calculation
//
// (rate_of_turn * clock_ticks) / clock_frequency
//
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
    
#if 0 // debug only
    [self.instrument5 display];
    [self.instrument6 display];
    [self.instrument7 display];
    [self.instrument8 display];
#endif
}

- (void)OFFCOM:(float)xPosition withMessage:(NSString *)message
{
    short newHDistance = xPosition * 32 - 22400;
    short newVertVel = self.VERDIS / 40;
    if (newVertVel >= 0) {
        newVertVel = -newVertVel;
    }
    
    [self.landerModel.dataSource setDistance:newHDistance];    
    [self.landerModel.dataSource setFuel:0.0f];    
    [self.landerModel.dataSource setHorizVel:0.0f];   
    [self.landerModel.dataSource setVertVel:newVertVel];   

    // Add the message to the display
    [self.landerMessages addSystemMessage:message];
}

- (short)DFAKE:(short)yValue
{
    short y = yValue;
    //###y = (y * 3) / 8 + 23;
    y = (y * 3) / 8 + 17;
    return y;
}

- (void)landerDown
{
    // Tell model we are on surface
    [self.landerModel landerDown];
    
    // Remove dust view
    if (self.dustView) {
        self.dustView.drawPaths = nil;
        [self.dustView removeFromSuperview];
        self.dustView = nil;
    }
    
    // Update the thruster display so it shows our updated value
    [self.thrusterSlider setValue:[self.landerModel.dataSource thrustPercent]];
    
    // Disable flight controls
    [self disableFlightControls];
    
    // Final lander update
    [self updateLander];
}

- (void)DUST
{
    // Wait till 150 feet above surface before kicking up dust
    if (self.RADARY < 150 && (self.ANGLED > -45 || self.ANGLED < 45)) {
        const short MaxDust = 241;
        
        // Magnitude of dust determines intensity level
        short percentThrust = (self.PERTRS > 63) ? 63 : self.PERTRS;
        short displayIntensity = (percentThrust >> 3) & 0x7;
        short sinAngle = (short)(sin(self.ANGLE));
        short cosAngle = (short)(cos(self.ANGLE));
        if (sinAngle < 0) {
            sinAngle = -sinAngle;
        }
        
        // DUSTP1
        short deltaY = self.SHOWY - self.AVERT;
        short tanDeltaY = sinAngle * deltaY;
        if (cosAngle != 0) {
            tanDeltaY = tanDeltaY / cosAngle;
        }
        
        short flameDistance = tanDeltaY + deltaY;
        if (sinAngle >= 0) {
            tanDeltaY = -tanDeltaY;
        }
        
        // DUSTP2
        short xCenterPos = self.SHOWX + tanDeltaY;
        short yCenterPos = self.AVERT;
        
        flameDistance -= 150;
        if (flameDistance < 0) {
            flameDistance = -flameDistance;
            short count = ((flameDistance * self.PERTRS) >> 4);
            if (count > MaxDust)
                count = MaxDust;
            
            //NSLog(@"DUST Center: (%d, %d) FD: %d  %d items at intensity %d", xCenterPos, yCenterPos, flameDistance, count, displayIntensity);
            if (count) {
                //short xValues[MaxDust];
                //short yValues[MaxDust];
                //short valueIndex = 0;
                
                NSMutableArray *path = [[[NSMutableArray alloc] init] autorelease];
                NSArray *paths = [NSArray arrayWithObject:path];
                
                NSNumber *intensity = [NSNumber numberWithInt:displayIntensity];
                NSNumber *width = [NSNumber numberWithFloat:1.0f];
                NSNumber *height = [NSNumber numberWithFloat:1.0f];
                
                // DUSTWF
                const short YThrust[] = { 0, -30, -31, -32, -34, -36, -38, -41, -44, -47, -50, -53, -56, 0, 1, 3, 6, 4, 3, 1, -2, -6, -7, -5, -2, 2, 3, 5, 6, 2, 1, -1, -4, -6, -5, -3, 0, 4, 5, 7, 4, 0, -1, -3, -1, -20, -16, -13, -10, -7, -4, -2, 0, 2, 4, 7, 10, 13, 16, 20, 0, -30, -31 };
                const short dimYThrust = sizeof(YThrust)/sizeof(YThrust[0]);
                assert(dimYThrust == 63);
                
                short random = self.DUSTX;
                // DUSTL
                while (count--) {
                    random += self.TIME + 1;
                    random &= dimYThrust;
                    
                    // X coordinate
                    short xPos = YThrust[random];
                    random += self.VERACC;
                    random &= dimYThrust;
                    
                    // Toggle the direction bit for X
                    flameDistance = ~flameDistance;
                    if (flameDistance < 0) {
                        xPos *= -1;
                    }
                    //xPos &= 0x3f;
                    xPos += 64;
                    
                    // Now the Y value (always positive)
                    short yPos = YThrust[random];
                    yPos &= 0x3f;
                    yPos = 63 - yPos;
                    
                    //xValues[valueIndex] = xPos;
                    //yValues[valueIndex] = yPos;
                    //valueIndex++;
                    
                    // Flip signs and do a moveto (INT = 0)
                    // This does a move back to center of dust to prep for the next point
                    
                    // Draw rect command
                    //NSLog(@"DUST: X:%d, Y:%d", xPos, yPos);
                    NSNumber *x = [NSNumber numberWithFloat:xPos];
                    NSNumber *y = [NSNumber numberWithFloat:yPos];
                    
                    NSDictionary *originItem = [NSDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil];
                    NSDictionary *sizeItem = [NSDictionary dictionaryWithObjectsAndKeys:width, @"width", height, @"height", nil];
                    NSDictionary *frameItem = [NSDictionary dictionaryWithObjectsAndKeys:originItem, @"origin", sizeItem, @"size", nil];
                    NSDictionary *rectItem = [NSDictionary dictionaryWithObjectsAndKeys:frameItem, @"frame", nil];
                    NSDictionary *pathItem = [NSDictionary dictionaryWithObjectsAndKeys:rectItem, @"rect", intensity, @"intensity", nil];
                    [path addObject:pathItem];
                }
                
                // This is a hack - fixme!
                xCenterPos -= 64;
                yCenterPos = 768 - yCenterPos - yCenterPos;
                
                // Save our random number for next time
                self.DUSTX = random;
                
                // Create the view if needed
                if (!self.dustView) {
                    CGRect frameRect = CGRectMake(xCenterPos, yCenterPos, 128, 64);
                    self.dustView = [[[Dust alloc] initWithFrame:frameRect] autorelease];
                    [self.view addSubview:self.dustView];
                }
                else if (self.dustView.frame.origin.x != xCenterPos || self.dustView.frame.origin.y != yCenterPos) {
                    // remove old dust view and create a new one
                    [self.dustView removeFromSuperview];
                    CGRect frameRect = CGRectMake(xCenterPos, yCenterPos, 128, 64);
                    self.dustView = [[[Dust alloc] initWithFrame:frameRect] autorelease];
                    [self.view addSubview:self.dustView];
                }
                
                // Add the draw paths and update the display
                self.dustView.drawPaths = paths;
                [self.dustView setNeedsDisplay];
            }
        }
    }
    else {
        // Remove dust view
        if (self.dustView) {
            self.dustView.drawPaths = nil;
            [self.dustView removeFromSuperview];
            self.dustView = nil;
        }
    }
}

- (void)EXPLOD
{
    // We are down hard
    [self.landerModel landerDown];
    
    // Shut down things and ring bell
    AudioServicesPlayAlertSound(BeepSound);
    
    // Let's delay a bit before presenting the new game dialog
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:explodeDelay target:self selector:@selector(waitNewGame) userInfo:nil repeats:NO];

#if 0  //### need to sort out this code
    short RADIUS = 0;
    
    // Work on the randomizer
    static short XTYPE = 0;
    XTYPE++;
    swab(&XTYPE, &XTYPE, sizeof(XTYPE));
    short temp = (XTYPE & 0x8000) != 0;
#endif
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
        //###
    }
}

- (void)waitNewGame
{
    // Kill the timers that might be running
    if (self.palsyTimer) {
        [self.palsyTimer invalidate];
        self.palsyTimer = nil;
    }
    if (self.simulationTimer) {
        [self.simulationTimer invalidate];
        self.simulationTimer = nil;
    }
    if (self.displayTimer) {
        [self.displayTimer invalidate];
        self.displayTimer = nil;
    }
    
    // Remove any messages
    [self.landerMessages removeAllLanderMessages];
    
    // Hide the lander view
    self.landerView.hidden = YES;
    
    // Setup our dialog for a new game
    CGRect dialogRect = CGRectMake(450, 300, 200, 100);
    self.anotherGameDialog = [[[VGDialog alloc] initWithFrame:dialogRect addTarget:self onSelection:@selector(getYesNo)] autorelease];
    [self.view addSubview:self.anotherGameDialog];
}

- (void)drawMcMan7
{
    // Let's delay a bit before presenting the new game dialog
    [self.palsyTimer invalidate];
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:newGameDelay target:self selector:@selector(waitNewGame) userInfo:nil repeats:NO];
}

- (void)drawMcMan6
{
    // Remove any messages that pop up
    [self.landerMessages removeAllLanderMessages];
    
    // Force the controls to the eparture levels
    self.HORVEL = 0;
    self.THRUST = 30;
    self.ANGLE = 0;
    [self.thrusterSlider setValue:[self.landerModel.dataSource thrustPercent]];
    
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

        // Wait a bit
        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:endDelay target:self selector:@selector(drawMcMan7) userInfo:nil repeats:NO];
    }
}

- (void)drawMcMan5
{
    // Remove the man view
    [self.manView removeFromSuperview];
    self.manView = nil;
    
    // No more messages at this point
    [self.landerMessages removeAllLanderMessages];

    // Now take off with the food
    self.VERDIS += 4;
    self.FUEL += 200;
    self.ANGLE = 0;
    self.VERVEL = 0;
    self.HORVEL = 0;
    self.THRUST = 30;

    [self enableFlightControls];
    
    // Tell model we are on surface
    [self.landerModel landerTakeoff];
    
    // Setup game and delay timers
#if 0
	self.simulationTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimerInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
	self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:DisplayUpdateInterval target:self selector:@selector(updateLander) userInfo:nil repeats:YES];
#endif
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:DisplayUpdateInterval target:self selector:@selector(drawMcMan6) userInfo:nil repeats:YES];
}

- (void)drawMcMan4
{
    BOOL done = [self.manView moveMan];
    if (done) {
        [self.palsyTimer invalidate];
        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:launchDelay target:self selector:@selector(drawMcMan5) userInfo:nil repeats:NO];
    }
}
 
- (void)drawMcMan3
{
    BOOL done = [self.manView moveMan];
    if (done) {
        [self.palsyTimer invalidate];
        self.palsyTimer = nil;
        
        short deltaY = abs(self.manView.initialY - self.manView.Y);
        self.manView.deltaY = deltaY;

        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:moveInterval target:self selector:@selector(drawMcMan4) userInfo:nil repeats:YES];
    }
}

- (void)waitForFood2
{
    [self.palsyTimer invalidate];
    self.palsyTimer = nil;
    
    // Move back to the lander
    short deltaX = abs(self.manView.initialX - self.manView.X);
    short deltaY = abs(self.manView.initialY - self.manView.Y);
    self.manView.deltaX = deltaX - deltaY;
    self.manView.deltaY = 0;
    self.manView.incrementX = -self.manView.incrementX;
    self.manView.incrementY = -self.manView.incrementY;
    
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:moveInterval target:self selector:@selector(drawMcMan3) userInfo:nil repeats:YES];
}
 
- (void)waitForFood1
{
    [self.palsyTimer invalidate];
    self.palsyTimer = nil;

    [self.landerMessages removeSystemMessage:@"YourOrder"];
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:secondFoodDelay target:self selector:@selector(waitForFood2) userInfo:nil repeats:NO];
}

- (void)moveMcManHoriz
{
    BOOL done = [self.manView moveMan];
    if (done) {
        [self.palsyTimer invalidate];
        self.palsyTimer = nil;
        
        // Order some food and wait
        [self.landerMessages addSystemMessage:@"YourOrder"];
        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:initialFoodDelay target:self selector:@selector(waitForFood1) userInfo:nil repeats:NO];
    }        
}

- (void)moveMcManVertHoriz
{
    BOOL done = [self.manView moveMan];
    if (done) {
        [self.palsyTimer invalidate];
        //###self.palsyTimer = nil;
        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:moveInterval target:self selector:@selector(moveMcManHoriz) userInfo:nil repeats:YES];
    }
}

- (void)waitFlagMan
{
    // KIll the timers - we are done
    [self.palsyTimer invalidate];
    self.palsyTimer = nil;
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
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:newGameDelay target:self selector:@selector(waitNewGame) userInfo:nil repeats:NO];
}

- (void)drawFlagMan1
{
    // Move the man to ground level and then setup the horizontal move
    BOOL done = [self.manView moveMan];
    if (done) {
        // Next position
        self.manView.deltaX = 48;
        self.manView.deltaY = 0;

        // Set up the next delay
        [self.palsyTimer invalidate];
        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:moveInterval target:self selector:@selector(drawFlagMan2) userInfo:nil repeats:YES];
    }
}

- (void)drawFlagMan2
{
    BOOL done = [self.manView moveMan];
    if (done) {
        [self.palsyTimer invalidate];
        self.palsyTimer = nil;
    
    // Put the flag in position
    short flagX = self.manView.X + 20 * self.manView.incrementX;
    CGPoint origin = CGPointMake(flagX, self.manView.Y);
    self.flagView = [[[Flag alloc] initWithOrigin:origin] autorelease];
    [self.view addSubview:self.flagView];
    
    // Add the flag and message
    short flagIndex = self.INDEXL + 2 * self.manView.incrementX;
    [self.moonView addFeature:TF_OldFlag atIndex:flagIndex];
    [self.landerMessages addSystemMessage:@"OneSmallStep"];
    
    // Use a timer to wait (10 secs)
    self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:flagFinalDelay target:self selector:@selector(waitFlagMan) userInfo:nil repeats:NO];
    }
}

- (void)moveMan
{
    [self.palsyTimer invalidate];
    self.palsyTimer = nil;
    
    if (self.moonView.hasMcDonalds) {
        // Visit to Macdonald's, need coordinates
        // Put the man in position
        short deltaX = self.moonView.MACX - self.SHOWX;
        short deltaY = self.moonView.MACY - self.SHOWY;//### + 45;
        CGPoint start = CGPointMake(self.SHOWX, self.view.frame.size.width - self.SHOWY);
        CGPoint delta = CGPointMake(deltaX, deltaY);
        self.manView = [[[Man alloc] initWithOrigin:start andDelta:delta] autorelease];
        [self.view addSubview:self.manView];
        
        // Use a timer to animate our guy
        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:moveInterval target:self selector:@selector(moveMcManVertHoriz) userInfo:nil repeats:YES];
    }
    else {
        // Put the man in position
        CGPoint start = CGPointMake(self.SHOWX, self.view.frame.size.width - self.SHOWY);
        CGPoint delta = CGPointMake(48, 24);
        self.manView = [[[Man alloc] initWithOrigin:start andDelta:delta] autorelease];
        [self.view addSubview:self.manView];
       
        // Use a timer to animate our guy
        self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:moveInterval target:self selector:@selector(drawFlagMan1) userInfo:nil repeats:YES];
    }
}

- (void)PALSY
{
    // Start with a delay of 4 seconds
	self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:landingDelay target:self selector:@selector(moveMan) userInfo:nil repeats:NO];
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
    
    if (self.RADARY < -10) {
        //INTELM
        //###[self gameOver];
        //DEAD
        [self.landerMessages addSystemMessage:@"DeadLanding"];
        QUICK = YES;
    }
    else if (self.RADARY <= 3) {
        //VERYLO turn off fuel, flames, and dust
        [self.landerMessages removeFuelMessage];

        // We landed or crashed
        [self landerDown];
        
        //VD
        short vervel = (short)([self.landerModel.dataSource vertVel]);
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
        short vervel = (short)([self.landerModel.dataSource vertVel]);
        if (vervel < -60) {
            //AHAH
            [self.landerMessages addSystemMessage:@"VeryFast"];
            AHAHC = YES;
        }
        else if (vervel < -30) {
            //AHAH2
            [self.landerMessages addSystemMessage:@"Fast"];
            AHAHC = YES;
        }
        else if (vervel < -15) {
            //AHAH3
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
                    self.SHOWY -= 16;
                    
                    // Explode
                    self.landerView.hidden = YES;
                    [self EXPLOD];
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
                    [self.landerMessages addSystemMessage:@"HitCrashedLander"];
                    self.landerView.hidden = YES;
                    [self EXPLOD];
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
                    self.landerView.hidden = YES;
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
        else if (tf == TF_McDonalds) {
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
        short horizvel = (short)([self.landerModel.dataSource horizVel]);
        short angle = (short)([self.landerModel.dataSource angleDegrees]);
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
            short thl = (short)([self.moonView.dataSource averageTerrainHeight:self.INDEXL]);
            short thr = (short)([self.moonView.dataSource averageTerrainHeight:(self.INDEXL+1)]);
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
            if (TiltDirection < 0) {
                [self.moonView addFeature:TF_OldLanderTippedLeft atIndex:self.INDEXL];
            }
            else {
                [self.moonView addFeature:TF_OldLanderTippedRight atIndex:self.INDEXL];
            }
            
            // We are down but tipped for some reason remove the lander
            self.landerView.hidden = YES;
            [self.landerModel landerDown];
            
            // Let's delay a bit before presenting the new game dialog
            self.palsyTimer = [NSTimer scheduledTimerWithTimeInterval:explodeDelay target:self selector:@selector(waitNewGame) userInfo:nil repeats:NO];
        }
    }
    
    if (QUICK) {
        // Hide the lander view
        self.landerView.hidden = YES;
        
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
            [self disableRollThrusters];
        }
        else if (self.FUEL < 200) {
            if (!self.didFuelAlert) {
                // Only do this once
                self.didFuelAlert = YES;

                // Add message and ring bell
                [self.landerMessages addFuelMessage];
                AudioServicesPlayAlertSound(BeepSound);
            }
        }
        
        //(SHOWNT) Test for extreme game events that end the simulation
        self.BIGXCT = (self.HORDIS + 22400) / 32;

        // Get the terrain information
        short tIndex = self.BIGXCT;
        short thl = [self.moonView.dataSource averageTerrainHeight:tIndex];
        short thr = [self.moonView.dataSource averageTerrainHeight:tIndex+1];
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

            //(CLSEC1) Check if we are at the left/right edger and need to redraw
            short xPos = self.HORDIS - self.LEFEET;
            if (xPos <= 30) {
                // Move the closeup view left
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
            self.SHOWX = (xPos * 3) / 2;
            
            // Index to terrain/feature to left of lander
            self.INDEXL = self.LEFTEDGE + (self.SHOWX / 48);
            self.INDEXLR = self.SHOWX % 48;
            
            // Get the terrain information
            short thl = (short)([self.moonView.dataSource averageTerrainHeight:self.INDEXL]) * (48 - self.INDEXLR);
            short thr = (short)([self.moonView.dataSource averageTerrainHeight:(self.INDEXL+1)]) * self.INDEXLR;
            short th = (thl + thr) / 48;
            self.AVERY = th >> 2;
            self.AVERT = [self DFAKE:th];
            
            //short RET2 = ((self.VERDIS * 3) / 2) + 23;
            short RET2 = ((self.VERDIS * 3) / 2) + 17;
            self.SHOWY = RET2;
            self.SHOWY += 24;
            
            RET2 -= self.AVERT;
            self.RADARY = (RET2 * 2) / 3;
            
            [self INTEL];
            [self DUST];

            // Redraw surface if changed
            [self.moonView useCloseUpView:self.LEFTEDGE];

            // Move the lander
            CGPoint newFrame = self.landerView.center;
            newFrame.x = self.SHOWX;
            newFrame.y = self.view.frame.size.width - self.SHOWY;
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
            newFrame.y = self.view.frame.size.width - self.SHOWY;
            self.landerView.center = newFrame;
            
            // Test for contact with surface
            if ((self.RADARY - 16) < 0) {
                [self ALTER:640];
                [self EXPLOD];
            }
        }
    }
}

@end
