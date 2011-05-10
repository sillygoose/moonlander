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

// ###Put players in starting position
- (void)gameLoop
{
    NSLog(@"%f - Thrust: %f  Angle:%f", [self.landerModel.dataSource updateTime:GameTimerInterval], [self.landerModel.dataSource thrust], [self.landerModel.dataSource rotation]);
}

@end
