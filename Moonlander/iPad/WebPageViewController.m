//
//  WebPageViewController.m
//  Moonlander
//
//  Created by Rick Naro on 4/30/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "WebPageViewController.h"

@implementation WebPageViewController

@synthesize urlName=_urlName;
@synthesize urlContent=_urlContent;
@synthesize activityIndicator=_activetyIndicator;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Allow scrolling/zooming in a document
    self.urlContent.scalesPageToFit = YES;
    
    // Repalce the view with the activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.view = self.activityIndicator;

    // Set up the delegate
    self.urlContent.delegate = self;
    
    // Create a URL object.
    NSURL *url = [NSURL URLWithString:self.urlName];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.urlContent loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show the navagation bar in this view so we can get back
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; 
    //###self.title = self.urlName;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    self.view = self.urlContent;
    self.urlContent.delegate = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [self.urlContent loadHTMLString:errorString baseURL:nil];
}

@end
