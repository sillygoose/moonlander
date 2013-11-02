//
//  DocumentViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentViewController : UIViewController <UIWebViewDelegate>
{
                NSString                    *_documentName; 
                NSString                    *_documentType; 
                NSURL                       *_documentURL;
    IBOutlet    UIActivityIndicatorView     *_activityIndicator;
    IBOutlet    UIWebView                   *_documentContent;
                BOOL                        _segueActive;
}

@property (nonatomic, strong) NSString *documentName;
@property (nonatomic, strong) NSString *documentType;
@property (nonatomic, strong) NSURL *documentURL;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIWebView *documentContent;
@property (nonatomic) BOOL segueActive;

@end
