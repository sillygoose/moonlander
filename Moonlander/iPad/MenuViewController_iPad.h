//
//  MenuViewController_iPad.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LanderViewController_iPad.h"


@interface MenuViewController_iPad : UIViewController
{
    LanderViewController_iPad           *_menuBackground;
}

@property (nonatomic, strong) LanderViewController_iPad *menuBackground;


@end
