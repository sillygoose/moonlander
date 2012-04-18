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
    NSTimer             *__unsafe_unretained _phosphorTimer;
    UIView              *_parentView;
    
    dispatch_queue_t    _dispatchQueue;
    short               _tasks;
    void                (^_completionBlock)(void);
    
    CGPoint             _groundZero;
    short               _currentRadius;
    short               _radiusIncrement;
    time_t              _queueDelay;
}

@property (atomic, strong) NSArray *explosionViews;
@property (nonatomic, unsafe_unretained) NSTimer *phosphorTimer;
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic) dispatch_queue_t dispatchQueue;
@property (nonatomic) short tasks;
@property (nonatomic, copy) void (^completionBlock)(void);

@property (nonatomic) CGPoint groundZero;
@property (nonatomic) short currentRadius;
@property (nonatomic) short radiusIncrement;
@property (nonatomic) time_t queueDelay;


- (id)init;
- (void)start;

@end
