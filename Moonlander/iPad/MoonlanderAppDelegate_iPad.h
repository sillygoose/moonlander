//
//  MoonlanderAppDelegate_iPad.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoonlanderAppDelegate.h"

#import "LanderViewController_iPad.h"

@interface MoonlanderAppDelegate_iPad : MoonlanderAppDelegate {
    LanderViewController_iPad   *_landerViewController;
    VGView                      *_splashView;
    Moon                        *_moonSplashView;
}

@property (nonatomic, retain) IBOutlet LanderViewController_iPad *landerViewController;

@property (nonatomic, retain) VGView *splashView;
@property (nonatomic, retain) Moon *moonSplashView;

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
