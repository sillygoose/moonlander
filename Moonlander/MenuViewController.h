//
//  MenuViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AutoPilotViewController.h"
#import "GameCenterManager.h"


@interface MenuViewController : UIViewController <GKGameCenterControllerDelegate, GameCenterManagerDelegate>
{
    AutoPilotViewController             *_menuBackground;
    UILabel                             *_buildInfo;

    GameCenterManager                   *_gameCenterManager;
}

@property (nonatomic, strong) AutoPilotViewController *menuBackground;
@property (nonatomic, strong) IBOutlet UILabel *buildInfo;

@property (nonatomic, strong) GameCenterManager *gameCenterManager;

@end
