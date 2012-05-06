//
//  LanderViewController.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

#import "LanderDelegate.h"
#import "LanderPhysicsModel.h"

#import "VGView.h"
#import "VGButton.h"
#import "VGSlider.h"
#import "VGDialog.h"

#import "Moon.h"
#import "Lander.h"
#import "Dust.h"
#import "Man.h"
#import "Flag.h"
#import "Telemetry.h"
#import "Instrument.h"
#import "LanderMessage.h"
#import "Autopilot.h"

#import "ExplosionManager.h"

typedef enum {
    DelayZero,
    DelaySplashScreen,
    DelayLanding,
    DelayMoveMan,
    DelayOrderFood,
    DelayPickupFood,
    DelayTakeoff,
    DelayGameover,
    DelayNewGame,
    DelayFlagPlanted,
    DelayExplode,
    DelayOffcom,
    DelayLast
} MoonlanderDelay ;


@interface LanderViewController_iPad : UIViewController <LanderDelegate> {
    LanderPhysicsModel  *_landerModel;
    LanderType          _landerType;
    
    Moon                *_moonView;
    Lander              *_landerView;
    Dust                *_dustView;
    ExplosionManager    *_explosionManager;
    Man                 *_manView;
    Flag                *_flagView;
    
    float               _SHOWX;
    float               _SHOWY;
    float               _BIGXCT;
    short               _LEFTEDGE;
    short               _LEFEET;
    short               _INDEXL;
    short               _INDEXLR;
    short               _RADARY;
    short               _AVERY;
    short               _AVERT;
    
    clock_t             _lastTime;
    
    VGButton            *_smallLeftArrow;
    VGButton            *_smallRightArrow;
    VGButton            *_largeLeftArrow;
    VGButton            *_largeRightArrow;
    
    VGSlider            *_thrusterSlider;
    
    NSTimer             *__unsafe_unretained _landerModelTimer;
    NSTimer             *__unsafe_unretained _gameLogicTimer;
    NSTimer             *__unsafe_unretained _landerUpdateTimer;
    NSTimer             *__unsafe_unretained _positionUpdateTimer;
    NSTimer             *__unsafe_unretained _instrumentUpdateTimer;

    Telemetry           *_selectedTelemetry;
    Telemetry           *_heightData;
    Telemetry           *_altitudeData;
    Telemetry           *_distanceData;
    Telemetry           *_fuelLeftData;
    Telemetry           *_weightData;
    Telemetry           *_thrustData;
    Telemetry           *_thrustAngleData;
    Telemetry           *_verticalVelocityData;
    Telemetry           *_horizontalVelocityData;
    Telemetry           *_verticalAccelerationData;
    Telemetry           *_horizontalAccelerationData;
    Telemetry           *_secondsData;

    Instrument          *_instrument1;
    Instrument          *_instrument2;
    Instrument          *_instrument3;
    Instrument          *_instrument4;
    
    Instrument          *_instrument5;
    Instrument          *_instrument6;
    Instrument          *_instrument7;
    Instrument          *_instrument8;
    
    LanderMessages      *_landerMessages;
    
    VGDialog            *_anotherGameDialog;
    
    BOOL                _didFuelAlert;
    
	SystemSoundID       _beepSound;
    SystemSoundID       _explosionSound;
}

@property (nonatomic, strong) LanderPhysicsModel *landerModel;
@property (nonatomic) LanderType landerType;

@property (nonatomic, unsafe_unretained) NSTimer *landerModelTimer;
@property (nonatomic, unsafe_unretained) NSTimer *gameLogicTimer;
@property (nonatomic, unsafe_unretained) NSTimer *landerUpdateTimer;
@property (nonatomic, unsafe_unretained) NSTimer *positionUpdateTimer;
@property (nonatomic, unsafe_unretained) NSTimer *instrumentUpdateTimer;

@property (nonatomic) float SHOWX;
@property (nonatomic) float SHOWY;
@property (nonatomic) float BIGXCT;
@property (nonatomic) short LEFTEDGE;
@property (nonatomic) short LEFEET;
@property (nonatomic) short INDEXL;
@property (nonatomic) short INDEXLR;
@property (nonatomic) short RADARY;
@property (nonatomic) short AVERY;
@property (nonatomic) short AVERT;
@property (nonatomic) short DUSTX;

@property (nonatomic) clock_t lastTime;

@property (nonatomic, readonly) CGPoint LANDER;
@property (nonatomic) short VERDIS;
@property (nonatomic) short HORDIS;
@property (nonatomic) short PERTRS;
@property (nonatomic, readonly) float ANGLE;
@property (nonatomic) short ANGLED;
@property (nonatomic) short HORVEL;
@property (nonatomic) short VERVEL;
@property (nonatomic, readonly) short VERACC;
@property (nonatomic, readonly) short HORACC;
@property (nonatomic, readonly) short WEIGHT;
@property (nonatomic, readonly) short THRUST;
@property (nonatomic, readonly) float TIME;
@property (nonatomic, readonly) short FUEL;
@property (nonatomic, readonly) float GRAVITY;

@property (nonatomic, readonly) CGFloat gameFontSize;

@property (nonatomic, strong) Moon *moonView;
@property (nonatomic, strong) Lander *landerView;
@property (nonatomic, strong) Dust *dustView;
@property (nonatomic, strong) ExplosionManager *explosionManager;
@property (nonatomic, strong) Man *manView;
@property (nonatomic, strong) Flag *flagView;

@property (nonatomic, strong) VGButton *smallLeftArrow;
@property (nonatomic, strong) VGButton *smallRightArrow;
@property (nonatomic, strong) VGButton *largeLeftArrow;
@property (nonatomic, strong) VGButton *largeRightArrow;

@property (nonatomic, strong) VGSlider *thrusterSlider;

@property (nonatomic, strong) Telemetry *selectedTelemetry;
@property (nonatomic, strong) Telemetry *heightData;
@property (nonatomic, strong) Telemetry *altitudeData;
@property (nonatomic, strong) Telemetry *distanceData;
@property (nonatomic, strong) Telemetry *fuelLeftData;
@property (nonatomic, strong) Telemetry *weightData;
@property (nonatomic, strong) Telemetry *thrustData;
@property (nonatomic, strong) Telemetry *thrustAngleData;
@property (nonatomic, strong) Telemetry *verticalVelocityData;
@property (nonatomic, strong) Telemetry *horizontalVelocityData;
@property (nonatomic, strong) Telemetry *verticalAccelerationData;
@property (nonatomic, strong) Telemetry *horizontalAccelerationData;
@property (nonatomic, strong) Telemetry *secondsData;

@property (nonatomic, strong) Instrument *instrument1;
@property (nonatomic, strong) Instrument *instrument2;
@property (nonatomic, strong) Instrument *instrument3;
@property (nonatomic, strong) Instrument *instrument4;

@property (nonatomic, strong) Instrument *instrument5;
@property (nonatomic, strong) Instrument *instrument6;
@property (nonatomic, strong) Instrument *instrument7;
@property (nonatomic, strong) Instrument *instrument8;

@property (nonatomic, strong) LanderMessages *landerMessages;

@property (nonatomic, strong) VGDialog *anotherGameDialog;

@property (nonatomic) BOOL didFuelAlert;

@property (nonatomic) SystemSoundID beepSound;
@property (nonatomic) SystemSoundID explosionSound;


- (IBAction)thrusterChanged:(VGSlider *)sender;
- (IBAction)rotateLander:(id)sender;

- (void)enableFlightControls;
- (void)disableFlightControls;
- (void)enableRollFlightControls;
- (void)disableRollFlightControls;
- (void)enableThrustFlightControls;
- (void)disableThrustFlightControls;

- (void)loadTelemetryControls;
- (void)cleanupControls;

- (void)setupTimers;
- (void)cleanupTimers;

- (void)initGame;
- (void)initGame2;
- (void)getStarted;

- (float)getDelay:(MoonlanderDelay)item;


@end
