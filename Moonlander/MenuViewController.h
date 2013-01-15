//
//  MenuViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameCenterManager.h"


@interface MenuViewController : UIViewController <GKLeaderboardViewControllerDelegate, GameCenterManagerDelegate>
{
    GameCenterManager       *gameCenterManager;
}

@property (nonatomic, strong) GameCenterManager *gameCenterManager;

@end
