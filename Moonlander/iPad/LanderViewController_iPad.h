//
//  LanderViewController.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
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

#import "ExplosionManager.h"

#if defined(TARGET_IPHONE_SIMULATOR)
#define SHORT_DELAYS
#define NO_SPLASH_SCREEN
#endif


@interface LanderViewController_iPad : UIViewController <LanderDelegate> {
    LanderPhysicsModel *_landerModel;
    
    Moon                *_moonView;
    Lander              *_landerView;
    Dust                *_dustView;
    ExplosionManager    *_explosionManager;
    Man                 *_manView;
    Flag                *_flagView;
    
    short               _SHOWX;
    short               _SHOWY;
    short               _BIGXCT;
    short               _LEFTEDGE;
    short               _LEFEET;
    short               _INDEXL;
    short               _INDEXLR;
    short               _RADARY;
    short               _AVERY;
    short               _AVERT;
    
    VGButton            *_smallLeftArrow;
    VGButton            *_smallRightArrow;
    VGButton            *_largeLeftArrow;
    VGButton            *_largeRightArrow;
    
    VGSlider            *_thrusterSlider;
    
    NSTimer             *__unsafe_unretained _simulationTimer;
    NSTimer             *__unsafe_unretained _displayTimer;

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
    
    CFURLRef            _bellFileURL;
	SystemSoundID       _bellFileObject;
}

@property (nonatomic, strong) LanderPhysicsModel *landerModel;

@property (nonatomic, unsafe_unretained) NSTimer *simulationTimer;
@property (nonatomic, unsafe_unretained) NSTimer *displayTimer;

@property (nonatomic) short SHOWX;
@property (nonatomic) short SHOWY;
@property (nonatomic) short BIGXCT;
@property (nonatomic) short LEFTEDGE;
@property (nonatomic) short LEFEET;
@property (nonatomic) short INDEXL;
@property (nonatomic) short INDEXLR;
@property (nonatomic) short RADARY;
@property (nonatomic) short AVERY;
@property (nonatomic) short AVERT;
@property (nonatomic) short DUSTX;

@property (nonatomic, readonly) CGPoint LANDER;
@property (nonatomic) short VERDIS;
@property (nonatomic) short HORDIS;
@property (nonatomic, readonly) short PERTRS;
@property (nonatomic, readonly) float ANGLE;
@property (nonatomic) short ANGLED;
@property (nonatomic) short HORVEL;
@property (nonatomic) short VERVEL;
@property (nonatomic, readonly) short VERACC;
@property (nonatomic, readonly) short HORACC;
@property (nonatomic, readonly) short WEIGHT;
@property (nonatomic, readonly) short THRUST;
@property (nonatomic, readonly) short TIME;
@property (nonatomic) short FUEL;

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

@property (nonatomic) CFURLRef bellFileURL;
@property (nonatomic) SystemSoundID bellFileObject;


- (IBAction)thrusterChanged:(VGSlider *)sender;
- (IBAction)rotateLander:(id)sender;

- (void)updateLander;
- (void)gameLoop;

@end
