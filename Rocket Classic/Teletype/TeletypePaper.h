//
//  TeletypePaper.h
//  ROCKET Classic
//
//  Created by Rick Naro on 6/4/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TeletypePrintOutput.h"


@interface TeletypePaper : UIScrollView

@property (nonatomic, strong) IBOutlet TeletypePrintOutput *printerOutput;


@end
