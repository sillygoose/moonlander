//
//  VGSlider.h
//  Moonlander
//
//  Created by Rick on 5/15/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGView.h"
#import "VGLabel.h"

@interface VGSlider : UIControl {
    CGRect      _actualBounds;

    float       _value;
    
    VGView      *_thrusterSlider;
    VGView      *_thrusterIndicator;
    VGLabel     *_thrusterValue;
}

@property (nonatomic) CGRect actualBounds;

@property (nonatomic) float value;

@property (nonatomic, strong) VGView *thrusterSlider;
@property (nonatomic, strong) VGView *thrusterIndicator;
@property (nonatomic, strong) VGLabel *thrusterValue;

- (id)initWithFrame:(CGRect)frameRect;

@end
