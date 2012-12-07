//
//  Teletype.m
//  ROCKET Classic
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "Teletype.h"


@interface Teletype ()
@end


@implementation Teletype

@synthesize keyboard, printer;


#pragma mark -
#pragma mark Teletype initialization methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    // Prevent this so the copy/paste doesn't work
    return NO;
}


#pragma mark -
#pragma mark Teletype interface methods

- (keycode_t)getKeycode
{
    return [self.keyboard getKey];
}

- (void)printString:(NSString *)printText
{
    [self.printer printString:printText];
}

- (void)fontSize:(CGFloat)newSize
{
    [self.printer fontSize:newSize];
}

- (UIFont *)font
{
    return [self.printer font];
}

- (NSString *)printBuffer
{
    return [self.printer printBuffer];
}

- (void)printBuffer:(NSString *)newText
{
    [self.printer printBuffer:newText];
}

- (void)flushPrintBuffer
{
    [self.printer flushPrintBuffer];
}

- (void)pausePrintBuffer:(BOOL)action
{
    [self.printer pausePrintBuffer:action];
}

- (void)font:(UIFont *)newFont
{
    [self.printer font:newFont];
}

- (void)fontColor:(UIColor *)newColor
{
    [self.printer fontColor:newColor];
}

- (UIColor *)fontColor
{
    return [self.printer fontColor];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    // Teletype objects
    self.printer = nil;
    self.keyboard = nil;
}

@end
