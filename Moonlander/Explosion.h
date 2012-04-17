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
    short               _radius;
    short               _intensity;
}

@property (nonatomic) short radius;
@property (nonatomic) short intensity;

- (id)initWithRadius:(short)radius ;

@end
