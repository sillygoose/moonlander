//
//  Telemetry.h
//  Moonlander
//
//  Created by Rick on 5/23/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGButton.h"


typedef short (^telemetry_data_t)();

@interface Telemetry : VGButton {
    NSString                        *_format;
    telemetry_data_t                _data;
}

@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) telemetry_data_t data;


- (id)initWithFrame:(CGRect)frameRect;

- (NSString *)name;

@end
