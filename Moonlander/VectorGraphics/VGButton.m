//
//  VGButton.m
//  Moonlander
//
//  Created by Silly Goose on 5/14/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGButton.h"

@interface VGButton()
@end

@implementation VGButton

@synthesize titleLabel=_titleLabel;
@synthesize repeatTimer=_repeatTimer;
@synthesize autoRepeatInterval=_autoRepeatInterval;
@synthesize actualBounds=_actualBounds;



- (id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        self.opaque = NO;

        self.titleLabel = [[VGLabel alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.height)];
        [self addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(buttonUp:) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel)];
        self.titleLabel.userInteractionEnabled = NO;
        [self addSubview:self.titleLabel];

        self.titleLabel.vectorName = @"[VGButton initWithFrame]";
    }
    return self;
}

- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName
{
    self = [self initWithFrame:frameRect];
    
    NSDictionary *viewObject = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (!(self.titleLabel.vectorName = [viewObject objectForKey:@"name"]))
        self.titleLabel.vectorName = @"[VGButton initWithFrame:withPaths:]";
    self.titleLabel.drawPaths = [viewObject objectForKey:@"paths"];
    return self;
}

- (id)initWithFrame:(CGRect)frameRect withPaths:(NSString *)fileName andRepeat:(float)repeatInterval
{
    self = [self initWithFrame:frameRect withPaths:fileName];
    self.autoRepeatInterval = repeatInterval;
    return self;
}

- (void)dealloc
{
    [_titleLabel release];
    [_repeatTimer release];
    [super dealloc];
}

- (void)addPathFile:(NSString *)fileName
{
    NSDictionary *viewObject = [NSDictionary dictionaryWithContentsOfFile:fileName];
    self.titleLabel.vectorName = [viewObject objectForKey:@"name"];
    self.titleLabel.drawPaths = [viewObject objectForKey:@"paths"];
}


- (void)buttonRepeat:(id)sender
{
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (IBAction)buttonDown:(id)sender
{
    if (self.autoRepeatInterval) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(buttonRepeat:) userInfo:nil repeats:YES];
    }
}

- (IBAction)buttonUp:(id)sender
{
    if (self.repeatTimer != nil) 
        [self.repeatTimer invalidate];
    self.repeatTimer = nil;
    
    if (!self.autoRepeatInterval) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
