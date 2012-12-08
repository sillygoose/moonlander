//
//  TeletypePaper.m
//  ROCKET Classic
//
//  Created by Rick Naro on 6/4/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "TeletypePaper.h"


@interface TeletypePaper ()

@end

@implementation TeletypePaper

@synthesize printerOutput;


#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Scroll bottom to top so use the transform
        self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMake(1, 0, 0, -1, 0, 0));
    }
    return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
}

@end
