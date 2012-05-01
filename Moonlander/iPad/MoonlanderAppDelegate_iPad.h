//
//  MoonlanderAppDelegate_iPad.h
//  Moonlander
//
//  Created by Rick on 5/10/11.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoonlanderAppDelegate.h"

#import "NavigationController_iPad.h"
#import "MenuViewController_iPad.h"
#import "LanderViewController_iPad.h"
#import "DocumentViewController.h"


@interface MoonlanderAppDelegate_iPad : MoonlanderAppDelegate {
    NavigationController_iPad       *_iPadNavagationController;
    MenuViewController_iPad         *_menuViewController;
    LanderViewController_iPad       *_landerViewController;
    DocumentViewController          *_documentViewController;
}

@property (nonatomic, strong) IBOutlet NavigationController_iPad *iPadNavagationController;
@property (nonatomic, strong) IBOutlet MenuViewController_iPad *menuViewController;
@property (nonatomic, strong) IBOutlet LanderViewController_iPad *landerViewController;
@property (nonatomic, strong) IBOutlet DocumentViewController *documentViewController;

@end
