//
//  Instrument.m
//  Moonlander
//
//  Created by Silly Goose on 5/24/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "Instrument.h"


@implementation Instrument

@synthesize instrument=_instrument;


- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
    }
    return self;
}

- (void)display
{
    NSString *format = self.instrument.format;
    NSString *title = self.instrument.name;
    float datum = self.instrument.data();
    NSString *instrumentText = [NSString stringWithFormat:format, datum, title];
    self.titleLabel.text = instrumentText;
}

@end
