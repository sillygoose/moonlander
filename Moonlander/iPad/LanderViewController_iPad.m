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

@synthesize instrument5=_instrument5;
@synthesize instrument6=_instrument6;
@synthesize instrument7=_instrument7;
@synthesize instrument8=_instrument8;

@synthesize landerMessages=_landerMessages;


const float GameTimerInterval = 1.0 / 12.0f;
const float DisplayUpdateInterval = 0.05f;


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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (short)PERTRS
{
    return (short)([self.landerModel.dataSource thrustPercent]);
}

- (short)ANGLE
{
    return (short)([self.landerModel.dataSource angleDegrees]);
}

- (short)HORVEL
{
    return (short)([self.landerModel.dataSource horizVel]);
}

- (short)VERVEL
{
    return (short)([self.landerModel.dataSource vertVel]);
}

- (short)THRUST
{
    return (short)([self.landerModel.dataSource thrust]);
}

- (void)dealloc
{
    [_landerModel release];
    
    [_moonView release];
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
    
    [_instrument1 release];
    [_instrument2 release];
    [_instrument3 release];
    [_instrument4 release];
    
    [_instrument5 release];
    [_instrument6 release];
    [_instrument7 release];
    [_instrument8 release];
    
    [_landerMessages release];
    
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

- (void)disableRollThrusters
{
    self.thrusterSlider.enabled = NO;
    self.smallLeftArrow.enabled = NO;
    self.smallRightArrow.enabled = NO;
    self.largeLeftArrow.enabled = NO;
    self.largeRightArrow.enabled = NO;
}

- (void)initGame
{
    // Start with a normal view
    [self.moonView useNormalView];
    [self.landerModel newGame];
    
    // Starting posiition
    self.SHOWX = 0;
    self.SHOWY = 0;
    
    [self enableFlightControls];
    
    //###[self.landerModel.delegate newGame];
    
    // Setup controls with model defaults
    self.thrusterSlider.value = [self.landerModel.dataSource thrustPercent];

    // Init displays
    [self.instrument1 display];
    [self.instrument2 display];
    [self.instrument3 display];
    [self.instrument4 display];
    
    [self.instrument5 display];
    [self.instrument6 display];
    [self.instrument7 display];
    [self.instrument8 display];
    
    // Setup game timers
	self.simulationTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimerInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
	self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:DisplayUpdateInterval target:self selector:@selector(updateLander) userInfo:nil repeats:YES];
    
    [self updateLander];
}

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [super viewDidLoad];
    
    // Create the lander simulation model
    self.landerModel = [[LanderPhysicsModel alloc] init];
    self.landerModel.dataSource = self.landerModel;
    self.landerModel.delegate = self.landerModel;
 
    // Create the moon - ###reduce frame size at some point
    self.moonView = [[Moon alloc] initWithFrame:[self convertRectFromGameToView:CGRectMake(0, 0, 1024, 768)]];
    self.moonView.dataSource = self.moonView;
    self.moonView.userInteractionEnabled = NO;
    [self.moonView useNormalView];
    [self.view addSubview:self.moonView];

    // Create the message manager
    self.landerMessages = [[LanderMessages alloc] init];
    [self.view addSubview:self.landerMessages];
    
    // New game button
    self.newGameButton = [[VGButton alloc] initWithFrame:CGRectMake(960, 0, 64, 64)];
    self.newGameButton.titleLabel.text = @"New Game";
	[self.newGameButton addTarget:self 
                           action:@selector(newGame:) 
                 forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.newGameButton];
    
    // Create the roll control arrows
    NSString *slaPath = [[NSBundle mainBundle] pathForResource:@"SmallLeftArrow" ofType:@"plist"];
    self.smallLeftArrow = [[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(925, 375, 24, 12)]  withPaths:slaPath andRepeat:0.5f];
	[self.smallLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.smallLeftArrow];
    
    NSString *sraPath = [[NSBundle mainBundle] pathForResource:@"SmallRightArrow" ofType:@"plist"];
    self.smallRightArrow = [[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(955, 375, 24, 12)] withPaths:sraPath andRepeat:0.5f];
	[self.smallRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.smallRightArrow];
    
    NSString *llaPath = [[NSBundle mainBundle] pathForResource:@"LargeLeftArrow" ofType:@"plist"];
    self.largeLeftArrow = [[VGButton alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(905, 330, 48, 24)] withPaths:llaPath andRepeat:0.5f];
	[self.largeLeftArrow addTarget:self 
                            action:@selector(rotateLander:) 
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.largeLeftArrow];
    
    NSString *lraPath = [[NSBundle mainBundle] pathForResource:@"LargeRightArrow" ofType:@"plist"];
    self.largeRightArrow = [[VGButton alloc] initWithFrame:
                            [self convertRectFromGameToView: CGRectMake(955, 330, 48, 24)] withPaths:lraPath andRepeat:0.5f];
	[self.largeRightArrow addTarget:self 
                             action:@selector(rotateLander:) 
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.largeRightArrow];
    
    // Create the thruster control
    self.thrusterSlider = [[VGSlider alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(800, 450, 200, 200)]];
	[self.thrusterSlider addTarget:self 
                            action:@selector(thrusterChanged:) 
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.thrusterSlider];
    
    // Create the telemetry items
    self.heightData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 247, 100, 20)]];
    self.heightData.titleLabel.text = @"HEIGHT";
    self.heightData.format = @"%6d %@";
    self.heightData.data = Block_copy(^{return self.RADARY;});
	[self.heightData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.heightData];
    
    self.altitudeData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 225, 100, 20)]];
    self.altitudeData.titleLabel.text = @"ALTITUDE";
    self.altitudeData.format = @"%6d %@";
    self.altitudeData.data = Block_copy(^{ return (short)([self.landerModel.dataSource altitude]);});
	[self.altitudeData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.altitudeData];
    
    self.distanceData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 203, 100, 20)]];
    self.distanceData.titleLabel.text = @"DISTANCE";
    self.distanceData.format = @"%6d %@";
    self.distanceData.data = Block_copy(^{ return (short)([self.landerModel.dataSource distance]);});
	[self.distanceData addTarget:self 
                           action:@selector(telemetrySelected:) 
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.distanceData];
    

    self.fuelLeftData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 181, 100, 20)]];
    self.fuelLeftData.titleLabel.text = @"FUEL LEFT";
    self.fuelLeftData.format = @"%6d %@";
    self.fuelLeftData.data = Block_copy(^{ return (short)([self.landerModel.dataSource fuel]);});
	[self.fuelLeftData addTarget:self 
                         action:@selector(telemetrySelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fuelLeftData];
    
    self.weightData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 159, 100, 20)]];
    self.weightData.titleLabel.text = @"WEIGHT";
    self.weightData.format = @"%6d %@";
    self.weightData.data = Block_copy(^{ return (short)([self.landerModel.dataSource weight]);});
	[self.weightData addTarget:self 
                                   action:@selector(telemetrySelected:) 
                         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.weightData];

    self.thrustData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 137, 100, 20)]];
    self.thrustData.titleLabel.text = @"THRUST";
    self.thrustData.format = @"%6d %@";
    self.thrustData.data = Block_copy(^{ return (short)([self.landerModel.dataSource thrust]);});
	[self.thrustData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.thrustData];
    
    self.thrustAngleData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 115, 100, 20)]];
    self.thrustAngleData.titleLabel.text = @"ANGLE";
    self.thrustAngleData.format = @"%6d %@";
    self.thrustAngleData.data = Block_copy(^{ return (short)([self.landerModel.dataSource angleDegrees]);});
	[self.thrustAngleData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.thrustAngleData];
    
    self.verticalVelocityData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 93, 100, 20)]];
    self.verticalVelocityData.titleLabel.text = @"VER VEL";
    self.verticalVelocityData.format = @"%6d %@";
    self.verticalVelocityData.data = Block_copy(^{ return (short)([self.landerModel.dataSource vertVel]);});
	[self.verticalVelocityData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.verticalVelocityData];
    
    self.horizontalVelocityData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 71, 100, 20)]];
    self.horizontalVelocityData.titleLabel.text = @"HOR VEL";
    self.horizontalVelocityData.format = @"%6d %@";
    self.horizontalVelocityData.data = Block_copy(^{ return (short)([self.landerModel.dataSource horizVel]);});
	[self.horizontalVelocityData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.horizontalVelocityData];
    
    self.verticalAccelerationData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 49, 100, 20)]];
    self.verticalAccelerationData.titleLabel.text = @"VER ACC";
    self.verticalAccelerationData.format = @"%6d %@";
    self.verticalAccelerationData.data = Block_copy(^{ return (short)([self.landerModel.dataSource vertAccel]);});
	[self.verticalAccelerationData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.verticalAccelerationData];
    
    self.horizontalAccelerationData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 27, 100, 20)]];
    self.horizontalAccelerationData.titleLabel.text = @"HOR ACC";
    self.horizontalAccelerationData.format = @"%6d %@";
    self.horizontalAccelerationData.data = Block_copy(^{ return (short)([self.landerModel.dataSource horizAccel]);});
	[self.horizontalAccelerationData addTarget:self 
                        action:@selector(telemetrySelected:) 
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.horizontalAccelerationData];
    
    self.secondsData = [[Telemetry alloc] initWithFrame:[self convertRectFromGameToView: CGRectMake(900, 5, 100, 20)]];
    self.secondsData.titleLabel.text = @"SECONDS";
    self.secondsData.format = @"%6d %@";
    self.secondsData.data = Block_copy(^{ return (short)([self.landerModel.dataSource time]);});
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

    self.instrument5 = [[Instrument alloc] initWithFrame:CGRectMake(0, 40, 200, 24)];
    self.instrument5.instrument = self.altitudeData;
	[self.instrument5 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument5];
    
    self.instrument6 = [[Instrument alloc] initWithFrame:CGRectMake(250, 40, 200, 24)];
    self.instrument6.instrument = self.fuelLeftData;
	[self.instrument6 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument6];
    
    self.instrument7 = [[Instrument alloc] initWithFrame:CGRectMake(500, 40, 200, 24)];
    self.instrument7.instrument = self.thrustAngleData;
	[self.instrument7 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument7];
    
    self.instrument8 = [[Instrument alloc] initWithFrame:CGRectMake(750, 40, 200, 24)];
    self.instrument8.instrument = self.secondsData;
	[self.instrument8 addTarget:self 
                         action:@selector(instrumentSelected:) 
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.instrument8];
    
    // Create the lander view with data sources
    self.landerView = [[Lander alloc] init];
    self.landerView.userInteractionEnabled = NO;
    self.landerView.contentMode = UIViewContentModeRedraw;
    self.landerView.thrustData = Block_copy(^{ return [self.landerModel.dataSource thrustPercent];});
    self.landerView.angleData = Block_copy(^{ return [self.landerModel.dataSource angle];});
    self.landerView.positionData = Block_copy(^{ return [self.landerModel.dataSource landerPosition];});
    [self.view addSubview:self.landerView];
    
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
    
    self.instrument5 = nil;
    self.instrument6 = nil;
    self.instrument7 = nil;
    self.instrument8 = nil;
    
    self.newGameButton = nil;
    
    self.smallLeftArrow = nil;
    self.smallRightArrow = nil;
    self.largeLeftArrow = nil;
    self.largeRightArrow = nil;
    
    self.thrusterSlider = nil;
    
    self.landerView = nil;
    self.landerMessages = nil;
    
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

- (IBAction)newGame:(id)sender
{
    [self.landerMessages removeAllLanderMessages];
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
    
    [self.instrument5 display];
    [self.instrument6 display];
    [self.instrument7 display];
    [self.instrument8 display];
}

- (void)OFFCOM:(float)xPosition withMessage:(NSString *)message
{
    short newHDistance = xPosition * 32 - 22400;
    short newVertVel = (short)([self.landerModel.dataSource altitude]) / 40;
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
    y = (y * 3) / 8 + 23;
    return y;
}

- (void)gameOver
{
    // Tell model we are on surface
    [self.landerModel landerDown];
    
    // Remove a fuel low message if present
    [self.landerMessages removeAllLanderMessages];

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

- (void)INTEL
{
    BOOL MAYBE = NO;
    BOOL QUICK = NO;
    BOOL AHAHC = NO;
    
    //NSLog(@"RADARY: %d", self.RADARY);
    if (self.RADARY <= -10) {
        [self gameOver];
        //DEAD
        [self.landerMessages addSystemMessage:@"DeadLanding"];
        //goto QUICK
    }
    else if (self.RADARY > 3) {
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
    else if (self.RADARY <= 3) {
        //VERYLO turn off fuel, flames, and dust
        [self gameOver];

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
    
    if (QUICK) {
        //ALTER surface
        //Redraw moon
        //Remove ship
        //Explode
    }
    else if (AHAHC) {
        // Check for features we might have hit
        TerrainFeature tf = [self.moonView featureAtIndex:self.INDEXL];
        if (tf == TF_OldLander || tf == TF_OldLanderTippedLeft || tf == TF_OldLanderTippedRight) {
            if (self.RADARY <= 26) {
                if (self.VERVEL <= 60) {
                    //GODEAD
                }
                else {
                    [self.landerMessages addSystemMessage:@"HitLander"];
                    if (self.HORVEL < 0)
                        [self.moonView addFeature:TF_OldLanderTippedLeft atIndex:self.INDEXL];
                    else
                        [self.moonView addFeature:TF_OldLanderTippedRight atIndex:self.INDEXL];
                    self.SHOWY -= 16;
                    [self.moonView setNeedsDisplay];
                    //EXPLOD
                }
            }
        }
        else if (tf == TF_Rock) {
        }
        else if (tf == TF_OldFlag) {
            if (self.RADARY <= 26) {
                if (self.THRUST) {
                    [self.moonView removeFeature:TF_OldFlag atIndex:self.INDEXL];
                    [self.landerMessages addSystemMessage:@"HitOldFlag"];
                    [self.moonView setNeedsDisplay];
                }
            }
        }
        else if (tf == TF_McDonalds) {
            if (self.RADARY <= 30) {
                [self.moonView removeFeature:TF_McDonalds atIndex:self.INDEXL];
                [self.landerMessages addSystemMessage:@"HitMcDonalds"];
                [self.moonView setNeedsDisplay];
                //ALTER
            }
        }
    }
    else if (MAYBE) {
        // None is 0, left is < 0, right is > 0
        int TiltDirection = 0;
        
        // Check horizonatal velocity, roll angle, and terrain slope
        short horizvel = (short)([self.landerModel.dataSource horizVel]);
        short angle = (short)([self.landerModel.dataSource angleDegrees]);
        if (horizvel < -10 || horizvel > 10) {
            [self.landerMessages addFlameMessage:@"FastSideways"];
            TiltDirection = horizvel;
        }
        else if (angle < -15 || angle > 15) {
            // Check the roll angle
            [self.landerMessages addFlameMessage:@"TippedOver"];
            TiltDirection = angle;
        }
        else {
            // Check terrain slope
            short thl = (short)([self.moonView.dataSource terrainHeight:self.INDEXL]);
            short thr = (short)([self.moonView.dataSource terrainHeight:(self.INDEXL+1)]);
            if (((thl - thr) < -48) || ((thl - thr) > 48)) {
                [self.landerMessages addFlameMessage:@"BumpyLanding"];
                TiltDirection = thl - thr;
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
        }
        else {
            [self.moonView addFeature:TF_OldLander atIndex:self.INDEXL];
            [self.moonView addFeature:TF_OldFlag atIndex:(self.INDEXL+2)];
        }
    }
}

- (void)DUST
{
    if (self.RADARY < 150) {
        if (self.ANGLE > -45 || self.ANGLE < 45) {
            //short percentThrust = (self.PERTRS > 63) ? 63 : self.PERTRS;
        }
    }
}

- (void)gameLoop
{
    [self.landerModel.delegate updateTime:GameTimerInterval];
    
    // Display a low fuel message
    if ((short)([self.landerModel.dataSource fuel]) <= 0) {
        [self.landerMessages removeFuelMessage];
        [self disableRollThrusters];
    }
    else if ((short)([self.landerModel.dataSource fuel]) < 200) {
        [self.landerMessages addFuelMessage];
    }
    
    // Test for extreme game events that end the simulation
    self.BIGXCT = ((short)([self.landerModel.dataSource distance]) + 22400) / 32;
    if (self.BIGXCT < 0) {
        // Off the left edge
        [self OFFCOM:13 withMessage:@"LeftEdge"];
    }
    else if (self.BIGXCT > 890) {
        // Off the right edge
        [self OFFCOM:887 withMessage:@"RightEdge"];
    }
    else if ([self.landerModel.dataSource altitude] > 25000) {
        // Off the top edge
        [self OFFCOM:self.SHOWX withMessage:@"TopEdge"];
    }
    
    // Switch views if we hit a critical altitude
    if ([self.landerModel.dataSource altitude] < 450) {
        // Find our horizontal position in the closeup view
        if (![self.moonView viewIsDetailed]) {
            // Select the closeup view
            self.LEFTEDGE = self.BIGXCT - 9;
            self.LEFEET = (self.LEFTEDGE * 32) - 22400;
            [self.moonView useCloseUpView:self.LEFTEDGE];
        }

        // Check if we are at the left/right edger and need to redraw
        short xPos = (short)([self.landerModel.dataSource distance]) - self.LEFEET;
        if (xPos <= 30) {
            // Move the closeup view left
            self.LEFTEDGE = self.BIGXCT - 17;
            self.LEFEET = (self.LEFTEDGE * 32) - 22400;
            xPos = (short)([self.landerModel.dataSource distance]) - self.LEFEET;
            [self.moonView useCloseUpView:self.LEFTEDGE];
        }
        else if (xPos > 580) {
            // Move the closeup view right
            self.LEFTEDGE = self.BIGXCT - 1;
            self.LEFEET = (self.LEFTEDGE * 32) - 22400;
            xPos = (short)([self.landerModel.dataSource distance]) - self.LEFEET;
            [self.moonView useCloseUpView:self.LEFTEDGE];
        }
        self.SHOWX = (xPos * 3) / 2;
        
        // Index to terrain/feature to left of lander
        self.INDEXL = self.LEFTEDGE + (self.SHOWX / 48);
        self.INDEXLR = (self.SHOWX % 48);
        
        // Get the terrain information
        short thl = (short)([self.moonView.dataSource terrainHeight:self.INDEXL]) * (48 - self.INDEXLR);
        short thr = (short)([self.moonView.dataSource terrainHeight:(self.INDEXL+1)]) * self.INDEXLR;
        short th = (thl + thr) / 48;
        self.AVERY = th >> 2;
        self.AVERT = [self DFAKE:th];
        
        short RET2 = (((short)([self.landerModel.dataSource altitude]) * 3) / 2) + 23;
        self.SHOWY = RET2;
        self.SHOWY += 24;
        
        RET2 -= self.AVERT;
        self.RADARY = (RET2 * 2) / 3;
        
        [self INTEL];
        [self DUST];

        // Move the lander
        CGPoint newFrame = self.landerView.center;
        newFrame.x = self.SHOWX;
        newFrame.y = self.view.frame.size.width - self.SHOWY;
        self.landerView.center = newFrame;
    }
    else {
        // Make sure the view is displayed (we might have drifted up)
        [self.moonView useNormalView];
        
        self.RADARY = (short)([self.landerModel.dataSource altitude]) - (short)([self.moonView.dataSource terrainHeight:self.BIGXCT]);

        // Move the lander
        self.SHOWX = self.BIGXCT;
        self.SHOWY = ([self.landerModel.dataSource altitude] / 32) + 43;
        CGPoint newFrame = self.landerView.center;
        newFrame.x = self.SHOWX;
        newFrame.y = self.view.frame.size.width - self.SHOWY;
        self.landerView.center = newFrame;
    }
}

@end
