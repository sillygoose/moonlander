//
//  Telemetry.h
//  Moonlander
//
//  Created by Silly Goose on 5/23/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "VGButton.h"

typedef float (^telemetry_data_t)();

@interface Telemetry : VGButton {
    NSString            *_format;
    telemetry_data_t   _data;
}

@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) telemetry_data_t data;

- (id)initWithFrame:(CGRect)frameRect;

- (NSString *)name;

@end
