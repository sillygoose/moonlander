//
//  ExplosionManager.h
//  Moonlander
//
//  Created by Rick Naro on 4/16/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Explosion.h"
#import "VGView.h"


@interface ExplosionManager : NSObject
{
    NSArray             *_explosionViews;
    NSTimer             *__unsafe_unretained _explosionTimer;
    NSTimer             *__unsafe_unretained _phosphorTimer;
    UIView              *_parentView;
    
    CGPoint             _groundZero;
    short               _currentRadius;
    short               _radiusIncrement;
}

@property (atomic, strong) NSArray *explosionViews;
@property (nonatomic, unsafe_unretained) NSTimer *explosionTimer;
@property (nonatomic, unsafe_unretained) NSTimer *phosphorTimer;
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic) CGPoint groundZero;
@property (nonatomic) short currentRadius;
@property (nonatomic) short radiusIncrement;


- (id)initWithView:(UIView *)view atPoint:(CGPoint)gz;

- (BOOL)explosionComplete;

@end
