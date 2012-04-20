//
//  VGLabel.m
//  Moonlander
//
//  Created by Silly Goose on 5/18/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGLabel.h"


@implementation VGLabel

@synthesize text=_text;
@synthesize font=_font;
@synthesize textColor=_textColor;
@synthesize textAlignment=_textAlignment;
@synthesize blink=_blink;


- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.font = [UIFont fontWithName:@"Courier" size:12.0f];
        self.textColor = [UIColor colorWithRed:0.026f green:1.0f blue:0.00121f alpha:1.0f] ;
        self.textAlignment = UITextAlignmentLeft;
        
        // For debugging purposes
        self.vectorName = @"[VGLabel initWithFrame]";
        //self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

-(void)updateDrawingDictionary
{
    // Get the font info
    NSDictionary *fontDict = nil;
    if (self.font) {
        NSNumber *fontSize = [NSNumber numberWithFloat:self.font.pointSize];
        fontDict = [NSDictionary dictionaryWithObjectsAndKeys:self.font.fontName, @"name", fontSize, @"size", nil];
    }
    
    // Get the color info
    NSDictionary *colorDict = nil;
    if (self.textColor) {
        size_t nComp = CGColorGetNumberOfComponents(self.textColor.CGColor);
        if (nComp >= 4) {
            const CGFloat *colorComp = CGColorGetComponents(self.textColor.CGColor);
            NSNumber *r = [NSNumber numberWithFloat:colorComp[0]];
            NSNumber *g = [NSNumber numberWithFloat:colorComp[1]];
            NSNumber *b = [NSNumber numberWithFloat:colorComp[2]];
            NSNumber *a = [NSNumber numberWithFloat:colorComp[3]];
            colorDict = [NSDictionary dictionaryWithObjectsAndKeys:r, @"r", g, @"g", b, @"b", a, @"alpha", nil];
        }
    }
    
    // Name info
    NSString *viewName = self.vectorName;
    NSDictionary *name = [NSDictionary dictionaryWithObjectsAndKeys:viewName, @"name", nil];
    
    // Blink state and text alignment
    NSNumber *textAlign = [NSNumber numberWithInt:self.textAlignment];
    NSNumber *blinkState = (self.blink) ? [NSNumber numberWithBool:self.blink] : nil;
    
    // Build the draw dictionary (blinkState is nil will terminate the list early)
    NSDictionary *drawDict = [NSDictionary dictionaryWithObjectsAndKeys:self.text, @"text", textAlign, @"alignment", fontDict, @"font", colorDict, @"color", name, @"name", blinkState, @"blink", nil];
    NSArray *path = [NSArray arrayWithObjects:drawDict, nil];
    NSArray *paths = [NSArray arrayWithObject:path];
    self.drawPaths = paths;
    
    [self setNeedsDisplay];
}

- (void)setBlink:(BOOL)blinkType
{
    _blink = blinkType;
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

- (void)setTextAlignment:(UITextAlignment)newAlignment
{                    
    _textAlignment = newAlignment;
    [self updateDrawingDictionary];
}


@end
