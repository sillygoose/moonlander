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
}

@property (nonatomic) CGFloat fontSize;

- (id)initWithMessage:(NSString *)msgName;

@end

