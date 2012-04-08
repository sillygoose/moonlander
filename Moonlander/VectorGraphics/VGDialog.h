//
//  VGDialog.h
//  Moonlander
//
//  Created by Rick Naro on 10/3/11.
//  Copyright (c) 2011 Silly Goose Software. All rights reserved.
//
//  Used to create a simple modal yes/no dialog
//

#import "VGView.h"
#import "VGButton.h"
#import "VGLabel.h"


@interface VGDialog : VGView {
    VGButton    *_dialogYesButton;
    VGButton    *_dialogNoButton;
    VGLabel     *_dialogText;
    
    BOOL        _userSelection;
    
    id          _callerMethod;
    SEL         _onSelection;
}

@property (nonatomic, retain) VGButton *dialogYesButton;
@property (nonatomic, retain) VGButton *dialogNoButton;
@property (nonatomic, retain) VGLabel *dialogText;

@property (nonatomic) BOOL userSelection;

@property (nonatomic) SEL onSelection;
@property (nonatomic, retain) id callerMethod;


- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect addTarget:(id)target onSelection:(SEL)sel;

- (BOOL)dialogResult;

- (IBAction)newGameYesButtonPushed:(id)sender;
- (IBAction)newGameNoButtonPushed:(id)sender;

@end
