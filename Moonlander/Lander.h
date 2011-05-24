//
//  Lander.h
//  Moonlander
//
//  Created by Rick on 5/24/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGView.h"

@interface Lander : VGView {
    VGView      *_thrust;
}

@property (nonatomic, retain) VGView *thrust;

- (id)init;

@end
