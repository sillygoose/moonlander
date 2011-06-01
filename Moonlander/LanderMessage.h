//
//  LanderMessage.h
//  Moonlander
//
//  Created by Rick on 5/23/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGLabel.h"


@interface LanderMessage : VGLabel {
    
}

- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithMessage:(NSString *)msgName;

- (void)addMessage:(NSString *)message;

@end
