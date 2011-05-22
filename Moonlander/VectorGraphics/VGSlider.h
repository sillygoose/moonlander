//
//  VGSlider.h
//  Moonlander
//
//  Created by Silly Goose on 5/15/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
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

@property (nonatomic, retain) VGView *thrusterSlider;
@property (nonatomic, retain) VGView *thrusterIndicator;
@property (nonatomic, retain) VGLabel *thrusterValue;

- (id)initWithFrame:(CGRect)frameRect;

@end
