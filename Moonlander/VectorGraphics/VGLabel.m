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
    
    NSDictionary *text = [NSDictionary dictionaryWithObjectsAndKeys:newText, @"text", nil];
    NSArray *path = [NSArray arrayWithObjects:text, nil];
    NSArray *paths = [NSArray arrayWithObject:path];
    self.drawPaths = paths;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [super dealloc];
}

@end
