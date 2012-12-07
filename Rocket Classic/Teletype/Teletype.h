//
//  Teletype.h
//  ROCKET Classic
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TeletypeKeyboard.h"
#import "TeletypePrinter.h"


@interface Teletype : UIView
{
    TeletypeKeyboard        *keyboard;
    TeletypePrinter         *printer;
}

@property (nonatomic, strong) IBOutlet TeletypeKeyboard *keyboard;
@property (nonatomic, strong) IBOutlet TeletypePrinter *printer;


- (void)printString:(NSString *)text;
- (keycode_t)getKeycode;

- (void)fontSize:(CGFloat)newSize;
- (void)font:(UIFont *)newFont;
- (void)fontColor:(UIColor *)newColor;

- (UIFont *)font;
- (UIColor *)fontColor;

- (NSString *)printBuffer;
- (void)printBuffer:(NSString *)newText;
- (void)flushPrintBuffer;
- (void)pausePrintBuffer:(BOOL)action;

@end
