//
//  TeletypePrinter.m
//  ROCKET Classic
//
//  Created by Rick Naro on 6/4/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "TeletypePrinter.h"

#import <AVFoundation/AVFoundation.h>


@interface TeletypePrinter ()

@property (nonatomic, strong) AVAudioPlayer *teletypeAudioPlayer;

@property (nonatomic) float characterInterval;
@property (nonatomic) float soundVolume;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *textLines;

@property (nonatomic, strong) UIFont *displayFont;
@property (nonatomic, strong) UIColor *displayFontColor;

@property (atomic) BOOL doFlushPrintBuffer;
@property (atomic) BOOL printPaused;

@property (nonatomic) CGSize maxLineMetrics;

@end


@implementation TeletypePrinter

@synthesize scrollView, backgroundScrollView;
@synthesize teletypeAudioPlayer;
@synthesize characterInterval, soundVolume;
@synthesize text, textLines;
@synthesize displayFontColor, displayFont;
@synthesize doFlushPrintBuffer, printPaused;
@synthesize maxLineMetrics;


#ifdef DEBUG
//#define DEBUG_REALTIME
#endif


#pragma mark -
#pragma mark Delegate methods

- (UIFont *)font
{
    return displayFont;
}

- (UIColor *)fontColor
{
    return displayFontColor;
}

- (NSArray *)textLines
{
    return textLines;
}

- (NSInteger)maxChars
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 72 : 58;
}

- (void)fontSize:(CGFloat)newSize
{
    self.displayFont = [UIFont fontWithName:@"Teleprinter-Bold" size:newSize];
}

- (void)font:(UIFont *)newFont;
{
    displayFont = newFont; 
}

- (void)fontColor:(UIColor *)newColor
{
    displayFontColor = newColor; 
}


#pragma mark -
#pragma mark Setters/getters

- (void)setText:(NSString *)newText
{
    // Save our screen text
    text = newText;
    
    if (text != nil && ![text isEqualToString:@""]) {
        // Update our array of output lines
        unsigned beforeLines = self.textLines.count;
        self.textLines = [self.text componentsSeparatedByString:@"\n"];
        NSInteger newLines = self.textLines.count - beforeLines;
        
        // UI code block for running in the right thread
        void (^uiWork)(void) = ^{
            CGSize currentLine = CGSizeZero;
            CGSize newContentSize = CGSizeMake(0, self.textLines.count * self.displayFont.pointSize);
            NSInteger linesToProcess = newLines;
            if (linesToProcess != 0) {
                if (linesToProcess > 0) {
                    // Check the new lines for an increase in content width
                    unsigned i = self.textLines.count - 1;
                    while (linesToProcess--) {
                        CGSize lineMetrics = [[self.textLines objectAtIndex:i--] sizeWithFont:self.displayFont];
                        if (lineMetrics.width > newContentSize.width) {
                            CGSize newSize = CGSizeMake(lineMetrics.width, newContentSize.height);
                            newContentSize = newSize;
                        }
                        currentLine = lineMetrics;
                    }
                }
                else {
                    // Check all lines for an increase in content width
                    unsigned i = 0;
                    linesToProcess = self.textLines.count;
                    while (linesToProcess--) {
                        CGSize lineMetrics = [[self.textLines objectAtIndex:i++] sizeWithFont:self.displayFont];
                        if (lineMetrics.width > newContentSize.width) {
                            CGSize newSize = CGSizeMake(lineMetrics.width, newContentSize.height);
                            newContentSize = newSize;
                        }
                        currentLine = lineMetrics;
                    }
                }
            }
            else {
                // Just update the length of the current (last line)
                CGSize lineMetrics = [[self.textLines lastObject] sizeWithFont:self.displayFont];
                if (lineMetrics.width > newContentSize.width) {
                    CGSize newSize = CGSizeMake(lineMetrics.width, newContentSize.height);
                    newContentSize = newSize;
                }
                currentLine = lineMetrics;
            }
            
            // Limit the width to the print line size
            newContentSize.width = MIN(newContentSize.width, self.maxLineMetrics.width);
            currentLine.width = MIN(currentLine.width, self.maxLineMetrics.width);
            
            // Scale up the content size for display of entire font
            newContentSize.height += self.font.pointSize / 2;
            
            // Update the content size if changed
            UIEdgeInsets edgeInsets = self.scrollView.contentInset;
            if (self.scrollView.contentSize.width < newContentSize.width || self.scrollView.contentSize.height < newContentSize.height) {
                // Update the content size for the printing output scroll view
                CGSize contentSize = CGSizeMake(MAX(self.scrollView.contentSize.width, newContentSize.width), MAX(self.scrollView.contentSize.height, newContentSize.height));
                self.scrollView.contentSize = contentSize;

                // Check view size updates
                CGRect paperFrame = self.scrollView.printerOutput.frame;
                if (contentSize.width > paperFrame.size.width || contentSize.height > paperFrame.size.height) {
                    paperFrame.size = CGSizeMake(MAX(contentSize.width, paperFrame.size.width), MAX(contentSize.height, paperFrame.size.height));
                    self.scrollView.printerOutput.frame = paperFrame;
                }

                // Update the content size for the paper background scroll view
                CGRect paperBackgroundFrame = self.backgroundScrollView.background.frame;
                CGSize backgroundSize = CGSizeMake(self.backgroundScrollView.frame.size.width, newContentSize.height);
                backgroundSize.height += self.frame.size.height;
                
                self.backgroundScrollView.contentSize = backgroundSize;
                self.backgroundScrollView.contentOffset = CGPointMake(0, contentSize.height);
                
                // Adjust the background size for any edge insets
                backgroundSize.width += edgeInsets.left;
                backgroundSize.height += edgeInsets.top;
                paperBackgroundFrame.size = backgroundSize;
                self.backgroundScrollView.background.frame = paperBackgroundFrame;
            }
            
            // Update the contentOffset
            CGPoint newOffset = CGPointMake(-edgeInsets.left, -edgeInsets.top);
            [self.scrollView setContentOffset:newOffset animated:NO];
            
            [self.scrollView.printerOutput setNeedsDisplay];
            [self.scrollView setNeedsDisplay];
        };
        
        // See what queue we are on
        if ([NSThread isMainThread]) {
            uiWork();
        }
        else {
            // UI work in main queue
            dispatch_async(dispatch_get_main_queue(), uiWork);
        }
    }
}


#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Load a display terminal font
        self.displayFontColor = [UIColor blackColor];
        self.displayFont = [UIFont fontWithName:@"Teleprinter-Bold" size:16.5];
        
        // Printer view initialization - no scrollView yet
        self.text = @"";
       
        // Max line metrics
        NSString *maxLine = [NSString stringWithFormat:@"%0*d", [self maxChars], 0];
        self.maxLineMetrics = [maxLine sizeWithFont:self.displayFont];
        
        // Teletype output speed
#if defined(DEBUG) && !defined(DEBUG_REALTIME)
        self.characterInterval = 0.005;
#else
        self.characterInterval = 0.1;
#endif

        // Setup our TTY audio
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"teletype" ofType:@"aiff"];
        NSURL *audioURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        self.teletypeAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:NULL];
        self.teletypeAudioPlayer.numberOfLoops = -1;
        [self.teletypeAudioPlayer prepareToPlay];
        
        // Sound volume based on settings bundle
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.teletypeAudioPlayer.volume = [defaults floatForKey:@"optionAudioVolume"];
        
        // Notification setup
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushPrintQueueReceived:) name:@"flushPrintQueues" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teletypeVolumeChanged:) name:@"teletypeVolumeChanged" object:nil];
    }
    return self;
}


#pragma mark -
#pragma mark Class methods


- (void)addString:(NSString *)newText
{
    self.text = [self.text stringByAppendingString:newText];
}

- (NSString *)printBuffer
{
    return self.text;
}

- (void)printBuffer:(NSString *)newText
{
    self.text = newText;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    // Release notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
#pragma mark Notifications

- (void)flushPrintQueueReceived:(NSNotification *)notification
{
    self.doFlushPrintBuffer = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)teletypeVolumeChanged:(NSNotification *)notification
{
    NSNumber *volume = notification.object;
    self.teletypeAudioPlayer.volume = [volume floatValue];
}



#pragma mark -
#pragma mark Class methods

- (void)flushPrintBuffer
{
    self.doFlushPrintBuffer = YES;
}

- (void)pausePrintBuffer:(BOOL)action
{
    self.printPaused = action;
}

- (void)printString:(NSString *)printText
{
    __block NSString *printBuffer = printText;
    self.doFlushPrintBuffer = NO;
    self.printPaused = NO;
    
    void (^printString)(void) = ^{
        while (printBuffer.length > 0 && self.doFlushPrintBuffer == NO) {
            // Remove a character from the print buffer
            NSString *printChar = [printBuffer substringToIndex:1];
            printBuffer = [printBuffer substringFromIndex:1];
            
            // And add it to the text view
            [self addString:printChar];
            
            do {
                // Sleep for one character time
                [NSThread sleepForTimeInterval:self.characterInterval];
            } while (self.printPaused == YES && self.doFlushPrintBuffer == NO);
        }
    }; 
    
    assert(self.teletypeAudioPlayer.playing == NO);
    dispatch_sync(dispatch_get_main_queue(), ^{
        // Start teletype audio loop
        self.teletypeAudioPlayer.currentTime = 0;
        [self.teletypeAudioPlayer play];
    });
    
    // Print the output and wait until done
    NSOperationQueue *printQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *printOp = [NSBlockOperation blockOperationWithBlock:printString];
    NSArray *jobArray = [NSArray arrayWithObjects:printOp, nil];
    [printQueue addOperations:jobArray waitUntilFinished:YES];
    
    // Stop teletype audio loop and reset at beginning
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.teletypeAudioPlayer pause];
    });
    assert(self.teletypeAudioPlayer.playing == NO);
}

@end
