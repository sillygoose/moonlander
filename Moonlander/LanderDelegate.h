//
//  LanderDelegate.h
//  Moonlander
//
//  Created by Rick Naro on 4/19/12.
//  Copyright 2012 Rick Naro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    LanderTypeClassic,
    LanderTypeModern
} LanderType ;


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

- (LanderType)landerType;
- (CGFloat)gameFontSize;

@end
