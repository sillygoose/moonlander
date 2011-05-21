//
//  VGLabel.m
//  Moonlander
//
//  Created by Silly Goose on 5/18/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGLabel.h"


@implementation VGLabel

@synthesize blinkTimer=_blinkTimer;
@synthesize blinkOn=_blinkOn;
@synthesize fontSize=_fontSize;


- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.fontSize = 11;
        self.opaque = NO;
        self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(blinkIntervalPassed:) userInfo:nil repeats:YES];
    }
    return self;
}

- (id)initWithMessage:(NSString *)msgName
{
    
    NSString *msgsFile = [[NSBundle mainBundle] pathForResource:@"LanderMessages" ofType:@"plist"];
    NSDictionary *landerMessages = [NSDictionary dictionaryWithContentsOfFile:msgsFile];
    NSDictionary *msgs = [landerMessages objectForKey:@"messages"];
    NSDictionary *msg = [msgs objectForKey:msgName];

    NSDictionary *frame = [msg objectForKey:@"frame"];
    NSDictionary *origin = [frame objectForKey:@"origin"];
    NSDictionary *size = [frame objectForKey:@"size"];

    CGRect frameRect ;
    frameRect.origin.x = [[origin objectForKey:@"x"] floatValue];
    frameRect.origin.y = [[origin objectForKey:@"y"] floatValue];
    frameRect.size.width = [[size objectForKey:@"width"] floatValue];
    frameRect.size.height = [[size objectForKey:@"height"] floatValue];
    self = [self initWithFrame:frameRect];
    
    self.drawPaths = [msg objectForKey:@"text"];
    self.vectorName = msgName;
    
    return self;
}

- (void)dealloc
{
    [_blinkTimer invalidate];
    [_blinkTimer release];
    [super dealloc];
}

- (void)blinkIntervalPassed:(NSTimer *)timer
{
    self.blinkOn = !self.blinkOn;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM (context, 0, self.bounds.size.height);
    CGContextScaleCTM ( context, 1.0, -1.0 );
	//CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));

    CGFontRef fontRef = CGFontCreateWithFontName((CFStringRef)@"Courier");
    CGContextSetFont(context, fontRef);
    CGContextSetFontSize(context, self.fontSize);
    CGPoint currentPosition = CGPointMake(0.0f, self.bounds.size.height - self.fontSize);
    
    CGContextSetRGBFillColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    CGContextSetRGBStrokeColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetShouldSmoothFonts(context, YES);
    
    NSEnumerator *msgEnumerator = [self.drawPaths objectEnumerator];
    NSDictionary *currentText;
    while ((currentText = [msgEnumerator nextObject])) {
        BOOL doBlink = NO;
        
        // "stop' allows early termination of a display list
        if ([currentText objectForKey:@"stop"]) {
            BOOL stopCommand = [[currentText objectForKey:@"stop"] boolValue];
            if (stopCommand) break;
        }
            
        // "break" allows for complex breakpoints in a display list
        if ([currentText objectForKey:@"break"]) {
            BOOL breakCommand = [[currentText objectForKey:@"break"] boolValue];
            if (breakCommand) {
                NSLog(@"Set breakpoint point here");;
            }
        }
            
        // "color" is used to set the current color
        if ([currentText objectForKey:@"color"]) {
            NSDictionary *colorStuff = [currentText objectForKey:@"color"];
            CGFloat r = [[colorStuff objectForKey:@"r"] floatValue];
            CGFloat g = [[colorStuff objectForKey:@"g"] floatValue];
            CGFloat b = [[colorStuff objectForKey:@"b"] floatValue];
            CGFloat alpha = [[colorStuff objectForKey:@"alpha"] floatValue];
            CGContextSetRGBFillColor(context, r, g, b, alpha);
        }
            
        // "mode" is used to set the text drawing mode
        if ([currentText objectForKey:@"mode"]) {
            int textMode = [[currentText objectForKey:@"mode"] intValue];
            CGContextSetTextDrawingMode(context, textMode);
        }
        
        // "font" is used to set the current font and size
        if ([currentText objectForKey:@"font"]) {
            NSDictionary *fontStuff = [currentText objectForKey:@"font"];
            if ([fontStuff objectForKey:@"size"]) {
                self.fontSize = [[fontStuff objectForKey:@"size"] floatValue];
                CGContextSetFontSize(context, self.fontSize);
            }
            if ([fontStuff objectForKey:@"name"]) {
                NSString *fontName = [fontStuff objectForKey:@"name"];
                CGFontRelease(fontRef);
                fontRef = CGFontCreateWithFontName((CFStringRef)fontName);
                CGContextSetFont(context, fontRef);
            }
        }
        
        // "newline" is used to move the drawing position to the next line
        if ([currentText objectForKey:@"newline"]) {
            CGFloat nLines = [[currentText objectForKey:@"newline"] floatValue];
            currentPosition.x = 0.0f;
            currentPosition.y = currentPosition.y - (nLines * self.fontSize);
        }
        
        // "blink" is used to blink the text
        if ([currentText objectForKey:@"blink"]) {
            doBlink = [[currentText objectForKey:@"blink"] boolValue];
        }
        
        // Process a new path segment
        if ([currentText objectForKey:@"text"]) {
            NSString *msg = [currentText objectForKey:@"text"];

            // Prepare characters for printing
            NSString *theText = [NSString stringWithString:msg];
            int length = [theText length];
            unichar chars[length];
            CGGlyph glyphs[length];
            [theText getCharacters:chars range:NSMakeRange(0, length)];
            
            // Loop through the entire length of the text.
            int glyphOffset = -29;
            for (int i = 0; i < length; ++i) {
                // Store each letter in a Glyph and subtract the MagicNumber to get appropriate value.
                glyphs[i] = [theText characterAtIndex:i] + glyphOffset;
            }
            
            if (doBlink) {
                if (self.blinkOn) {
                    CGContextShowGlyphsAtPoint(context, currentPosition.x, currentPosition.y, glyphs, length);
                }
                else {
                    // Change alpha to zero for this draw cycle
                    CGContextSaveGState(context);
                    CGContextSetAlpha(context, 0.0f);
                    CGContextShowGlyphsAtPoint(context, currentPosition.x, currentPosition.y, glyphs, length);
                    CGContextRestoreGState(context);
                }
            }
            else {
                CGContextShowGlyphsAtPoint(context, currentPosition.x, currentPosition.y, glyphs, length);
            }
            //NSLog(@"Drawing text at %@", NSStringFromCGPoint(currentPosition));
            
            // Set our new position for the next text block
            currentPosition = CGContextGetTextPosition(context);
        }
    }

    CGFontRelease(fontRef);
}

@end
