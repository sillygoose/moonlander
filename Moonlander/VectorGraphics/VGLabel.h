//
//  VGLabel.h
//  Moonlander
//
//  Created by Rick on 5/18/11.
//  Copyright 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VGView.h"

@interface VGLabel : VGView {
    NSString        *_text;
    UIFont          *_font;
    UIColor         *_textColor;
    UITextAlignment _textAlignment;

    short           _intensity;
    BOOL            _blink;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UITextAlignment textAlignment;

@property (nonatomic) short intensity;
@property (nonatomic) BOOL blink;


- (id)initWithFrame:(CGRect)frameRect;

@end

