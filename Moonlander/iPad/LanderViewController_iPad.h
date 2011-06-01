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

#import "Moon.h"
#import "Lander.h"
#import "Telemetry.h"
#import "Instrument.h"
#import "LanderMessage.h"


@interface LanderViewController_iPad : UIViewController {
    LanderPhysicsModel *_landerModel;
    
    Moon            *_moonView;
    Lander          *_landerView;
    
    float           _SHOWX;
    float           _SHOWY;
    
    VGButton        *_smallLeftArrow;
    VGButton        *_smallRightArrow;
    VGButton        *_largeLeftArrow;
    VGButton        *_largeRightArrow;
    
    VGSlider        *_thrusterSlider;
    
    NSTimer         *_simulationTimer;
    NSTimer         *_displayTimer;

    VGButton        *_newGameButton;
    
    Telemetry       *_selectedTelemetry;
    Telemetry       *_heightData;
    Telemetry       *_altitudeData;
    Telemetry       *_distanceData;
    Telemetry       *_fuelLeftData;
    Telemetry       *_weightData;
    Telemetry       *_thrustData;
    Telemetry       *_thrustAngleData;
    Telemetry       *_verticalVelocityData;
    Telemetry       *_horizontalVelocityData;
    Telemetry       *_verticalAccelerationData;
    Telemetry       *_horizontalAccelerationData;
    Telemetry       *_secondsData;

    Instrument      *_instrument1;
    Instrument      *_instrument2;
    Instrument      *_instrument3;
    Instrument      *_instrument4;
    
    Instrument      *_instrument5;
    Instrument      *_instrument6;
    Instrument      *_instrument7;
    Instrument      *_instrument8;
    
    LanderMessage   *_systemMessage;
}

@property (nonatomic, retain) LanderPhysicsModel *landerModel;

@property (nonatomic, assign) NSTimer *simulationTimer;
@property (nonatomic, assign) NSTimer *displayTimer;

@property (nonatomic) float SHOWX;
@property (nonatomic) float SHOWY;

@property (nonatomic, retain) Moon *moonView;
@property (nonatomic, retain) Lander *landerView;

@property (nonatomic, retain) VGButton *smallLeftArrow;
@property (nonatomic, retain) VGButton *smallRightArrow;
@property (nonatomic, retain) VGButton *largeLeftArrow;
@property (nonatomic, retain) VGButton *largeRightArrow;

@property (nonatomic, retain) VGSlider *thrusterSlider;

@property (nonatomic, retain) VGButton *newGameButton;

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

@property (nonatomic, retain) Instrument *instrument5;
@property (nonatomic, retain) Instrument *instrument6;
@property (nonatomic, retain) Instrument *instrument7;
@property (nonatomic, retain) Instrument *instrument8;

@property (nonatomic, retain) LanderMessage *systemMessage;


- (IBAction)thrusterChanged:(VGSlider *)sender;
- (IBAction)rotateLander:(id)sender;
- (IBAction)newGame:(id)sender;

- (void)gameReset;
- (void)updateLander;
- (void)gameLoop;
- (void)disableFlightControls;

@end
