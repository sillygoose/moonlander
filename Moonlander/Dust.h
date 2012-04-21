//
//  Dust.h
//  Moonlander
//
//  Created by Silly Goose on 6/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderDelegate.h"

#import "VGView.h"

@interface Dust : UIView {
    id <LanderDelegate> __unsafe_unretained   _delegate;
    
    NSMutableArray             *_dustPoints;
}

@property (unsafe_unretained) id <LanderDelegate> delegate;

@property (nonatomic) NSMutableArray *dustPoints;

- (id)init;
- (void)generateDust;

@end
