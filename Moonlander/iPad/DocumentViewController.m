//
//  DocumentViewController.m
//  Moonlander
//
//  Created by Rick Naro on 4/29/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import "DocumentViewController.h"

@interface DocumentViewController ()

@end

@implementation DocumentViewController

@synthesize documentName=_documentName;
@synthesize documentType=_documentType;
@synthesize documentURL=_documentURL;
@synthesize activityIndicator=_activetyIndicator;
@synthesize documentContent=_documentContent;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the delegate
    self.documentContent.delegate = self;
    
    // Replace the view with the activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.view = self.activityIndicator;
    
    // Load the document/web page
    NSString *path = [[NSBundle mainBundle] pathForResource:self.documentName ofType:self.documentType];
    NSLog(@"%@", path);
    self.documentURL = (path == nil) ? [NSURL URLWithString:self.documentName] : [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.documentURL];
    [self.documentContent loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Allow scrolling/zooming in a document
    self.documentContent.scalesPageToFit = YES;
    
    // Add the document to the navigation bar
    if ([self.documentURL isFileURL]) {
        self.title = self.documentName;
    }
    
    // Show the navagation bar in this view so we can get back
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; 
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    self.view = self.documentContent;
    self.documentContent.delegate = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [self.documentContent loadHTMLString:errorString baseURL:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
