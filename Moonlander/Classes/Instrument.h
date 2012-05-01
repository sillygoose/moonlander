//
//  Instrument.h
//  Moonlander
//
//  Created by Rick on 5/24/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGButton.h"
#import "Telemetry.h"

@interface Instrument : VGButton {
    Telemetry *_instrument;
}

@property (nonatomic) Telemetry *instrument;


- (id)initWithFrame:(CGRect)frameRect;

- (void)display;

@end
