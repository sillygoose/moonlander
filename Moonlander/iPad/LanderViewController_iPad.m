//
//  LanderViewController.m
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderViewController_iPad.h"


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
    // Create the lander
    NSString *landerPath = [[NSBundle mainBundle] pathForResource:@"Lander" ofType:@"plist"];
    self.landerView = [[[VGView alloc] initWithFrame:CGRectMake(200, 200, 96, 96)] retain];
    [self.landerView addPathFile:landerPath]; 
    [self.view addSubview:self.landerView];

    // Create the roll control arrows
    NSString *slaPath = [[NSBundle mainBundle] pathForResource:@"SmallLeftArrow" ofType:@"plist"];
    self.smallLeftArrow = [[[VGButton alloc] initWithFrame:CGRectMake(500, 400, 24, 24) withPaths:slaPath andRepeat:0.5f] retain];
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
    NSString *tcPath = [[NSBundle mainBundle] pathForResource:@"ThrusterControl" ofType:@"plist"];
    assert(tcPath != nil);
    self.thrusterSlider = [[[VGSlider alloc] initWithFrame:CGRectMake(400, 50, 200, 200) withPaths:tcPath] retain];
	[self.thrusterSlider addTarget:self 
                            action:@selector(thrusterChanged:) 
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.thrusterSlider];

    
    
    
    [self.landerModel.delegate newGame];
    
    // Setup controls with model defaults
    self.thrusterSlider.value = [self.landerModel.dataSource thrustPercent];
        
    // Place the lander in position
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
    self.landerModel = [[[LanderPhysicsModel alloc] init] retain];
    self.landerModel.dataSource = self.landerModel;
    self.landerModel.delegate = self.landerModel;
    [self initGame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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
    
	CGAffineTransform t = [self.landerView transform];
	t = CGAffineTransformRotate(t, deltaAngle);
	[self.landerView setTransform:t];
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
    [self.thrusterSlider setValue:[self.landerModel.dataSource thrustPercent]];
    //NSLog(@"%3.2f - Thrust: %5.0f  Altitude: %5.0f  Downrange: %5.0f  Angle:%2.0f  Weight:%5.0f  Fuel:%4.0f  HorizVel: %5.0f  VertVel: %5.0f  Accel: %5.3f  HorizAccel: %5.3f  VertAccel: %5.3f", [self.landerModel.dataSource time], [self.landerModel.dataSource thrust], [self.landerModel.dataSource altitude], [self.landerModel.dataSource range], [self.landerModel.dataSource rotationDegrees], [self.landerModel.dataSource weight], [self.landerModel.dataSource fuel], [self.landerModel.dataSource horizVel], [self.landerModel.dataSource vertVel], [self.landerModel.dataSource acceleration], [self.landerModel.dataSource horizAccel], [self.landerModel.dataSource vertAccel]);
    
    if ([self.landerModel.dataSource altitude] == 0.0f) {
        [self.thrusterSlider setValue:[self.landerModel.dataSource thrustPercent]];
        [self disableFlightControls];
        [self.simulationTimer invalidate];
        [self.displayTimer invalidate];
        [self updateLander];
    }
}

@end
