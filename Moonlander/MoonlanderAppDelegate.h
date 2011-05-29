//
//  MoonlanderAppDelegate.h
//  Moonlander
//
//  Created by Silly Goose on 5/10/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoonlanderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
