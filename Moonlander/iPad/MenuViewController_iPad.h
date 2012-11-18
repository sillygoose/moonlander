//
//  MenuViewController_iPad.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systemse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AutoPilotViewController_iPad.h"


@interface MenuViewController_iPad : UIViewController
{
    AutoPilotViewController_iPad           *_menuBackground;
    UILabel                                *_buildInfo;
}

@property (nonatomic, strong) AutoPilotViewController_iPad *menuBackground;
@property (nonatomic, strong) IBOutlet UILabel *buildInfo;

@end
