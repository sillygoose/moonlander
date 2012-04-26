//
//  VGView.h
//  Moonlander
//
//  Created by Rick on 5/14/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum { VGLineSolid = 0, VGLineLongDash, VGLineShortDash, VGLineDotDash } VGLineType;

typedef struct {
    float x;
    float y;
    float alpha;
} point_t;


@interface VGView : UIView {
    NSArray     *_drawPaths;
    NSString    *_vectorName;
  
    CGFloat     _fontSize;
    UIColor     *_viewColor;
    NSTimer     *__weak _blinkTimer;
    
    BOOL        _blinkOn;
    CGRect      _actualBounds;
}

@property (nonatomic) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic) CGFloat fontSize;
@property (nonatomic, strong) UIColor *viewColor;
@property (nonatomic, weak) NSTimer *blinkTimer;

@property (nonatomic) BOOL blinkOn;
@property (nonatomic) CGRect actualBounds;


- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;

@end
