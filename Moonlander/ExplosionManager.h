//
//  ExplosionManager.h
//  Moonlander
//
//  Created by Rick Naro on 4/16/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanderDelegate.h"

#import "Explosion.h"
#import "VGView.h"


@interface ExplosionManager : NSObject
{
    NSMutableArray      *_explosionViews;
    UIView              *_parentView;
    
    dispatch_queue_t    _dispatchQueue;
    void                (^_completionBlock)(void);
    
    short               _currentRadius;
    short               _radiusIncrement;
    dispatch_time_t     _queueDelay;
    short               _beepCount;
    
    id <LanderDelegate> __unsafe_unretained   _delegate;
}

@property (atomic, strong) NSMutableArray *explosionViews;
@property (nonatomic, strong) UIView *parentView;

@property (nonatomic) dispatch_queue_t dispatchQueue;
@property (nonatomic, copy) void (^completionBlock)(void);

@property (nonatomic) short currentRadius;
@property (nonatomic) short radiusIncrement;
@property (nonatomic) dispatch_time_t queueDelay;
@property (nonatomic) short beepCount;

@property (unsafe_unretained) id <LanderDelegate> delegate;


- (id)init;
- (void)start;

@end
