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


@interface Moon : VGView {
    //Lander          *_lander;
    NSDictionary    *_moonDict;

    position_data_t _positionData;
}

//@property (nonatomic, retain) Lander *lander;
@property (nonatomic, retain) NSDictionary *moonDict;
@property (nonatomic, copy) position_data_t positionData;

- (id)initWithFrame:(CGRect)frameRect;

@end
