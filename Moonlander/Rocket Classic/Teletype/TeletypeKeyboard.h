//
//  TeletypeKeyboard.h
//  ROCKET Classic
//
//  Created by Rick Naro on 5/11/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "Keycodes.h"


@interface TeletypeKeyboard : UIView
{
}

- (keycode_t)getKey;

- (void)enableKeyboard;
- (void)disableKeyboard;

@end
