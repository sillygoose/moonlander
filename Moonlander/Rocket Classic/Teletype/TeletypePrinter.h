//
//  TeletypePrinter.h
//  ROCKET Classic
//
//  Created by Rick Naro on 6/4/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TeletypePaper.h"
#import "TeletypeOutputBackground.h"


@interface TeletypePrinter : UIView <UIScrollViewDelegate, TeletypePrintOutputDelegate>
{
}

@property (nonatomic, strong) IBOutlet TeletypePaper *scrollView;
@property (nonatomic, strong) IBOutlet TeletypeOutputBackground *backgroundScrollView;


- (void)printString:(NSString *)printText;

- (NSString *)printBuffer;
- (void)printBuffer:(NSString *)newText;
- (void)flushPrintBuffer;
- (void)pausePrintBuffer:(BOOL)action;

- (void)fontSize:(CGFloat)newSize;
- (void)font:(UIFont *)newFont;
- (void)fontColor:(UIColor *)newColor;

- (UIFont *)font;
- (UIColor *)fontColor;

@end
