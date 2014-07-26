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
@synthesize activityIndicator=_activityIndicator;
@synthesize documentContent=_documentContent;
@synthesize segueActive=_segueActive;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // If the destination view is the name pass the segue name as the content to display
    if ([segue.destinationViewController isKindOfClass:[DocumentViewController class]]) {
        DocumentViewController *dvc = segue.destinationViewController;
        NSURL *url = [NSURL URLWithString:segue.identifier];
        NSLog(@"%@", segue.identifier);
        if (url) {
            NSURL *urlSansExtension = [url URLByDeletingPathExtension];
            if ([url.scheme isEqualToString:@"http"]) {
                dvc.documentName = segue.identifier;
                dvc.documentType = nil;
            }
            else {
                dvc.documentName = [urlSansExtension relativePath];
                dvc.documentType = [url pathExtension];
            }
        }
        else {
            url = [NSURL fileURLWithPath:segue.identifier];
            NSURL *urlSansExtension = [url URLByDeletingPathExtension];
            DocumentViewController *dvc = segue.destinationViewController;
            dvc.documentType = [url pathExtension];
            dvc.documentName = [urlSansExtension relativePath];
        }
        dvc.segueActive = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Start up the activity indicator
    [self.activityIndicator startAnimating];
    
    // Load the document/web page
    NSString *path = [[NSBundle mainBundle] pathForResource:self.documentName ofType:self.documentType];
    self.documentURL = (path == nil) ? [NSURL URLWithString:self.documentName] : [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.documentURL];
    [self.documentContent loadRequest:request];

#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", @"DocumentView", self.documentName]];
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Allow scrolling/zooming in a document
    self.documentContent.scalesPageToFit = NO;

    // Show the navagation bar in this view so we can get back
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    // Hide the navagation bar when leaving the view
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"type: %d req: %@", navigationType, request.URL.absoluteString);
    BOOL result = YES;
    if (navigationType == UIWebViewNavigationTypeLinkClicked && self.segueActive == NO) {
        // Push a new web view to handle the request
        result = NO;

        // Check which name we use for local and web hrefs
        if ([request.URL.scheme isEqualToString:@"file"]) {
            [self performSegueWithIdentifier:request.URL.lastPathComponent sender:self];
        }
        else {
            [self performSegueWithIdentifier:request.URL.absoluteString sender:self];
        }
    }
    return result;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Report the error inside the webview
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
