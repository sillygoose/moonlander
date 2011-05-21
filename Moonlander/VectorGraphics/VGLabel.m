//
//  VGLabel.m
//  Moonlander
//
//  Created by Silly Goose on 5/18/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGLabel.h"


@implementation VGLabel

@synthesize fontSize=_fontSize;


- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.fontSize = 12;
        self.opaque = NO;
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
    [super dealloc];
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
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    
    NSEnumerator *msgEnumerator = [self.drawPaths objectEnumerator];
    NSDictionary *currentText;
    while ((currentText = [msgEnumerator nextObject])) {
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
            NSLog(@"Newline: %@", NSStringFromCGPoint(currentPosition));
        }
        
        // Process a new path segment
        if ([currentText objectForKey:@"text"]) {
            NSString *msg = [currentText objectForKey:@"text"];
            //CGFloat x = [[currentText objectForKey:@"x"] floatValue];
            //CGFloat y = [[currentText objectForKey:@"y"] floatValue];
            // prepare characters for printing
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
            
            CGContextShowGlyphsAtPoint(context, currentPosition.x, currentPosition.y, glyphs, length);
            NSLog(@"Drawing text at %@", NSStringFromCGPoint(currentPosition));
            
            // get width of text for autosizing the frame later (perhaps)
            currentPosition = CGContextGetTextPosition(context);
        }
    }

    CGFontRelease(fontRef);
}

@end
