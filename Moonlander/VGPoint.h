//
//  VGPoint.h
//  Moonlander
//
//  Created by Rick Naro on 4/21/12.
//  Copyright (c) 2012 Silly Goose Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGView.h"

@interface VGPoint : VGView
{
    NSMutableArray             *_points;
}

@property (nonatomic) NSMutableArray *points;
    
@end
