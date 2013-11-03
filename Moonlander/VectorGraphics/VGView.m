//
//  VGView.m
//  Moonlander
//
//  Created by Rick on 5/14/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "VGView.h"


@implementation VGView

@synthesize drawPaths=_drawPaths;
@synthesize vectorName=_vectorName;
@synthesize actualBounds=_actualBounds;
@synthesize blinkTimer=_blinkTimer;
@synthesize blinkOn=_blinkOn;
@synthesize fontSize=_fontSize;
@synthesize viewColor=_viewColor;

const float VGBlinkInterval = 0.75;


- (id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        // Need to be able to see thru views
        self.opaque = NO;

        // View defaults
        const CGFloat DefaultRed = 0.026;
        const CGFloat DefaultGreen = 1.0;
        const CGFloat DefaultBlue = 0.00121;
        const CGFloat DefaultAlpha = 1.0;
        self.viewColor = [[UIColor alloc] initWithRed:DefaultRed green:DefaultGreen blue:DefaultBlue alpha:DefaultAlpha];
        self.fontSize = 14;
        self.viewFont = [UIFont fontWithName:@"Courier-Bold" size:self.fontSize];
        
        self.actualBounds = CGRectMake(FLT_MAX, FLT_MAX, -FLT_MAX, -FLT_MAX);
        self.vectorName = @"[VGView initWithFrame]";
    }
    return self;
}

- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName
{
    self = [self initWithFrame:frameRect];

    NSDictionary *viewObject = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (!(self.vectorName = [viewObject objectForKey:@"name"])) {
        self.vectorName = @"[VGView initWithFrame:withPaths:]";
    }
    self.drawPaths = [viewObject objectForKey:@"paths"];
    
    // Sign up to get blink notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blinkUpdated:) name:@"blinkUpdated" object:nil];
    
    return self;
}


#pragma mark -
#pragma mark Notifications

- (void)blinkUpdated:(NSNotification *)notification
{
#if 0
    NSNumber *blinkState = notification.object;
    self.blinkOn = [blinkState boolValue];
    [self setNeedsDisplay];
#endif
}

- (void)blinkIntervalPassed:(NSTimer *)timer
{
    self.blinkOn = !self.blinkOn;
    [self setNeedsDisplay];
}

- (void)drawSomethingUsing:(NSArray *)arrayOfVectors
{
    BOOL logCommand = NO;
    UITextAlignment textAlignment = NSTextAlignmentLeft;

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
    
    CGFloat defaultRed, defaultGreen, defaultBlue, defaultAlpha;
    [self.viewColor getRed:&defaultRed green:&defaultGreen blue:&defaultBlue alpha:&defaultAlpha];
    CGContextSetRGBFillColor(context, defaultRed, defaultGreen, defaultBlue, defaultAlpha);
    CGContextSetRGBStrokeColor(context, defaultRed, defaultGreen, defaultBlue, defaultAlpha);
    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetShouldSmoothFonts(context, YES);
    
    // Font setup
    NSDictionary *normalTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:self.viewFont, NSFontAttributeName, self.viewColor, NSForegroundColorAttributeName, nil];
    NSDictionary *blinkTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:self.viewFont, NSFontAttributeName, [UIColor clearColor], NSForegroundColorAttributeName, nil];

    NSEnumerator *vectorEnumerator = [arrayOfVectors objectEnumerator];
    NSDictionary *currentVector;
    while ((currentVector = [vectorEnumerator nextObject])) {
        // Assume no blinking is needed in this view
        BOOL doBlink = NO;
        BOOL breakCommand = NO;
        
        // "break" allows for complex breakpoints in a display list
        if ([currentVector objectForKey:@"break"]) {
            breakCommand = [[currentVector objectForKey:@"break"] boolValue];
            if (breakCommand) {
                //###raise(SIGTRAP);
            }
        }
        
        // "stop' allows early termination of a display list
        if ([currentVector objectForKey:@"stop"]) {
            BOOL stopCommand = [[currentVector objectForKey:@"stop"] boolValue];
            if (stopCommand) break;
        }
        
#if defined(VG_LOGNAMES)
        // "name" allows for object identification
        NSString *viewName = @"(unknown)" ;
        if ([currentVector objectForKey:@"name"]) {
            viewName = [currentVector objectForKey:@"name"];
            NSLog(@"Processing %@", viewName);
        }
#endif
        
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
            const CGFloat Intensities[] = { 0.44f, 0.52f, 0.60f, 0.68f, 0.76f, 0.84f, 0.92f, 1.0f };
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
        
        // "blink" is used to blink the text
        if ([currentVector objectForKey:@"blink"]) {
            doBlink = [[currentVector objectForKey:@"blink"] boolValue];
            if (doBlink && !self.blinkTimer) {
                self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:VGBlinkInterval target:self selector:@selector(blinkIntervalPassed:) userInfo:nil repeats:YES];
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

            // Defaults for a rectangle
            CGFloat x = 0;
            CGFloat y = 0;
            CGFloat width = 1;
            CGFloat height = 1;
            
            // Is a size being specified?
            if ([rectStuff objectForKey:@"size"]) {
                NSDictionary *sizeStuff = [rectStuff objectForKey:@"size"];
                if ([sizeStuff objectForKey:@"width"]) {
                    width = [[sizeStuff objectForKey:@"width"] floatValue];
                }
                if ([sizeStuff objectForKey:@"height"]) {
                    height = [[sizeStuff objectForKey:@"height"] floatValue];
                }
            }
            
            // Is an origin being specified?
            if ([rectStuff objectForKey:@"origin"]) {
                NSDictionary *originStuff = [rectStuff objectForKey:@"origin"];
                if ([originStuff objectForKey:@"x"]) {
                    x = [[originStuff objectForKey:@"x"] floatValue];
                }
                if ([originStuff objectForKey:@"y"]) {
                    y = [[originStuff objectForKey:@"y"] floatValue];
                }
            }
            
            // Draw a rectangle
            CGRect rect = CGRectMake(x, y, width, height);
            CGContextSaveGState(context);
            
            // Set line stuff
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
                const CGFloat LongDash[] = {8, 2};
                const CGFloat ShortDash[] = {4, 2};
                const CGFloat DotDash[] = {8, 2, 2, 1};
                CGContextStrokePath(context);
                switch (type) {
                    default:
                    case VGLineSolid:
                        break;
                    case VGLineLongDash:
                        lengths = LongDash;
                        count = sizeof(LongDash)/sizeof(LongDash[0]);
                        break;
                    case VGLineShortDash:
                        lengths = ShortDash;
                        count = sizeof(ShortDash)/sizeof(ShortDash[0]);
                        break;
                    case VGLineDotDash:
                        lengths = DotDash;
                        count = sizeof(DotDash)/sizeof(DotDash[0]);
                        break;
                }
                CGContextSetLineDash(context, phase, lengths, count);
                CGContextMoveToPoint(context, prevPoint.x, prevPoint.y);
            }
        }
        
        // "newline" is used to move the drawing position to the next line
        if ([currentVector objectForKey:@"newline"]) {
            CGFloat nLines = [[currentVector objectForKey:@"newline"] floatValue];
            currentPosition.x = 0;
            currentPosition.y = currentPosition.y - (nLines * (self.fontSize + (self.fontSize * 0.4)));
        }
        
        // Process a text command
        if ([currentVector objectForKey:@"text"]) {
            logCommand = NO;
            BOOL useFlip = NO;
            
            // Prepare characters for printing
            NSString *msg = [currentVector objectForKey:@"text"];
            NSString *theText = [NSString stringWithString:msg];
            
#if 0 //###
            if (breakCommand == YES) {
                NSLog(@"%@", theText);
            }
#endif
            
            // Need to deal with the requested text alignment
            if (textAlignment == NSTextAlignmentLeft) {
                // Do nothing for left alignment
            }
            else if (textAlignment == NSTextAlignmentCenter) {
                // Find the length of the string
                CGContextSaveGState(context);
                CGContextGetTextPosition(context);
                CGContextSetTextDrawingMode(context, kCGTextInvisible);
                [theText drawAtPoint:currentPosition withAttributes:normalTextAttributes];
                CGContextRestoreGState(context);
                CGPoint endPoint = CGContextGetTextPosition(context);
                
                // Determine the length
                int textLength = endPoint.x - currentPosition.x ;
                
                // Adjust the current position to center the text
                currentPosition.x = (self.bounds.size.width / 2) - (textLength / 2);
            }
            else if (textAlignment == NSTextAlignmentRight) {
                // Find the length of the string
                CGContextSaveGState(context);
                CGContextGetTextPosition(context);
                CGContextSetTextDrawingMode(context, kCGTextInvisible);
                [theText drawAtPoint:currentPosition withAttributes:normalTextAttributes];
                CGContextRestoreGState(context);
                CGPoint endPoint = CGContextGetTextPosition(context);
                
                // Determine the length
                int textLength = endPoint.x - currentPosition.x ;
                
                // Adjust the current position to right align the text
                currentPosition.x = self.bounds.size.width - textLength;
            }
            
            // Flip the drawing context to get the text right-side up
            if (useFlip == YES) {
                CGContextSaveGState(context);
                CGContextTranslateCTM(context, 0,  self.fontSize / 2);
                CGContextScaleCTM(context, 1.0, -1.0);
            }
            CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
            CGRect boundingRect = [theText boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:normalTextAttributes context:nil];

            // We do this only if blinking is requested
            if (doBlink) {
                if (self.blinkOn) {
                    // Draw normally this cycle
                    if (breakCommand == YES) {
                        [theText drawAtPoint:currentPosition withAttributes:normalTextAttributes];
                    }
                    else {
                        [theText drawAtPoint:currentPosition withAttributes:normalTextAttributes];
                    }
                    //###[theText drawInRect:boundingRect withAttributes:textAttributes];
                }
                else {
                    if (useFlip == YES) {
                    // Change alpha to zero for this draw cycle and then restore
                    CGContextSaveGState(context);
                    CGContextSetAlpha(context, 0.0f);
                    }
                    if (breakCommand == YES) {
                        [theText drawAtPoint:currentPosition withAttributes:blinkTextAttributes];
                    }
                    else {
                        [theText drawAtPoint:currentPosition withAttributes:blinkTextAttributes];
                    }
                    //###[theText drawInRect:boundingRect withAttributes:textAttributes];
                    if (useFlip == YES) {
                    CGContextRestoreGState(context);
                    }
                }
            }
            else {
//                [theText drawInRect:boundingRect withAttributes:textAttributes];
                if (breakCommand == YES) {
                    [theText drawAtPoint:currentPosition withAttributes:normalTextAttributes];
                }
                else {
                    [theText drawAtPoint:currentPosition withAttributes:normalTextAttributes];
                }
            }
            //NSLog(@"Drawing text at %@", NSStringFromCGPoint(currentPosition));

            // Get position and restore context
            CGPoint drawingPosition = CGContextGetTextPosition(context);
            if (useFlip == YES) {
                CGContextRestoreGState(context);
            }
            
            // Find out where we are after drawing
            currentPosition.x += ceil(boundingRect.size.width);
            // Set our new position for the next text block
            self.actualBounds = CGRectMake(MIN(currentPosition.x, self.actualBounds.origin.x), MIN(currentPosition.y, self.actualBounds.origin.y), MAX(currentPosition.x, self.actualBounds.size.width), MAX(currentPosition.y, self.actualBounds.size.height));
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
#ifdef DEBUG
    if (logCommand) {
        NSLog(@"Max coordinates for %@: %@", self.vectorName, NSStringFromCGRect(self.actualBounds));
        logCommand = NO;
    }
#endif
}

- (void)drawPoint:(point_t)point
{
    // Set up context for drawing
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    
    // Set the color
    CGFloat defaultRed, defaultGreen, defaultBlue, defaultAlpha;
    [self.viewColor getRed:&defaultRed green:&defaultGreen blue:&defaultBlue alpha:&defaultAlpha];
    CGContextSetRGBFillColor(context, defaultRed, defaultGreen, defaultBlue, defaultAlpha);
    CGContextSetRGBStrokeColor(context, defaultRed, defaultGreen, defaultBlue, defaultAlpha);
    CGContextSetAlpha(context, point.alpha);
    
    // Defaults for a rectangle
    CGFloat width = 1;
    CGFloat height = 1;
    
    // Draw a simple rectangle
    CGRect rect = CGRectMake(point.x, point.y, width, height);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    if (self.drawPaths) {
        // This code supports old and new draw lists and point arrays
        if ([[self.drawPaths objectAtIndex:0] isKindOfClass:[NSArray class]]) {
            NSEnumerator *pathEnumerator = [self.drawPaths objectEnumerator];
            NSArray *currentPath;
            while ((currentPath = [pathEnumerator nextObject])) {
                [self drawSomethingUsing:currentPath];
            }
        }
        else if ([[self.drawPaths objectAtIndex:0] isKindOfClass:[NSValue class]]) {
            // Draw using the super quick point mode (array of NSValues)
            NSEnumerator *pathEnumerator = [self.drawPaths objectEnumerator];
            NSValue *currentPoint;
            while ((currentPoint = [pathEnumerator nextObject])) {
                point_t point;
                [currentPoint getValue:&point];
                [self drawPoint:point];
            }
        }
        else if ([[self.drawPaths objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
            // Array of NSDictionary
            [self drawSomethingUsing:self.drawPaths];
        }
    }
}

@end
