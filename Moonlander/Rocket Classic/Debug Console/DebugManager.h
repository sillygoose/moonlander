//
//  DebugManager.h
//  Moonlander
//
//  Created by Rick Naro on 5/17/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Console.h"
#import "Controls.h"


@interface DebugManager : UIView
{
    Controls       *debugControls;
    Console        *debugConsole;
}

@property (nonatomic, strong) IBOutlet Controls *debugControls;
@property (nonatomic, strong) IBOutlet Console *debugConsole;


- (void)step:(NSString *)statement;
- (void)stepWait:(NSString *)statement;

@end
