//
//  VGView.h
//  Moonlander
//
//  Created by Silly Goose on 5/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VGView : UIView {
    NSArray *_drawPaths;
    NSString *_vectorName;
    
    CGRect _actualBounds;
}

@property (nonatomic, retain) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic) CGRect actualBounds;


- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;

- (void)addPathFile:(NSString *)fileName; 

@end
