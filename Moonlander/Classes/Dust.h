//
//  Dust.h
//  Moonlander
//
//  Created by Rick on 6/14/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import "LanderDelegate.h"

#import "VGView.h"


@interface Dust : VGView {
    id <LanderDelegate> __unsafe_unretained     _delegate;
}

@property (unsafe_unretained) id <LanderDelegate> delegate;


- (id)init;
- (void)generateDust;

@end
