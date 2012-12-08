//
//  Controls.h
//  Moonlander
//
//  Created by Rick Naro on 5/17/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Controls : UIView
{
    IBOutlet UISwitch *_stepEnabled;
    IBOutlet UISlider *_stepInterval;
    IBOutlet UISlider *_teletypeVolume;
}

@property (nonatomic) IBOutlet UISwitch *stepEnabled;
@property (nonatomic) IBOutlet UISlider *stepInterval;
@property (nonatomic) IBOutlet UISlider *teletypeVolume;

@end
