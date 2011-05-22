//
//  LanderViewController.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LanderPhysicsModel.h"

#import "VGView.h"
#import "VGButton.h"
#import "VGSlider.h"


@interface LanderViewController_iPad : UIViewController {
    LanderPhysicsModel *_landerModel;
    
    VGView *_landerView;
    
    VGButton *_smallLeftArrow;
    VGButton *_smallRightArrow;
    VGButton *_largeLeftArrow;
    VGButton *_largeRightArrow;
    
    VGSlider *_thrusterSlider;
    
    NSTimer *_simulationTimer;
    NSTimer *_displayTimer;

    UIButton *_newGameButton;
    
    VGButton *_heightLabel;
    VGButton *_verticalDistanceLabel;
    VGButton *_distanceLabel;
    VGButton *_fuelLeftLabel;
    VGButton *_weightLabel;
    VGButton *_thrustProducedLabel;
    VGButton *_thrustAngleLabel;
    VGButton *_verticalVelocityLabel;
    VGButton *_horizontalVelocityLabel;
    VGButton *_verticalAccelerationLabel;
    VGButton *_horizontalAccelerationLabel;
    VGButton *_secondslLabel;

    VGLabel *_user1Label;
    VGLabel *_user2Label;
    VGLabel *_user3Label;
    VGLabel *_user4Label;

    UILabel *_timeLabel;
    UILabel *_angleLabel;
    UILabel *_thrustLabel;
    UILabel *_altitudeLabel;
    UILabel *_downrangeLabel;
    UILabel *_vertVelLabel;
    UILabel *_horizVelLabel;
    UILabel *_vertAccelLabel;
    UILabel *_horizAccelLabel;
    UILabel *_fuelRemainingLabel;
}

@property (nonatomic, retain) LanderPhysicsModel *landerModel;

@property (nonatomic, assign) NSTimer *simulationTimer;
@property (nonatomic, assign) NSTimer *displayTimer;

@property (nonatomic, retain) VGView *landerView;

@property (nonatomic, retain) VGButton *smallLeftArrow;
@property (nonatomic, retain) VGButton *smallRightArrow;
@property (nonatomic, retain) VGButton *largeLeftArrow;
@property (nonatomic, retain) VGButton *largeRightArrow;

@property (nonatomic, retain) VGSlider *thrusterSlider;

@property (nonatomic, retain) IBOutlet UIButton *newGameButton;

@property (nonatomic, retain) VGButton *heightLabel;
@property (nonatomic, retain) VGButton *verticalDistanceLabel;
@property (nonatomic, retain) VGButton *distanceLabel;
@property (nonatomic, retain) VGButton *fuelLeftLabel;
@property (nonatomic, retain) VGButton *weightLabel;
@property (nonatomic, retain) VGButton *thrustProducedLabel;
@property (nonatomic, retain) VGButton *thrustAngleLabel;
@property (nonatomic, retain) VGButton *verticalVelocityLabel;
@property (nonatomic, retain) VGButton *horizontalVelocityLabel;
@property (nonatomic, retain) VGButton *verticalAccelerationLabel;
@property (nonatomic, retain) VGButton *horizontalAccelerationLabel;
@property (nonatomic, retain) VGButton *secondslLabel;

@property (nonatomic, retain) VGLabel *user1Label;
@property (nonatomic, retain) VGLabel *user2Label;
@property (nonatomic, retain) VGLabel *user3Label;
@property (nonatomic, retain) VGLabel *user4Label;

@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *angleLabel;
@property (nonatomic, retain) IBOutlet UILabel *thrustLabel;
@property (nonatomic, retain) IBOutlet UILabel *altitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *downrangeLabel;
@property (nonatomic, retain) IBOutlet UILabel *vertVelLabel;
@property (nonatomic, retain) IBOutlet UILabel *horizVelLabel;
@property (nonatomic, retain) IBOutlet UILabel *vertAccelLabel;
@property (nonatomic, retain) IBOutlet UILabel *horizAccelLabel;
@property (nonatomic, retain) IBOutlet UILabel *fuelRemainingLabel;

- (IBAction)thrusterChanged:(VGSlider *)sender;
- (IBAction)rotateLander:(id)sender;
- (IBAction)newGame;

- (void)gameReset;
- (void)updateLander;
- (void)gameLoop;
- (void)disableFlightControls;

@end
