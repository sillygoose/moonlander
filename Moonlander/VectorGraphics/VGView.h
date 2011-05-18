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
    
    float _minX;
    float _minY;
    float _maxX;
    float _maxY;
}

@property (nonatomic, retain) NSArray *drawPaths;
@property (nonatomic, copy) NSString *vectorName;

@property (nonatomic) float minX;
@property (nonatomic) float minY;
@property (nonatomic) float maxX;
@property (nonatomic) float maxY;

- (id)initWithFrame:(CGRect)frameRect;
- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName;

- (void)addPathFile:(NSString *)fileName; 

@end
