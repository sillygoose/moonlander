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
@synthesize blink=_blink;


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

- (void)setBlink:(BOOL)blink
{
    _blink = blink;
    self.text = self.text;
}

- (void)setText:(NSString *)newText
{
    [_text release];
    _text = [newText copy];
    
#if 0 // Get this info from the instance variable font
    NSNumber *r = [NSNumber numberWithFloat:0.1f];
    NSNumber *g = [NSNumber numberWithFloat:1.0f];
    NSNumber *b = [NSNumber numberWithFloat:0.01f];
    NSNumber *a = [NSNumber numberWithFloat:1.0f];
    NSDictionary *color = [NSDictionary dictionaryWithObjectsAndKeys:r, @"r", g, @"g", b, @"b", a, @"alpha",nil];
   
    //NSDictionary *font = [NSDictionary dictionaryWithObjectsAndKeys:r, @"font" ,nil];
#endif

    // Create a display dictionary with the text and blink attribute
    NSDictionary *textDict = [NSDictionary dictionaryWithObjectsAndKeys:newText, @"text", [NSNumber numberWithBool:self.blink], @"blink", nil];
    
    NSArray *path = [NSArray arrayWithObjects:textDict, nil];
    NSArray *paths = [NSArray arrayWithObject:path];
    self.drawPaths = paths;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [super dealloc];
}

@end
