//
//  ExplosionManager.h
//  Moonlander
//
//  Created by Rick Naro on 4/16/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

#import "LanderDelegate.h"

#import "Explosion.h"
#import "VGView.h"


@interface ExplosionManager : NSObject
{
    NSMutableArray      *_explosionViews;
    UIView              *_parentView;

    void                (^_completionBlock)(void);
    
    short               _currentRadius;
    short               _radiusIncrement;
    dispatch_time_t     _queueDelay;
    
    id <LanderDelegate> __unsafe_unretained _delegate;
}

@property (atomic) NSMutableArray *explosionViews;
@property (nonatomic) UIView *parentView;

@property (nonatomic, copy) void (^completionBlock)(void);

@property (nonatomic) short currentRadius;
@property (nonatomic) short radiusIncrement;
@property (nonatomic) dispatch_time_t queueDelay;

@property (unsafe_unretained) id <LanderDelegate> delegate;


- (id)init;
- (void)start;

@end
