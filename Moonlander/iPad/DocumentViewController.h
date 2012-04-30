//
//  DocumentViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentViewController : UIViewController {
                NSString            *_documentName; 
    IBOutlet    UIWebView           *_documentContent;
}

@property (nonatomic, strong) NSString *documentName;
@property (nonatomic, strong) UIWebView *documentContent;

@end
