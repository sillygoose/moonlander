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
    
    CGRect _actualBounds;

    NSTimer *_repeatTimer;
    float _autoRepeatInterval;
}

@property (nonatomic, retain) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic) CGRect actualBounds;

@property (nonatomic, retain) NSTimer *repeatTimer;
@property (nonatomic) float autoRepeatInterval;

- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName andRepeat:(float)repeatInterval;

- (void)addPathFile:(NSString *)fileName; 

@end
