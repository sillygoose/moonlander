//
//  TeletypePrintOutput.m
//  ROCKET Classic
//
//  Created by Rick Naro on 6/4/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "TeletypePrintOutput.h"

@interface TeletypePrintOutput ()

@end


@implementation TeletypePrintOutput

@synthesize delegate;


#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
}


#pragma mark -
#pragma mark View drawing

- (void)drawRect:(CGRect)rect
{
    // Setup the graphic context
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Font setup
    UIFont *font = [self.delegate font];
    UIColor *fontColor = [self.delegate fontColor];
	CGContextSelectFont(context, [font.fontName cStringUsingEncoding:NSASCIIStringEncoding], font.pointSize, kCGEncodingMacRoman);
    CGContextSetFillColorWithColor(context, fontColor.CGColor);
    
    // Line setup for overstrike
    const size_t maxLength = [self.delegate maxChars] - 1;

    // Get our start position for drawing
    CGPoint startPosition = CGPointMake(rect.origin.x, rect.origin.y);
    startPosition.y += font.pointSize / 8;
    CGPoint currentPosition = startPosition;
    
    // Draw the lines
    NSEnumerator *lineEnumerator = [[self.delegate textLines] reverseObjectEnumerator];
    NSString *currentLine;
    while ((currentLine = [lineEnumerator nextObject])) {
        // Display the text up to the right margin
        const char *cStringText = [currentLine cStringUsingEncoding:NSASCIIStringEncoding];
        size_t lengthCString = strlen(cStringText);
        size_t printLength = MIN(lengthCString, maxLength);
        CGContextShowTextAtPoint(context, currentPosition.x, currentPosition.y, cStringText, printLength);
        
        // Find out where we are after drawing
        CGPoint drawingContext = CGContextGetTextPosition(context);
        
        // Check if we still have printing in the last column to overstrike
        lengthCString -= printLength;
        while (lengthCString-- > 0) {
            CGContextShowTextAtPoint(context, drawingContext.x, drawingContext.y, &cStringText[printLength + lengthCString], 1);
        }
        
        // Set our new position for the new line
        currentPosition.x = startPosition.x;
        currentPosition.y += font.pointSize;
    }
}

@end
