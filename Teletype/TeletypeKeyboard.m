//
//  TeletypeKeyboard.m
//  ROCKET Classic
//
//  Created by Rick Naro on 5/11/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "TeletypeKeyboard.h"


@interface TeletypeKeyboard ()

@property (nonatomic) keycode_t keyCode;

- (IBAction)keyboardNumeric:(id)sender;
- (IBAction)keyboardYesNo:(id)sender;
- (IBAction)keyboardRubout:(id)sender;
- (IBAction)keyboardReturn:(id)sender;
- (IBAction)keyboardQuit:(id)sender;

@end


@implementation TeletypeKeyboard

@synthesize keyCode;


#pragma mark -
#pragma mark Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Disable the keyvoard to start
        self.userInteractionEnabled = NO;
    }
    return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
}


#pragma mark -
#pragma mark Keyboard events (run on main queue)

- (IBAction)keyboardReturn:(id)sender
{
    self.keyCode = K_RETURN;
}

- (IBAction)keyboardQuit:(id)sender
{
    self.keyCode = K_QUIT;
}

- (IBAction)keyboardRubout:(id)sender
{
    self.keyCode = K_RUBOUT;
}

- (IBAction)keyboardNumeric:(id)sender;
{
    UIButton *numericButton = sender;
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *keyCodeValue = [numberFormat numberFromString:numericButton.titleLabel.text];
    self.keyCode = K_0 + keyCodeValue.charValue;
}

- (IBAction)keyboardYesNo:(id)sender
{
    UIButton *yesNoButton = sender;
    self.keyCode = ([yesNoButton.titleLabel.text isEqualToString:@"YES"]) ? K_YES : K_NO;
}


#pragma mark -
#pragma mark Keyboard interface methods

- (void)enableKeyboard
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
}

- (void)disableKeyboard
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = NO;
    });
}

- (keycode_t)getKey
{
    // Block to wait for the text field to close
    void (^getKeycode)(void) = ^{
        do {
            [NSThread sleepForTimeInterval:0.05];
        } while (self.keyCode == K_NONE);
    };
    
    // Setup our keycode state
    self.keyCode = K_NONE;
    
    // Enable the keyboard for touches
    [self enableKeyboard];
    
    // Wait for some input
    NSOperationQueue *inputQueue = [[NSOperationQueue alloc] init];
    NSBlockOperation *inputOp = [NSBlockOperation blockOperationWithBlock:getKeycode];
    NSArray *jobArray = [NSArray arrayWithObjects:inputOp, nil];
    [inputQueue addOperations:jobArray waitUntilFinished:YES];
    
    // Disable keyboard
    [self disableKeyboard];
    
    // Return the input key code
    return self.keyCode;
}

@end
