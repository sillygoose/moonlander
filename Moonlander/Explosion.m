//
//  Explosion.m
//  Moonlander
//
//  Created by Rick Naro on 4/14/12.
//  Copyright (c) 2012 Silly Goose Software. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

@synthesize radius=_radius;


- (id)initWithRadius:(short)radius
{
    CGRect frameRect = CGRectMake(0, 0, radius * 2, radius * 2);
    self = [super initWithFrame:frameRect];
    if (self) {
        self.radius = radius;
    }
    return self;
}

@end
