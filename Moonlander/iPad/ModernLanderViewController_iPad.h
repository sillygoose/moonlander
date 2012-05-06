//
//  ModernLanderViewController_iPad.h
//  Moonlander
//
//  Created by Rick Naro on 5/5/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "LanderViewController_iPad.h"

@interface ModernLanderViewController_iPad : LanderViewController_iPad
{
    Autopilot           *_autoPilot;
    VGButton            *_autoPilotSwitch;
    NSTimer             *__unsafe_unretained _autoPilotTimer;
}

@property (nonatomic, strong) Autopilot *autoPilot;
@property (nonatomic, strong) VGButton *autoPilotSwitch;
@property (nonatomic, unsafe_unretained) NSTimer *autoPilotTimer;

@end
