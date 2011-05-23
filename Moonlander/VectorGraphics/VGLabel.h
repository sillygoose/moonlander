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
    NSString *_text;
    UIFont *_font;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *font;

- (id)initWithFrame:(CGRect)frameRect;

@end

