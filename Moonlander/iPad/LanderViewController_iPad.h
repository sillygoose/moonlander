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

#import "Lander.h"
#import "Telemetry.h"
#import "Instrument.h"


@interface LanderViewController_iPad : UIViewController {
    LanderPhysicsModel *_landerModel;
    
    Lander *_landerView;
    
    VGButton *_smallLeftArrow;
    VGButton *_smallRightArrow;
    VGButton *_largeLeftArrow;
    VGButton *_largeRightArrow;
    
    VGSlider *_thrusterSlider;
    
    NSTimer *_simulationTimer;
    NSTimer *_displayTimer;

    UIButton *_newGameButton;
    Telemetry *_selectedTelemetry;
    
    Telemetry *_heightData;
    Telemetry *_altitudeData;
    Telemetry *_distanceData;
    Telemetry *_fuelLeftData;
    Telemetry *_weightData;
    Telemetry *_thrustData;
    Telemetry *_thrustAngleData;
    Telemetry *_verticalVelocityData;
    Telemetry *_horizontalVelocityData;
    Telemetry *_verticalAccelerationData;
    Telemetry *_horizontalAccelerationData;
    Telemetry *_secondsData;

    Instrument *_instrument1;
    Instrument *_instrument2;
    Instrument *_instrument3;
    Instrument *_instrument4;

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

@property (nonatomic, retain) Lander *landerView;

@property (nonatomic, retain) VGButton *smallLeftArrow;
@property (nonatomic, retain) VGButton *smallRightArrow;
@property (nonatomic, retain) VGButton *largeLeftArrow;
@property (nonatomic, retain) VGButton *largeRightArrow;

@property (nonatomic, retain) VGSlider *thrusterSlider;

@property (nonatomic, retain) IBOutlet UIButton *newGameButton;
@property (nonatomic, retain) Telemetry *selectedTelemetry;

@property (nonatomic, retain) Telemetry *heightData;
@property (nonatomic, retain) Telemetry *altitudeData;
@property (nonatomic, retain) Telemetry *distanceData;
@property (nonatomic, retain) Telemetry *fuelLeftData;
@property (nonatomic, retain) Telemetry *weightData;
@property (nonatomic, retain) Telemetry *thrustData;
@property (nonatomic, retain) Telemetry *thrustAngleData;
@property (nonatomic, retain) Telemetry *verticalVelocityData;
@property (nonatomic, retain) Telemetry *horizontalVelocityData;
@property (nonatomic, retain) Telemetry *verticalAccelerationData;
@property (nonatomic, retain) Telemetry *horizontalAccelerationData;
@property (nonatomic, retain) Telemetry *secondsData;

@property (nonatomic, retain) Instrument *instrument1;
@property (nonatomic, retain) Instrument *instrument2;
@property (nonatomic, retain) Instrument *instrument3;
@property (nonatomic, retain) Instrument *instrument4;

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
