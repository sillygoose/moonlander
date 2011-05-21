//
//  VGLabel.h
//  Moonlander
//
//  Created by Silly Goose on 5/18/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VGView.h"

@interface VGLabel : VGView {
    CGFloat _fontSize;
    NSTimer *_blinkTimer;
    BOOL _blinkOn;
}

@property (nonatomic, assign) NSTimer *blinkTimer;
@property (nonatomic) BOOL blinkOn;
@property (nonatomic) CGFloat fontSize;

- (id)initWithMessage:(NSString *)msgName;

@end

