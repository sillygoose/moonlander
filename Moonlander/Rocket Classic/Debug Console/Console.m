//
//  Console.m
//  RMoonlander
//
//  Created by Rick Naro on 5/16/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "Console.h"


@interface Console ()

@property (nonatomic, strong) NSArray *textLines;
@property (nonatomic, strong) NSDictionary *sourceCode;

@property (nonatomic, strong) UIFont *displayFont;
@property (nonatomic, strong) UIColor *displayFontColor;
@property (nonatomic, strong) UIColor *stepFontColor;

@property (nonatomic) BOOL traceEnabled;

@end


@implementation Console

@synthesize stepStatement;

@synthesize textLines, sourceCode;
@synthesize displayFont, displayFontColor, stepFontColor;
@synthesize traceEnabled;


#pragma mark -
#pragma mark Setters/getters

- (void)setStepStatement:(NSString *)statement
{
    // Save the current statement
    stepStatement = statement;
    
    // Update the display if defined
    if (self.traceEnabled) {
        if (stepStatement) {
            // Find the line number of the statement
            NSString *keyName = [statement stringByDeletingPathExtension];
            NSDictionary *currentStatement = [self.sourceCode objectForKey:keyName];
            NSNumber *lineNumber = [currentStatement objectForKey:@"line"];
            CGFloat yOffset = [lineNumber floatValue];
            CGPoint newOffset = CGPointMake(0, (yOffset - 1) * self.displayFont.pointSize);
            
            // UI work in main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                // Viewable area numbers
                CGFloat verticalInset = self.contentInset.top + self.contentInset.bottom;
                CGFloat viewableHeight = self.bounds.size.height - verticalInset;
                
                // Get the current scroll view content offset
                CGPoint currentOffset = self.contentOffset;
            
                // If we are in the current display then don't move
                if (newOffset.y <= currentOffset.y) {
                    if (newOffset.y < viewableHeight) {
                        currentOffset.y = 0;
                    }
                    else {
                        currentOffset.y = newOffset.y - (viewableHeight / 2);
                    }
                }
                else if (newOffset.y > (currentOffset.y + viewableHeight)) {
                    if (newOffset.y > (self.contentSize.height - viewableHeight)) {
                        currentOffset.y = self.contentSize.height - viewableHeight;
                    }
                    else {
                        currentOffset.y = newOffset.y - (viewableHeight / 2);
                    }
                }

                // Update the display if changing
                if (currentOffset.y != self.contentOffset.y) {
                    [self setContentOffset:currentOffset animated:YES];
                }
                [self setNeedsDisplay];
            });
        }
        else {
            // See what queue we are on
            if ([NSThread isMainThread]) {
                [self setNeedsDisplay];
            }
            else {
                // Remove the highlighting
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNeedsDisplay];
                });
            }
        }
    }
}


#pragma mark -
#pragma mark Notifications

- (void)debugTraceSwitchChanged:(NSNotification *)notification
{
    NSNumber *traceState = notification.object;
    self.traceEnabled = [traceState boolValue];
    
    // Update the display when trace is enabled
    if (self.traceEnabled) {
        [self setNeedsDisplay];
    }
}


#pragma mark -
#pragma mark View lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Load a display terminal font
        self.displayFont = [UIFont fontWithName:@"Teleprinter-Bold" size:16.5];
        self.displayFontColor = [UIColor yellowColor];
        self.stepFontColor = [UIColor redColor];
        self.backgroundColor = [UIColor blackColor];
        
        // Load the dictionary used to navigate the source code
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SourceCode" ofType:@"plist"];
        self.sourceCode = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        // Pull the list of keys into an array and then sort them
        self.textLines = [self.sourceCode keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            NSDictionary *dict1 = obj1;
            NSDictionary *dict2 = obj2;
            NSNumber *num1 = [dict1 objectForKey:@"line"];
            NSNumber *num2 = [dict2 objectForKey:@"line"];
            if ([num1 intValue] > [num2 intValue] ) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([num1 intValue] < [num2 intValue] ) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            assert(YES);
            return (NSComparisonResult)NSOrderedSame;
        }];

        // Scroll view setup
        self.contentSize = CGSizeZero;
        self.bounces = NO;
        
        //#### too many of these!!!! Set debug control options from settinbgs
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.traceEnabled = [defaults floatForKey:@"optionStepEnabled"];
                
        // Sign up to get changed in debug controls
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugTraceSwitchChanged:) name:@"debugTraceSwitchChange" object:nil];
    }
    return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    // Release notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // Release objects
    self.stepStatement = nil;
    
    self.textLines = nil;
    self.sourceCode = nil;
    self.displayFont = nil;
    self.displayFontColor = nil;
    self.stepFontColor = nil;
}


#pragma mark -
#pragma mark View drawing

- (void)drawRect:(CGRect)rect
{
    // Setup the graphic context
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    
    // Font setup
    CGContextSelectFont(context, [self.displayFont.fontName cStringUsingEncoding:NSASCIIStringEncoding], self.displayFont.pointSize, kCGEncodingMacRoman);
    CGContextSetFillColorWithColor(context, self.displayFontColor.CGColor);

    // Get our start position for drawing
    CGPoint startPosition = CGPointZero;
    CGPoint currentPosition = startPosition;
    
    // Draw the text
    NSEnumerator *keyEnumerator = [self.textLines objectEnumerator];
    NSString *currentKey;
    while ((currentKey = [keyEnumerator nextObject])) {
        // Get the source line information
        NSDictionary *currentLine = [self.sourceCode objectForKey:currentKey];
        NSArray *currentStatements = [currentLine objectForKey:@"statements"];
        if (currentStatements) {
            NSEnumerator *statementEnumerator = [currentStatements objectEnumerator];
            NSDictionary *currentStatement;
            while ((currentStatement = [statementEnumerator nextObject])) {
                // Read the display the statement
                NSString *statementID = [currentStatement objectForKey:@"id"];
                NSString *statementText = [currentStatement objectForKey:@"text"];
                
                // Check if we have to modify it
                BOOL currentExecutionStatement = [statementID isEqualToString:self.stepStatement];
                if (currentExecutionStatement == YES) {
                    CGContextSaveGState(context);
                    CGContextSetFillColorWithColor(context, self.stepFontColor.CGColor);
                }

                // Display the statement text
                const char *cStringText = [statementText cStringUsingEncoding:NSASCIIStringEncoding];
                size_t lengthCString = strlen(cStringText);
                CGContextShowTextAtPoint(context, currentPosition.x, currentPosition.y, cStringText, lengthCString);

                // Restore the original context
                if (currentExecutionStatement == YES) {
                    CGContextRestoreGState(context);
                }
                
                // Update our drawing position
                currentPosition = CGContextGetTextPosition(context);
            }
        }
        
        // Set our new position for the next line
        currentPosition.x = startPosition.x;
        currentPosition.y += self.displayFont.pointSize;
        
        // Update the content size for the scroll view
        CGPoint drawingContext = CGContextGetTextPosition(context);
        drawingContext.y = currentPosition.y - startPosition.y;
        if (self.contentSize.width < drawingContext.x || self.contentSize.height < drawingContext.y) {
            CGSize contentSize = CGSizeMake(MAX(self.contentSize.width, drawingContext.x), MAX(self.contentSize.height, drawingContext.y));
            self.contentSize = contentSize;
        }
    }
}

@end
