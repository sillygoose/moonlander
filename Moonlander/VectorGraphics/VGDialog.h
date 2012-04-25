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


@interface VGDialog : UIView {
    UIView      *_yesButtonView;
    UIButton    *_dialogYesButton;
    UIButton    *_dialogNoButton;
    UILabel     *_dialogText;
    
    UIColor     *_buttonBackgroundNormal;
    UIColor     *_buttonBackgroundHighlighted;
    
    BOOL        _userSelection;
    
    id          _callerMethod;
    SEL         _onSelection;
}

@property (nonatomic, strong) UIView *yesButtonView;

@property (nonatomic, strong) UIButton *dialogYesButton;
@property (nonatomic, strong) UIButton *dialogNoButton;
@property (nonatomic, strong) UILabel *dialogText;

@property (nonatomic, strong) UIColor *buttonBackgroundNormal;
@property (nonatomic, strong) UIColor *buttonBackgroundHighlighted;

@property (nonatomic) BOOL userSelection;

@property (nonatomic) SEL onSelection;
@property (nonatomic) id callerMethod;


- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect addTarget:(id)target onSelection:(SEL)sel;

- (BOOL)dialogResult;

@end
