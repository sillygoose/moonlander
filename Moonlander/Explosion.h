//
//  Explosion.h
//  Moonlander
//
//  Created by Rick Naro on 4/14/12.
//  Copyright (c) 2012 Silly Goose Software. All rights reserved.
//

#import "VGView.h"

@interface Explosion : UIView
{
    short                   _radius;
    NSMutableArray          *_dustPoints;
}

@property (nonatomic) short radius;
@property (atomic) NSMutableArray *dustPoints;

- (id)initWithFrame:(CGRect)rect;

- (void)EXGEN;

@end
