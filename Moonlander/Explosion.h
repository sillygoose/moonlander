//
//  Explosion.h
//  Moonlander
//
//  Created by Rick Naro on 4/14/12.
//  Copyright (c) 2012 Silly Goose Software. All rights reserved.
//

#import "VGView.h"

@interface Explosion : VGView
{
    short                   _radius;
}

@property (nonatomic) short radius;

- (id)initWithFrame:(CGRect)rect;

- (void)EXGEN;

@end
