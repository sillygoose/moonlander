//
//  LanderViewController.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LanderPhysicsModel.h"


@interface LanderViewController_iPad : UIViewController {
    LanderPhysicsModel *_landerModel;
    UIImageView *_landerImageView;
    
    NSTimer *_simulationTimer;
    NSTimer *_displayTimer;

    UISlider *_thrustSlider;
    UIButton *_rotateLeftButton;
    UIButton *_rotateRightButton;
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

@property (nonatomic, retain) IBOutlet UIImageView *landerImageView;

@property (nonatomic, retain) IBOutlet UISlider *thrustSlider;
@property (nonatomic, retain) IBOutlet UIButton *rotateLeftButton;
@property (nonatomic, retain) IBOutlet UIButton *rotateRightButton;
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
