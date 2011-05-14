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
    int _x ;
}

@property (nonatomic, retain) NSArray *drawPaths;
@property (nonatomic) int x;

@end
