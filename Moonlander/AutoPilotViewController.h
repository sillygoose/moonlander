//
//  AutoPilotViewController.h
//  Moonlander
//
//  Created by Rick Naro on 5/5/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "LanderViewController.h"

@interface AutoPilotViewController : LanderViewController
{
    Autopilot           *_backgroundAutoPilot;
    NSTimer             *__unsafe_unretained _backgroundAutoPilotTimer;
}

@property (nonatomic, strong) Autopilot *backgroundAutoPilot;
@property (nonatomic, unsafe_unretained) NSTimer *backgroundAutoPilotTimer;

- (BOOL)WallpaperController;

@end
