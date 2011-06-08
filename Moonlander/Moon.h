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

typedef enum { TF_Nothing = 0, TF_OldLander, TF_OldFlag, TF_OldLanderTippedLeft, TF_OldLanderTippedRight, TF_Rock, TF_McDonaldsEdge, TF_McDonalds } TerrainFeature;

typedef enum { TV_Unknown, TV_Normal, TV_Detailed } TerrainView;


@protocol MoonDataSource <NSObject>
- (short)terrainHeight:(short)xCoordinate;
@end

@interface Moon : VGView <MoonDataSource> {
    NSMutableArray      *_moonArray;
    
    TerrainView         _currentView;
    short               _LEFTEDGE;
    
    id <MoonDataSource> _dataSource ;
}

@property (nonatomic, retain) NSMutableArray *moonArray;

@property (nonatomic) TerrainView currentView;
@property (nonatomic) short LEFTEDGE;

@property (assign) id <MoonDataSource> dataSource;

- (id)initWithFrame:(CGRect)frameRect;

- (void)useCloseUpView:(short)xCoordinate;
- (void)useNormalView;
- (BOOL)viewIsDetailed;

- (TerrainFeature)featureAtIndex:(short)index;
- (BOOL)hasFeature:(TerrainFeature)feature atIndex:(short)index;
- (void)addFeature:(TerrainFeature)feature atIndex:(short)index;
- (void)removeFeature:(TerrainFeature)feature atIndex:(short)index;

@end
