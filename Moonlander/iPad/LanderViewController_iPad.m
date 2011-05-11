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
@synthesize landerImageView=_landerImageView;
@synthesize thrustLevel=_thrustLevel;

const float GameTimerInterval = 2.0f;

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
    [_landerImageView release];
    [_thrustLevel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.landerModel = [[[LanderPhysicsModel alloc] init] retain];
    self.landerModel.dataSource = self.landerModel;
    
    // Setup controls with model defaults
    self.thrustLevel.value = [self.landerModel.dataSource thrustPercent];
    
    
    // Do any additional setup after loading the view from its nib
	[NSTimer scheduledTimerWithTimeInterval:GameTimerInterval target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
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

// ###Put players in starting position
- (void)gameReset
{
}

// ###rotate and move the tanks towards their destinations if need be
- (void)updateLander
{
}

- (void)gameLoop
{
    [self.landerModel.dataSource updateTime:GameTimerInterval];
    NSLog(@"%3.0f - Thrust: %5.0f  Angle:%2.0f  Weight:%5.0f  Fuel:%4.0f  HorizVel: %5.0f  VertVel: %5.0f  HorizAccel: %5.3f  VertAccel: %5.3f", [self.landerModel.dataSource time], [self.landerModel.dataSource thrust], [self.landerModel.dataSource rotationDegrees], [self.landerModel.dataSource weight], [self.landerModel.dataSource fuel], [self.landerModel.dataSource horizVel], [self.landerModel.dataSource vertVel], [self.landerModel.dataSource horizAccel], [self.landerModel.dataSource vertAccel]);
}

@end
