//
//  MoonlanderMenuViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuViewController.h"
#import "AutoPilotViewController.h"


@interface MoonlanderMenuViewController : MenuViewController
{
    AutoPilotViewController                *_menuBackground;
    UILabel                                *_buildInfo;
}

@property (nonatomic, strong) AutoPilotViewController *menuBackground;
@property (nonatomic, strong) IBOutlet UILabel *buildInfo;

@end
