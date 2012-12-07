//
//  TeletypeOutputBackground.m
//  ROCKET Classic
//
//  Created by Rick Naro on 6/4/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "TeletypeOutputBackground.h"

@implementation TeletypeOutputBackground

@synthesize background;


#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Background
        UIImage *paper = [UIImage imageNamed:@"paper.png"];
        UIImage *paperTiled = [paper resizableImageWithCapInsets:UIEdgeInsetsZero];
        self.background = [[UIImageView alloc] initWithFrame:CGRectMake(-10, -10, paper.size.width * 1, paper.size.height * 5)];
        self.background.image = paperTiled;
        self.background.opaque = NO;
        [self addSubview:self.background];
        [self sendSubviewToBack:self.background];
    }
    return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    self.background = nil;
}

@end
