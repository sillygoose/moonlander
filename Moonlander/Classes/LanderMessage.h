//
//  LanderMessage.h
//  Moonlander
//
//  Created by Rick on 5/23/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LanderMessages : UIView {
    NSDictionary            *_landerMessages;
    NSMutableDictionary     *_displayedMessages;
    
    BOOL                    _fuelWarningOn;
}

@property (nonatomic) NSDictionary *landerMessages;
@property (nonatomic) NSMutableDictionary *displayedMessages;

@property (nonatomic) BOOL fuelWarningOn;


- (id)init;

- (void)removeAllLanderMessages;

- (void)addSystemMessage:(NSString *)message;
- (void)removeSystemMessage:(NSString *)message;
- (NSString *)currentSystemMessage;

- (void)addFlameMessage:(NSString *)message;
- (void)removeFlameMessage:(NSString *)message;

- (void)addFuelMessage;
- (void)removeFuelMessage;

@end
