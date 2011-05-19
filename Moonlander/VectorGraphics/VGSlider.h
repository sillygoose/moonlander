//
//  VGSlider.h
//  Moonlander
//
//  Created by Silly Goose on 5/15/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGView.h"

@interface VGSlider : UIControl {
    NSArray *_drawPaths;

    NSString *_vectorName;
    
    CGRect _actualBounds;

    float _value;
    VGView *_thrusterIndicator;
}

@property (nonatomic, retain) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic) CGRect actualBounds;

@property (nonatomic) float value;
@property (nonatomic, retain) VGView *thrusterIndicator;

- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;

@end
