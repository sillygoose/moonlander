//
//  AboutViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Silly Goose Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
    IBOutlet UIWebView                  *_aboutContent;
}

@property (nonatomic, strong) UIWebView *aboutContent;

@end
