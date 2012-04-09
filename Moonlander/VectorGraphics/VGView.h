//
//  VGView.h
//  Moonlander
//
//  Created by Silly Goose on 5/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VGView : UIView {
    NSArray     *_drawPaths;
    NSString    *_vectorName;
  
    CGFloat     _fontSize;              //###Mark for removal
    NSTimer     *__weak _blinkTimer;    //###Mark for removal
    
    BOOL        _blinkOn;
    CGRect      _actualBounds;
}

@property (nonatomic) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic, weak) NSTimer *blinkTimer;
@property (nonatomic) BOOL blinkOn;
@property (nonatomic) CGFloat fontSize;

@property (nonatomic) CGRect actualBounds;


- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;

@end
