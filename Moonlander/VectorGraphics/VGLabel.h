//
//  VGLabel.h
//  Moonlander
//
//  Created by Silly Goose on 5/18/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VGView.h"

@interface VGLabel : VGView {
    NSString        *_text;
    UIFont          *_font;
    UIColor         *_textColor;
    UITextAlignment _textAlignment;

    BOOL            _blink;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UITextAlignment textAlignment;

@property (nonatomic) BOOL blink;


- (id)initWithFrame:(CGRect)frameRect;

@end

