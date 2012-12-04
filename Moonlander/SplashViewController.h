//
//  SplashViewController.h
//  Moonlander
//
//  Created by Rick Naro on 5/5/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController
{
    UILabel             *_firstPart;
    UILabel             *_secondPart;
    UILabel             *_moonLander;
}

@property (nonatomic, strong) IBOutlet UILabel *firstPart;
@property (nonatomic, strong) IBOutlet UILabel *secondfPart;
@property (nonatomic, strong) IBOutlet UILabel *moonLander;

@end
