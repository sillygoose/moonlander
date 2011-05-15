//
//  VGSlider.h
//  Moonlander
//
//  Created by Silly Goose on 5/15/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VGSlider : UIControl {
    NSArray *_drawPaths;
}

@property (nonatomic, retain) NSArray *drawPaths;

- (id)initWithFile:(NSString *)fileName;

@end
