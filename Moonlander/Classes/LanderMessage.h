//
//  LanderMessage.h
//  Moonlander
//
//  Created by Rick on 5/23/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LanderDelegate.h"


@interface LanderMessages : UIView {
    NSDictionary            *_landerMessages;
    NSMutableDictionary     *_displayedMessages;
    
    BOOL                    _fuelWarningOn;
    
    id <LanderDelegate> __unsafe_unretained     _delegate;
}

@property (nonatomic) NSDictionary *landerMessages;
@property (nonatomic) NSMutableDictionary *displayedMessages;

@property (nonatomic) BOOL fuelWarningOn;

@property (unsafe_unretained) id <LanderDelegate> delegate;


- (id)init;

- (void)removeAllLanderMessages;

- (void)addSystemMessage:(NSString *)message;
- (void)removeSystemMessage:(NSString *)message;
- (NSString *)currentSystemMessage;

- (void)addFlameMessage:(NSString *)message;
- (void)removeFlameMessage:(NSString *)message;

- (void)addFuelMessage;
- (void)removeFuelMessage;

- (void)test;

@end
