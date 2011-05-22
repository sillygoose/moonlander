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
    NSArray     *_drawPaths;
    NSString    *_vectorName;
    
    CGRect      _actualBounds;

    float       _value;
    
    VGView      *_thrusterSlider;
    VGView      *_thrusterIndicator;
    VGLabel     *_thrusterValue;
}

@property (nonatomic, retain) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic) CGRect actualBounds;

@property (nonatomic) float value;

@property (nonatomic, retain) VGView *thrusterSlider;
@property (nonatomic, retain) VGView *thrusterIndicator;
@property (nonatomic, retain) VGLabel *thrusterValue;

- (id)initWithFrame:(CGRect)frameRect;
//- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;

@end
