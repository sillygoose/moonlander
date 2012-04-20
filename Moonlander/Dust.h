//
//  Dust.h
//  Moonlander
//
//  Created by Silly Goose on 6/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderDelegate.h"

#import "VGView.h"

@interface Dust : VGView {
    id <LanderDelegate> __unsafe_unretained   _delegate;
}

@property (unsafe_unretained) id <LanderDelegate> delegate;


- (id)init;
- (void)generateDust;

@end
