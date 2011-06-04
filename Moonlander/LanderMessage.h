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
}

@property (nonatomic, retain) NSDictionary *landerMessages;
@property (nonatomic, retain) NSMutableDictionary *displayedMessages;

- (id)init;
- (void)addLanderMessage:(NSString *)msgName;
- (void)removeLanderMessage:(NSString *)message;
- (void)removeAllLanderMessages;

@end
