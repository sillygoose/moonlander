//
//  Moon.h
//  Moonlander
//
//  Created by Rick on 5/26/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VGView.h"
#import "Lander.h"


@protocol MoonDataSource <NSObject>
- (float)terrainHeight:(int)xCoordinate;
@end

@interface Moon : VGView <MoonDataSource> {
    NSDictionary        *_moonDict;
    NSArray             *_moonArray;
    
    id <MoonDataSource> _dataSource ;
}

@property (nonatomic, retain) NSDictionary *moonDict;
@property (nonatomic, retain) NSArray *moonArray;
@property (assign) id <MoonDataSource> dataSource;

- (id)initWithFrame:(CGRect)frameRect;

@end
