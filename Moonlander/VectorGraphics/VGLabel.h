//
//  VGLabel.h
//  Moonlander
//
//  Created by Rick on 5/18/11.
//  Copyright 2012 Rick Naro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VGView.h"

@interface VGLabel : VGView {
    NSString                    *_text;
    UIFont                      *_font;
    UIColor                     *_textColor;
    NSTextAlignment             _textAlignment;

    short                       _intensity;
    BOOL                        _blink;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic) short intensity;
@property (nonatomic) BOOL blink;


- (id)initWithFrame:(CGRect)frameRect;

@end

