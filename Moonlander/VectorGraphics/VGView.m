//
//  VGView.m
//  Moonlander
//
//  Created by Silly Goose on 5/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGView.h"


@implementation VGView

@synthesize drawPaths=_drawPaths;
@synthesize vectorName=_vectorName;
@synthesize actualBounds=_actualBounds;
@synthesize blinkTimer=_blinkTimer;
@synthesize blinkOn=_blinkOn;
@synthesize fontSize=_fontSize;


- (id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        self.fontSize = 12;
        self.opaque = NO;
        
        self.actualBounds = CGRectMake(FLT_MAX, FLT_MAX, -FLT_MAX, -FLT_MAX);
        self.vectorName = @"[VGView initWithFrame]";
    }
    return self;
}

- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName
{
    self = [self initWithFrame:frameRect];

    NSDictionary *viewObject = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (!(self.vectorName = [viewObject objectForKey:@"name"]))
        self.vectorName = @"[VGView initWithFrame:withPaths:]";
    self.drawPaths = [viewObject objectForKey:@"paths"];
    return self;
}

- (void)blinkIntervalPassed:(NSTimer *)timer
{
    self.blinkOn = !self.blinkOn;
    [self setNeedsDisplay];
}

- (void)drawSomethingUsing:(NSArray *)arrayOfVectors
{
    BOOL logCommand = NO;
    UITextAlignment textAlignment = UITextAlignmentLeft;

    // Simple stack for push/pop support
    CGPoint positionStack[4];
    unsigned positionCount = 0;
    
    CGPoint currentPosition = CGPointMake(0.0f, self.bounds.size.height - self.fontSize);
    CGPoint prevPoint = CGPointZero;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGFontRef fontRef = CGFontCreateWithFontName((CFStringRef)@"Courier");
    CGContextSetFont(context, fontRef);
    CGContextSetFontSize(context, self.fontSize);
    
    CGContextSetRGBFillColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    CGContextSetRGBStrokeColor(context, 0.026f, 1.0f, 0.00121f, 1.0f);
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetShouldSmoothFonts(context, YES);
    
    NSEnumerator *vectorEnumerator = [arrayOfVectors objectEnumerator];
    NSDictionary *currentVector;
    while ((currentVector = [vectorEnumerator nextObject])) {
        // Assume no blinking is needed in this view
        BOOL doBlink = NO;
        
        // "break" allows for complex breakpoints in a display list
        if ([currentVector objectForKey:@"break"]) {
            BOOL breakCommand = [[currentVector objectForKey:@"break"] boolValue];
            if (breakCommand) {
                raise(SIGTRAP);
            }
        }
        
        // "stop' allows early termination of a display list
        if ([currentVector objectForKey:@"stop"]) {
            BOOL stopCommand = [[currentVector objectForKey:@"stop"] boolValue];
            if (stopCommand) break;
        }
        
        // "log" allows for view information
        if ([currentVector objectForKey:@"log"]) {
            logCommand = [[currentVector objectForKey:@"log"] boolValue];
        }
        
        // "pop' restores the graphics context or position
        if ([currentVector objectForKey:@"pop"]) {
            NSDictionary *popStuff = [currentVector objectForKey:@"pop"];
            if ([popStuff objectForKey:@"gstate"]) {
                CGContextStrokePath(context);
                CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
                CGContextRestoreGState(context);
            }
            if ([popStuff objectForKey:@"position"]) {
                if (positionCount > 0) {
                    prevPoint = positionStack[--positionCount];
                    CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
                }
            }
        }
        
        // "push' saves the graphics context or position
        if ([currentVector objectForKey:@"push"]) {
            NSDictionary *pushStuff = [currentVector objectForKey:@"push"];
            if ([pushStuff objectForKey:@"gstate"]) {
                CGContextStrokePath(context);
                CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
                CGContextSaveGState(context);
            }
            if ([pushStuff objectForKey:@"position"]) {
                if (positionCount < (sizeof(positionStack)/sizeof(positionStack[0]))) {
                    positionStack[positionCount++] = prevPoint;
                }
            }
        }
        
        // "color" is used to set the current color
        if ([currentVector objectForKey:@"color"]) {
            NSDictionary *colorStuff = [currentVector objectForKey:@"color"];
            CGFloat r = [[colorStuff objectForKey:@"r"] floatValue];
            CGFloat g = [[colorStuff objectForKey:@"g"] floatValue];
            CGFloat b = [[colorStuff objectForKey:@"b"] floatValue];
            CGFloat alpha = [[colorStuff objectForKey:@"alpha"] floatValue];
            CGContextStrokePath(context);
            CGContextSetRGBStrokeColor(context, r, g, b, alpha);
            CGContextSetRGBFillColor(context, r, g, b, alpha);
            CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
        }
        
        // "alignment" is used to select the alignment of text
        if ([currentVector objectForKey:@"alignment"]) {
            textAlignment = [[currentVector objectForKey:@"alignment"] intValue];
        }
        
        // "intensity" is used to set the display intensity
        if ([currentVector objectForKey:@"intensity"]) {
            int intensityLevel = [[currentVector objectForKey:@"intensity"] intValue];
            CGContextStrokePath(context);
            const CGFloat Intensities[] = { 0.3f, 0.4f, 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f };
            CGContextSetAlpha(context, Intensities[intensityLevel % (sizeof(Intensities)/sizeof(Intensities[0]))]);
            CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
        }
        
        // "textmode" is used to set the text drawing mode
        if ([currentVector objectForKey:@"mode"]) {
            int textMode = [[currentVector objectForKey:@"mode"] intValue];
            CGContextSetTextDrawingMode(context, textMode);
        }
        
        // "font" is used to set the current font and size
        if ([currentVector objectForKey:@"font"]) {
            NSDictionary *fontStuff = [currentVector objectForKey:@"font"];
            if ([fontStuff objectForKey:@"size"]) {
                self.fontSize = [[fontStuff objectForKey:@"size"] floatValue];
                CGContextSetFontSize(context, self.fontSize);
            }
            if ([fontStuff objectForKey:@"name"]) {
                NSString *fontName = [fontStuff objectForKey:@"name"];
                CGFontRelease(fontRef);
                fontRef = CGFontCreateWithFontName((__bridge CFStringRef)fontName);
                CGContextSetFont(context, fontRef);
            }
        }
        
        // "newline" is used to move the drawing position to the next line
        if ([currentVector objectForKey:@"newline"]) {
            CGFloat nLines = [[currentVector objectForKey:@"newline"] floatValue];
            currentPosition.x = 0.0f;
            currentPosition.y = currentPosition.y - (nLines * self.fontSize);
        }
        
        // "blink" is used to blink the text
        if ([currentVector objectForKey:@"blink"]) {
            doBlink = [[currentVector objectForKey:@"blink"] boolValue];
            if (doBlink && !self.blinkTimer) {
                self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(blinkIntervalPassed:) userInfo:nil repeats:YES];
            }
        }
        
        // "moveto" is used to a move to a point in the current rect
        if ([currentVector objectForKey:@"moveto"]) {
            NSDictionary *moveTo = [currentVector objectForKey:@"moveto"];
            if ([moveTo objectForKey:@"center"]) {
                // Centering uses the view bounds and is not scaled
                CGPoint midPoint = CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y + self.bounds.size.height / 2);
                CGContextMoveToPoint(context, midPoint.x, midPoint.y);
                prevPoint = midPoint;
            }
            else if ([moveTo objectForKey:@"x"]) {
                // Moving to a point in the view requires scaling
                CGFloat x = [[moveTo objectForKey:@"x"] floatValue];
                CGFloat y = [[moveTo objectForKey:@"y"] floatValue];
                CGPoint newPoint = CGPointMake(x, y);
                
                CGContextMoveToPoint(context, newPoint.x, newPoint.y);
                currentPosition = CGPointMake(x, self.bounds.size.height - y);
                CGContextSetTextPosition(context, currentPosition.x, currentPosition.y);
                
                //NSLog(@"Move To (%3.0f,%3.0f)", newPoint.x, newPoint.y);
                //prevPoint = newPoint;
                prevPoint = CGContextGetPathCurrentPoint(context);
                self.actualBounds = CGRectMake(MIN(newPoint.x, self.actualBounds.origin.x), MIN(newPoint.y, self.actualBounds.origin.y), MAX(newPoint.x, self.actualBounds.size.width), MAX(newPoint.y, self.actualBounds.size.height));
            }
        }
        
        // "moverel" is used to move to a point relative to the current position
        if ([currentVector objectForKey:@"moverel"]) {
            NSDictionary *moveRelative = [currentVector objectForKey:@"moverel"];
            if ([moveRelative objectForKey:@"x"]) {
                // Moving to a point in the view requires scaling
                CGFloat x = [[moveRelative objectForKey:@"x"] floatValue];
                CGFloat y = [[moveRelative objectForKey:@"y"] floatValue];
                CGPoint newPoint = CGPointMake(prevPoint.x + x, prevPoint.y + y);
                
                CGContextMoveToPoint(context, newPoint.x, newPoint.y);
                newPoint.x = currentPosition.x + x;
                newPoint.y = currentPosition.y + y;
                CGContextSetTextPosition(context, newPoint.x, newPoint.y);
                
                //NSLog(@"Move Relative (%3.0f,%3.0f)", newPoint.x, newPoint.y);
                //prevPoint = newPoint;
                prevPoint = CGContextGetPathCurrentPoint(context);
                self.actualBounds = CGRectMake(MIN(newPoint.x, self.actualBounds.origin.x), MIN(newPoint.y, self.actualBounds.origin.y), MAX(newPoint.x, self.actualBounds.size.width), MAX(newPoint.y, self.actualBounds.size.height));
            }
        }
        
        // "rect" is used to draw a simple rectangle
        if ([currentVector objectForKey:@"rect"]) {
            NSDictionary *rectStuff = [currentVector objectForKey:@"rect"];
            
            NSDictionary *frameStuff = [rectStuff objectForKey:@"frame"];
            NSDictionary *originStuff = [frameStuff objectForKey:@"origin"];
            NSDictionary *sizeStuff = [frameStuff objectForKey:@"size"];
            CGFloat x = [[originStuff objectForKey:@"x"] floatValue];
            CGFloat y = [[originStuff objectForKey:@"y"] floatValue];
            CGFloat width = [[sizeStuff objectForKey:@"width"] floatValue];
            CGFloat height = [[sizeStuff objectForKey:@"height"] floatValue];
            
            CGRect rect = CGRectMake(x, y, width, height);
            CGContextSaveGState(context);
            //set line stuff
            CGContextAddRect(context, rect);
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
        }
        
        // "line" is used to set the line information
        if ([currentVector objectForKey:@"line"]) {
            NSDictionary *lineStuff = [currentVector objectForKey:@"line"];
            if ([lineStuff objectForKey:@"width"]) {
                CGFloat width = [[lineStuff objectForKey:@"width"] floatValue];
                CGContextStrokePath(context);
                CGContextSetLineWidth(context, width);
                CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
            }
            if ([lineStuff objectForKey:@"type"]) {
                int type = [[lineStuff objectForKey:@"type"] intValue];
                CGFloat phase = 0.0f;
                size_t count = 0;
                const CGFloat *lengths = NULL;
                const CGFloat LongDash[] = {12.0f, 4.0f};
                const CGFloat ShortDash[] = {6.0f, 2.0f};
                const CGFloat DotDash[] = {6.0f, 2.0f, 12.0f, 2.0f};
                CGContextStrokePath(context);
                switch (type) {
                    case 1:
                        lengths = LongDash;
                        count = sizeof(LongDash)/sizeof(LongDash[0]);
                        break;
                    case 2:
                        lengths = ShortDash;
                        count = sizeof(ShortDash)/sizeof(ShortDash[0]);
                        break;
                    case 3:
                        lengths = DotDash;
                        count = sizeof(DotDash)/sizeof(DotDash[0]);
                        break;
                }
                CGContextSetLineDash(context, phase, lengths, count);
                CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
            }
        }
        
        // Process a text command
        if ([currentVector objectForKey:@"text"]) {
            CGContextTranslateCTM(context, 0, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0, -1.0 );
            
            NSString *msg = [currentVector objectForKey:@"text"];
            
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
            
            // Need to deal with the requested text alignment
            if (textAlignment == UITextAlignmentLeft) {
                // Do nothing for left alignment
            }
            else if (textAlignment == UITextAlignmentCenter) {
                // Find the length of the string
                CGContextSaveGState(context);
                CGContextGetTextPosition(context);
                CGContextSetTextDrawingMode(context, kCGTextInvisible);
                CGContextShowGlyphsAtPoint(context, currentPosition.x, currentPosition.y, glyphs, length);
                CGContextRestoreGState(context);
                CGPoint endPoint = CGContextGetTextPosition(context);
                
                // Determine the length
                int textLength = endPoint.x - currentPosition.x ;
                
                // Adjust the current position to center the text
                currentPosition.x = (self.bounds.size.width / 2) - (textLength / 2);
            }
            else if (textAlignment == UITextAlignmentRight) {
                // Find the length of the string
                CGContextSaveGState(context);
                CGContextGetTextPosition(context);
                CGContextSetTextDrawingMode(context, kCGTextInvisible);
                CGContextShowGlyphsAtPoint(context, currentPosition.x, currentPosition.y, glyphs, length);
                CGContextRestoreGState(context);
                CGPoint endPoint = CGContextGetTextPosition(context);
                
                // Determine the length
                int textLength = endPoint.x - currentPosition.x ;
                
                // Adjust the current position to right align the text
                currentPosition.x = self.bounds.size.width - textLength;
            }
            
            // We do this only if blinking is requested
            if (doBlink) {
                if (self.blinkOn) {
                    // Draw normally this cycle
                    CGContextShowGlyphsAtPoint(context, currentPosition.x, currentPosition.y, glyphs, length);
                }
                else {
                    // Change alpha to zero for this draw cycle and then restore
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
            self.actualBounds = CGRectMake(MIN(currentPosition.x, self.actualBounds.origin.x), MIN(currentPosition.y, self.actualBounds.origin.y), MAX(currentPosition.x, self.actualBounds.size.width), MAX(currentPosition.y, self.actualBounds.size.height));
            
            // Restore our normal drawing translation
            CGContextTranslateCTM(context, 0, self.bounds.size.height);
            CGContextScaleCTM(context, 1.0, -1.0 );
        }
        
        // "x" and "y" specify a new point on the path
        if ([currentVector objectForKey:@"x"]) {
            CGFloat x = [[currentVector objectForKey:@"x"] floatValue];
            CGFloat y = [[currentVector objectForKey:@"y"] floatValue];
            CGPoint newPoint = CGPointMake(prevPoint.x + x, prevPoint.y + y);
            CGContextAddLineToPoint(context, newPoint.x, newPoint.y);
            prevPoint = CGContextGetPathCurrentPoint(context);
            self.actualBounds = CGRectMake(MIN(newPoint.x, self.actualBounds.origin.x), MIN(newPoint.y, self.actualBounds.origin.y), MAX(newPoint.x, self.actualBounds.size.width), MAX(newPoint.y, self.actualBounds.size.height));
        }
    }
    CGContextStrokePath(context);
    CGFontRelease(fontRef);

    // Display anything we asked to be logged
    if (logCommand) {
        NSLog(@"Max coordinates for %@: %@", self.vectorName, NSStringFromCGRect(self.actualBounds));
    }
}

- (void)drawRect:(CGRect)rect
{
    // This code supports old and new draw lists
    if ([[self.drawPaths objectAtIndex:0] isKindOfClass:[NSArray class]]) {
        NSEnumerator *pathEnumerator = [self.drawPaths objectEnumerator];
        NSArray *currentPath;
        while ((currentPath = [pathEnumerator nextObject])) {
            [self drawSomethingUsing:currentPath];
        }
    }
    else {
        [self drawSomethingUsing:self.drawPaths];
    }
}

@end
