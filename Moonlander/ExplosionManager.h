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
    NSMutableArray      *_explosionViews;
    UIView              *_parentView;
    
    dispatch_queue_t    _dispatchQueue;
    void                (^_completionBlock)(void);
    
    CGPoint             _groundZero;
    short               _currentRadius;
    short               _radiusIncrement;
    dispatch_time_t     _queueDelay;
}

@property (atomic, strong) NSMutableArray *explosionViews;
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic) dispatch_queue_t dispatchQueue;
@property (nonatomic, copy) void (^completionBlock)(void);

@property (nonatomic) CGPoint groundZero;
@property (nonatomic) short currentRadius;
@property (nonatomic) short radiusIncrement;
@property (nonatomic) dispatch_time_t queueDelay;


- (id)init;
- (void)start;

@end
