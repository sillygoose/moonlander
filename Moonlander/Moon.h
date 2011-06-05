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

enum LanderFeatures { FeatureLander = 1, FeatureFlag, FeatureTippedLeft, FeatureTippedRight };

@protocol MoonDataSource <NSObject>
- (float)terrainHeight:(short)xCoordinate;
@end

@interface Moon : VGView <MoonDataSource> {
    NSMutableArray      *_moonArray;
    float               _LEFTEDGE;
    
    id <MoonDataSource> _dataSource ;
}

@property (nonatomic, retain) NSMutableArray *moonArray;
@property (nonatomic) float LEFTEDGE;

@property (assign) id <MoonDataSource> dataSource;

- (id)initWithFrame:(CGRect)frameRect;

- (void)viewCloseUp:(float)xCoordinate;
- (void)viewNormal;
- (BOOL)viewIsCloseup;

- (void)addFeature:(int)feature atPosition:(int)index;

@end
