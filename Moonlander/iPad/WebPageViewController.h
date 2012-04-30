//
//  WebPageViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/30/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageViewController : UIViewController <UIWebViewDelegate>
{
                NSString                    *_urlName; 
    IBOutlet    UIWebView                   *_urlContent;
                UIActivityIndicatorView     *_activetyIndicator;
}

@property (nonatomic, strong) NSString *urlName;
@property (nonatomic, strong) UIWebView *urlContent;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
