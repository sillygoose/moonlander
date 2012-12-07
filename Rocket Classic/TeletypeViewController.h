//
//  ROCKETViewController.h
//  ROCKET Classic
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Teletype.h"
#import "DebugManager.h"


@interface TeletypeViewController : UIViewController
{
    Teletype                *teletype;
    DebugManager            *debugger;
}

@property (nonatomic, strong) IBOutlet Teletype *teletype;
@property (nonatomic, strong) IBOutlet DebugManager *debugger;

@end

