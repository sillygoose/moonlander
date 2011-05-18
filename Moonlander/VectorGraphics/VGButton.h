//
//  VGButtom.h
//  Moonlander
//
//  Created by Silly Goose on 5/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGKit.h"

@interface VGButton : UIControl {
    NSArray *_drawPaths;
    NSString *_vectorName;
    
    float _minX;
    float _minY;
    float _maxX;
    float _maxY;

    NSTimer *_repeatTimer;
    float _autoRepeatInterval;
}

@property (nonatomic, retain) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic) float minX;
@property (nonatomic) float minY;
@property (nonatomic) float maxX;
@property (nonatomic) float maxY;

@property (nonatomic, retain) NSTimer *repeatTimer;
@property (nonatomic) float autoRepeatInterval;

- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName andRepeat:(float)repeatInterval;

- (void)addPathFile:(NSString *)fileName; 

@end
