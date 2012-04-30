//
// HistoryViewController.h
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController {
    IBOutlet UIWebView                  *_historyContent;
}

@property (nonatomic, strong) UIWebView *historyContent;

@end
