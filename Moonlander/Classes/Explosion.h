//
//  Explosion.h
//  Moonlander
//
//  Created by Rick Naro on 4/14/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "VGView.h"

@interface Explosion : VGView
{
}

- (id)initWithFrame:(CGRect)rect;

- (void)EXGEN:(short)radius;

@end
