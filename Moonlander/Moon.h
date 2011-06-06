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

typedef enum { FeatureNothing = 0, FeatureLander, FeatureFlag, FeatureTippedLeft, FeatureTippedRight, FeatureRock, FeatureMcDonaldsEdge, FeatureMcDonalds } LanderFeature;


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

- (BOOL)hasFeature:(LanderFeature)feature atIndex:(short)index;
- (void)addFeature:(LanderFeature)feature atIndex:(short)index;
- (void)removeFeature:(LanderFeature)feature atIndex:(short)index;

@end
