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

    UISlider *_thrustSlider;
    UIButton *_newGameButton;
    
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

@property (nonatomic, retain) NSTimer *simulationTimer;
@property (nonatomic, retain) NSTimer *displayTimer;

@property (nonatomic, retain) VGView *landerView;

@property (nonatomic, retain) VGButton *smallLeftArrow;
@property (nonatomic, retain) VGButton *smallRightArrow;
@property (nonatomic, retain) VGButton *largeLeftArrow;
@property (nonatomic, retain) VGButton *largeRightArrow;
@property (nonatomic, retain) VGSlider *thrusterSlider;

@property (nonatomic, retain) IBOutlet UISlider *thrustSlider;
@property (nonatomic, retain) IBOutlet UIButton *newGameButton;

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

- (IBAction)thrustChanged:(UISlider *)sender;
- (IBAction)rotateLeft;
- (IBAction)rotateRight;
- (IBAction)newGame;

- (void)gameReset;
- (void)updateLander;
- (void)gameLoop;

@end
