//
//  Moon.h
//  Moonlander
//
//  Created by Rick on 5/26/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VGView.h"
#import "Lander.h"

typedef enum { TF_Nothing = 0, TF_OldLander, TF_OldFlag, TF_OldLanderTippedLeft, TF_OldLanderTippedRight, TF_Rock, TF_McDonaldsEdge, TF_McDonalds } TerrainFeature;

typedef enum { TV_Unknown, TV_Normal, TV_Detailed } TerrainView;


@protocol MoonDataSource <NSObject>
- (short)terrainHeight:(short)index;
- (short)averageTerrainHeight:(short)index;
@end

@interface Moon : VGView <MoonDataSource> {
    NSMutableArray      *_moonArray;
    BOOL                _dirtySurface;
    
    short               _MACX;
    short               _MACY;
    BOOL                _displayHasMcDonalds;
    BOOL                _mcdExists;
    
    TerrainView         _currentView;
    short               _LEFTEDGE;
    
    id <MoonDataSource> __unsafe_unretained _dataSource ;
}

@property (nonatomic) NSMutableArray *moonArray;
@property (nonatomic) BOOL dirtySurface;

@property (nonatomic) short MACX;
@property (nonatomic) short MACY;
@property (nonatomic) BOOL displayHasMcDonalds;
@property (nonatomic) BOOL mcdExists;

@property (nonatomic) TerrainView currentView;
@property (nonatomic) short LEFTEDGE;

@property (unsafe_unretained) id <MoonDataSource> dataSource;

- (id)initWithFrame:(CGRect)frameRect;

- (void)refreshCloseUpView;
- (void)useCloseUpView:(short)xCoordinate;
- (void)useNormalView;
- (BOOL)viewIsDetailed;

- (short)terrainHeight:(short)index;
- (short)averageTerrainHeight:(short)index;
- (void)setTerrainHeight:(short)newHeight atIndex:(short)index;
- (void)modifyTerrainHeight:(short)deltaHeight atIndex:(short)index;

- (TerrainFeature)featureAtIndex:(short)index;
- (BOOL)hasFeature:(TerrainFeature)feature atIndex:(short)index;
- (void)addFeature:(TerrainFeature)feature atIndex:(short)index;
- (void)removeFeature:(TerrainFeature)feature atIndex:(short)index;

- (void)alterMoon:(short)alterMoon atIndex:(short)index;

@end
