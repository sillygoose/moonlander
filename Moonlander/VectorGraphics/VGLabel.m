//
//  VGLabel.m
//  Moonlander
//
//  Created by Rick on 5/18/11.
//  Copyright 2012 Rick Naro. All rights reserved.
//

#import "VGLabel.h"

@implementation VGLabel

@synthesize text=_text;
@synthesize font=_font;
@synthesize textColor=_textColor;
@synthesize textAlignment=_textAlignment;

@synthesize intensity=_intensity;
@synthesize italics=_italics;
@synthesize blink=_blink;

- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // Defaults are no italics, full intensity, and align text left
        _textAlignment = NSTextAlignmentLeft;
        _intensity = 7;
        _italics = NO;
        
        // For debugging purposes
#ifdef DEBUG
        self.vectorName = @"[VGLabel initWithFrame]";
#ifdef DEBUG_FRAMES
        self.backgroundColor = [UIColor grayColor];
#endif
#endif
    }
    return self;
}

-(void)updateDrawingDictionary
{
    // Blink state and text alignment
    NSNumber *textAlign = [NSNumber numberWithInt:(int)self.textAlignment];
    NSNumber *intensity = [NSNumber numberWithInt:self.intensity];
    NSNumber *italics = [NSNumber numberWithBool:self.italics];
    NSNumber *blinkState = (self.blink) ? [NSNumber numberWithBool:self.blink] : nil;

    // Build the draw dictionary (blinkState is nil will terminate the list early)
    NSDictionary *drawDict = [NSDictionary dictionaryWithObjectsAndKeys:self.text, @"text", textAlign, @"alignment", italics, @"italics", intensity, @"intensity", blinkState, @"blink", nil];
    NSDictionary *nameDict = (self.vectorName) ? [NSDictionary dictionaryWithObjectsAndKeys:self.vectorName, @"name", nil] : nil;
    NSArray *path = [NSArray arrayWithObjects:drawDict, nameDict, nil];
    NSArray *paths = [NSArray arrayWithObject:path];
    self.drawPaths = paths;
    
    [self setNeedsDisplay];
}

- (void)setBlink:(BOOL)blinkType
{
    _blink = blinkType;
    [self updateDrawingDictionary];
}

- (void)setItalics:(BOOL)italics
{
    _italics = italics;
    [self updateDrawingDictionary];
}

- (void)setTextColor:(UIColor *)newColor
{
    _textColor = newColor;
    [self updateDrawingDictionary];
}

- (void)setFont:(UIFont *)newFont
{                    
    _font = newFont;
    [self updateDrawingDictionary];
}

- (void)setText:(NSString *)newText
{
    _text = [newText copy];
    [self updateDrawingDictionary];
}

- (void)setTextAlignment:(NSTextAlignment)newAlignment
{                    
    _textAlignment = newAlignment;
    [self updateDrawingDictionary];
}


@end
