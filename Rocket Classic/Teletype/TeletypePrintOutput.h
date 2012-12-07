//
//  TeletypePrintOutput.h
//  ROCKET Classic
//
//  Created by Rick Naro on 6/4/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TeletypePrintOutputDelegate <NSObject>

@required
- (UIFont *)font;
- (UIColor *)fontColor;

- (NSArray *)textLines;

- (NSInteger)maxChars;

@end


@interface TeletypePrintOutput : UIView
{
	id <TeletypePrintOutputDelegate, NSObject> __unsafe_unretained delegate;
}

@property (nonatomic, unsafe_unretained) IBOutlet id<TeletypePrintOutputDelegate> delegate;

@end

