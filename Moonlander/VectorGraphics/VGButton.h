//
//  VGButtom.h
//  Moonlander
//
//  Created by Silly Goose on 5/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VGButton : UIControl {
    NSArray *_drawPaths;
    NSTimer *_repeatTimer;
    float _autoRepeatInterval;
}

@property (nonatomic, retain) NSArray *drawPaths;
@property (nonatomic, retain) NSTimer *repeatTimer;
@property (nonatomic) float autoRepeatInterval;

- (id)initWithFile:(NSString *)fileName;
- (id)initWithFile:(NSString *)fileName andRepeat:(float)repeatInterval;

@end
