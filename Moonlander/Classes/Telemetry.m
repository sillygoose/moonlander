//
//  Telemetry.m
//  Moonlander
//
//  Created by Rick on 5/23/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import "Telemetry.h"


@implementation Telemetry

@synthesize format=_format;
@synthesize data=_data;

- (void)setData:(telemetry_data_t)codeBlock
{
    _data = codeBlock;
}

- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.titleLabel.vectorName = @"telemetry";
    }
    return self;
}

- (NSString *)name
{
    return self.titleLabel.text;
}


@end
