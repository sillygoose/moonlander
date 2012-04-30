//
//  WebPageViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/30/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageViewController : UIViewController
{
                NSString            *_urlName; 
    IBOutlet    UIWebView           *_urlContent;
}

@property (nonatomic, strong) NSString *urlName;
@property (nonatomic, strong) UIWebView *urlContent;

@end
