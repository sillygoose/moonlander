//
//  VGDialog.m
//  Moonlander
//
//  Created by Rick Naro on 10/3/11.
//  Copyright (c) 2011 Silly Goose Software. All rights reserved.
//

#import "VGDialog.h"

@implementation VGDialog

@synthesize dialogYesButton=_dialogYesButton;
@synthesize dialogNoButton=_dialogNoButton;
@synthesize dialogText=_dialogText;

@synthesize userSelection=_userSelection;

@synthesize onSelection=_onSelection;
@synthesize callerMethod=_callerMethod; 


- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        // Rectangles for dialog components
        CGRect textRect = CGRectMake(0, 0, frameRect.size.width, frameRect.size.height/2);
        CGRect yesRect = CGRectMake(frameRect.size.width/8, frameRect.size.height/2, frameRect.size.width/4, frameRect.size.height/4);
        CGRect noRect = CGRectMake(frameRect.size.width/2 + frameRect.size.width/8, frameRect.size.height/2, frameRect.size.width/4, frameRect.size.height/4);
        
        // Font info
        UIFont *fontInfo = [UIFont fontWithName:@"Courier" size:12.0f];
        
        // Button font/background colors
        UIColor *buttonText = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];//[UIColor blackColor];
        UIColor *buttonBackground = [UIColor colorWithRed:0.026f green:1.0f blue:0.00121f alpha:1.0f];

        // Text label font/background colors
        UIColor *labelText = [UIColor colorWithRed:0.026f green:1.0f blue:0.00121f alpha:1.0f];
        UIColor *labelBackground = [UIColor blackColor] ;

        // Create the text label 
        self.dialogText = [[VGLabel alloc] initWithFrame:textRect];
        self.dialogText.text = @"New game?";
        self.dialogText.font = fontInfo;
        self.dialogText.textColor = labelText;
        self.dialogText.textAlignment = UITextAlignmentCenter;
        self.dialogText.backgroundColor = labelBackground;
        [self addSubview:self.dialogText];

        // Buttons are black text on a green background
        self.dialogYesButton = [[VGButton alloc] initWithFrame:yesRect];
        self.dialogYesButton.titleLabel.text = @"Yes";
        self.dialogYesButton.titleLabel.font = fontInfo;
        self.dialogYesButton.titleLabel.textColor = buttonText;
        self.dialogYesButton.titleLabel.backgroundColor = buttonBackground;
        self.dialogYesButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.dialogYesButton];

        self.dialogNoButton = [[VGButton alloc] initWithFrame:noRect];
        self.dialogNoButton.titleLabel.text = @"No";
        self.dialogNoButton.titleLabel.font = fontInfo;
        self.dialogNoButton.titleLabel.textColor = buttonText;
        self.dialogNoButton.titleLabel.backgroundColor = buttonBackground;
        self.dialogNoButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:self.dialogNoButton];
        
        // For debugging purposes
        self.vectorName = @"[VGDialog initWithFrame]";
        //self.backgroundColor = [UIColor grayColor];
        
        // Register the buttons
        [self.dialogYesButton addTarget:self action:@selector(newGameYesButtonPushed:) forControlEvents:UIControlEventValueChanged];
        [self.dialogNoButton addTarget:self action:@selector(newGameNoButtonPushed:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frameRect addTarget:(id)target onSelection:(SEL)sel
{
    self = [self initWithFrame:frameRect];
    if (self) {
        self.callerMethod = target;
        self.onSelection = sel;
    }
    return self;
}

- (BOOL)dialogResult
{
    return self.userSelection;
}

- (IBAction)newGameYesButtonPushed:(id)sender
{
    self.userSelection = YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.callerMethod performSelector:self.onSelection];
#pragma clang diagnostic pop
}

- (IBAction)newGameNoButtonPushed:(id)sender
{
    self.userSelection = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.callerMethod performSelector:self.onSelection];
#pragma clang diagnostic pop
}

@end
