//
//  LanderDelegate.h
//  Moonlander
//
//  Created by Rick Naro on 4/19/12.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LanderDelegate <NSObject>

- (float)SHOWX;
- (float)SHOWY;
- (short)AVERT;

- (short)RADARY;

- (short)PERTRS;
- (short)THRUST;
- (short)MAXTHRUST;
- (float)ANGLE;
- (short)ANGLED;

- (void)beep;
- (void)explosion;

- (BOOL)enhancedGame;
- (CGFloat)gameFontSize;

@end
