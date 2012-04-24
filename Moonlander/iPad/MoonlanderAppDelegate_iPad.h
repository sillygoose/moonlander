//
//  MoonlanderAppDelegate_iPad.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoonlanderAppDelegate.h"

#import "LanderViewController_iPad.h"

@interface MoonlanderAppDelegate_iPad : MoonlanderAppDelegate {
    LanderViewController_iPad *_landerViewController;
}

@property (nonatomic, strong) IBOutlet LanderViewController_iPad *landerViewController;

@end
