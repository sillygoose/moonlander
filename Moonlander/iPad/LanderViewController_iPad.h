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
    UISlider *_thrustLevel;
}

@property (nonatomic, retain) LanderPhysicsModel *landerModel;
@property (nonatomic, retain) IBOutlet UIImageView *landerImageView;
@property (nonatomic, retain) IBOutlet UISlider *thrustLevel;

- (void)gameReset;
- (void)updateLander;
- (void)gameLoop;

@end
