//
//  SplashViewController.m
//  Moonlander
//
//  Created by Rick Naro on 5/5/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//

#import "SplashViewController.h"

#import <AVFoundation/AVFoundation.h>


@interface SplashViewController ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) dispatch_queue_t sceneQueue;

@end


@implementation SplashViewController

@synthesize sceneQueue, audioPlayer;

@synthesize firstPart=_firstPart;
@synthesize secondfPart=_secondPart;
@synthesize moonLander=_moonLander;



- (void)dismissSplashScreen
{
    [self performSegueWithIdentifier:@"MenuSegue" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the audio by playing a short clip at zero volume
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Initialize the audio by playing a short clip at zero volume
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"beep-low" ofType:@"caf"];
        NSURL *audioURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:NULL];
        self.audioPlayer.numberOfLoops = 0;
        [self.audioPlayer prepareToPlay];
        self.audioPlayer.volume = 0;
        [self.audioPlayer play];
    });

    UIFont *displayFont = [UIFont fontWithName:@"Vector Battle" size:72];
    UIFont *moonlanderFont = [UIFont fontWithName:@"Vector Battle" size:144];
    self.firstPart.font = displayFont;
    self.secondfPart.font = displayFont;
    self.moonLander.font = moonlanderFont;
    self.firstPart.alpha = self.secondfPart.alpha = self.moonLander.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

#ifdef DEBUG
    [self performSelector:@selector(dismissSplashScreen) withObject:nil afterDelay:0];
#else
    const float SplashScreenDelay = 3.0;
    const float textFadeInTime = 2.5;
    const float secondFadeInDelay = textFadeInTime + 0.5;
    const float textFadeOutTime = 2.5;
    
    void (^splashComplete)(BOOL) = ^(BOOL f) {
        [self performSelector:@selector(dismissSplashScreen) withObject:nil afterDelay:SplashScreenDelay];
    };
    void (^fadeOut)(void) = ^{
        self.firstPart.alpha = self.secondfPart.alpha = 0.0;
        self.moonLander.transform = CGAffineTransformIdentity;
    };
    void (^fadeInComplete)(BOOL) = ^(BOOL f) {
        self.moonLander.alpha = 1.0;
        self.moonLander.transform = CGAffineTransformMakeScale(0.05, 0.01);
        [UILabel animateWithDuration:textFadeOutTime delay:0.5 options:0 animations:fadeOut completion:splashComplete];
    };
    void (^fadeInFirst)(void) = ^{
        self.firstPart.alpha = 1.0;
    };
    void (^fadeInSecond)(void) = ^{
        self.secondfPart.alpha = 1.0;
    };
    
    // Fade in the splash screen
    [UILabel animateWithDuration:textFadeInTime animations:fadeInFirst];
    [UILabel animateWithDuration:textFadeInTime delay:secondFadeInDelay options:0 animations:fadeInSecond completion:fadeInComplete];
#endif
}

#if 0 //###
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#endif

@end
