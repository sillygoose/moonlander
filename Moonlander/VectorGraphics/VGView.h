//
//  VGView.h
//  Moonlander
//
//  Created by Rick on 5/14/11.
//  Copyright 2011, 2012 Rick Naro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum { VGLineSolid = 0, VGLineLongDash, VGLineShortDash, VGLineDotDash } VGLineType;
typedef enum { VGDefaultIntensity = 5, VGBrightIntensity = 7 } VGIntensity;

typedef struct {
    float x;
    float y;
    float alpha;
} point_t;


@interface VGView : UIView {
    NSArray                 *_drawPaths;
  
    CGFloat                 _fontSize;
    UIFont                  *_viewFontNormal;
    UIFont                  *_viewFontItalic;
    UIColor                 *_viewColor;
    NSTimer                 *__weak _blinkTimer;
    BOOL                    _blinkOn;
    
    CGRect                  _actualBounds;
    NSString                *_vectorName;
}

@property (nonatomic) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic) UIFont *viewFontNormal;
@property (nonatomic) UIFont *viewFontItalic;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic, strong) UIColor *viewColor;
@property (nonatomic, weak) NSTimer *blinkTimer;

@property (nonatomic) BOOL blinkOn;
@property (nonatomic) CGRect actualBounds;


- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;

@end
