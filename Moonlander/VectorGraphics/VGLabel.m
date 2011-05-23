//
//  VGLabel.m
//  Moonlander
//
//  Created by Silly Goose on 5/18/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "VGLabel.h"


@implementation VGLabel

@synthesize text=_text;
@synthesize font=_font;


- (id)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.font = [UIFont fontWithName:@"Courier" size:10.0f];
        self.vectorName = @"[VGLabel initWithFrame]";
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (id)initWithMessage:(NSString *)msgName
{
    NSString *msgsFile = [[NSBundle mainBundle] pathForResource:@"LanderMessages" ofType:@"plist"];
    NSDictionary *landerMessages = [NSDictionary dictionaryWithContentsOfFile:msgsFile];
    NSDictionary *msgs = [landerMessages objectForKey:@"messages"];
    NSDictionary *msg = [msgs objectForKey:msgName];

    NSDictionary *frame = [msg objectForKey:@"frame"];
    NSDictionary *origin = [frame objectForKey:@"origin"];
    NSDictionary *size = [frame objectForKey:@"size"];

    CGRect frameRect ;
    frameRect.origin.x = [[origin objectForKey:@"x"] floatValue];
    frameRect.origin.y = [[origin objectForKey:@"y"] floatValue];
    frameRect.size.width = [[size objectForKey:@"width"] floatValue];
    frameRect.size.height = [[size objectForKey:@"height"] floatValue];
    self = [self initWithFrame:frameRect];
    
    // Initialize the draw path from the plist
    self.drawPaths = [msg objectForKey:@"text"];
    self.vectorName = msgName;
    
    return self;
}

- (void)setText:(NSString *)newText
{
    [_text release];
    _text = [newText copy];
    
    NSNumber *r = [NSNumber numberWithFloat:0.1f];
    NSNumber *g = [NSNumber numberWithFloat:1.0f];
    NSNumber *b = [NSNumber numberWithFloat:0.01f];
    NSNumber *a = [NSNumber numberWithFloat:1.0f];
    NSDictionary *color = [NSDictionary dictionaryWithObjectsAndKeys:r, @"r", g, @"g", b, @"b", a, @"alpha",nil];
   
    //NSDictionary *font = [NSDictionary dictionaryWithObjectsAndKeys:r, @"font" ,nil];
    
    NSDictionary *text = [NSDictionary dictionaryWithObjectsAndKeys:newText, @"text", color, @"color", nil];
    NSArray *path = [NSArray arrayWithObjects:text, color, nil];
    NSArray *paths = [NSArray arrayWithObject:path];
    self.drawPaths = paths;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [super dealloc];
}

@end
