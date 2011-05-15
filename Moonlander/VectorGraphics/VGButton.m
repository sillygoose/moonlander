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

@synthesize drawPaths=_drawPaths;
@synthesize repeatTimer=_repeatTimer;
@synthesize autoRepeatInterval=_autoRepeatInterval;


- (id)initWithFile:(NSString *)fileName
{
    // Open the vector XML file and create the view
    NSDictionary *viewObject = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (viewObject) {
        NSArray *paths = [viewObject objectForKey:@"paths"];
        NSDictionary *frame = [viewObject objectForKey:@"frame"];
        NSDictionary *size = [frame objectForKey:@"size"];
        NSDictionary *origin = [frame objectForKey:@"origin"];
        CGRect frameRect = CGRectMake([[origin objectForKey:@"x"] floatValue], [[origin objectForKey:@"y"] floatValue], [[size objectForKey:@"width"] floatValue], [[size objectForKey:@"height"] floatValue]);
        
        self = [super initWithFrame:frameRect];
        if (self) {
            self.drawPaths = paths;
            
            [self addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
            [self addTarget:self action:@selector(buttonUp:) forControlEvents:(UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel)];
        }
    }
    else self = nil;
    return self;
}

- (id)initWithFile:(NSString *)fileName andRepeat:(float)repeatInterval
{
    [self initWithFile:fileName];
    self.autoRepeatInterval = repeatInterval;
    return self;
}

- (void)dealloc
{
    [_drawPaths release];
    [_repeatTimer release];
    [super dealloc];
}


- (void)drawRect:(CGRect)rect
{
	CGPoint midPoint;
	midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
	midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSEnumerator *pathEnumerator = [self.drawPaths objectEnumerator];
    NSArray *currentPath;
    while ((currentPath = [pathEnumerator nextObject])) {
        NSEnumerator *vectorEnumerator = [currentPath objectEnumerator];
        NSDictionary *currentVector;
        while ((currentVector = [vectorEnumerator nextObject])) {
            // Choices are "moveto", "color", "line", "x", "y"
            if ([currentVector objectForKey:@"moveto"]) {
                NSDictionary *moveTo = [currentVector objectForKey:@"moveto"];
                CGFloat x = [[moveTo objectForKey:@"x"] floatValue];
                CGFloat y = [[moveTo objectForKey:@"y"] floatValue];
                CGContextMoveToPoint(context, midPoint.x + x, midPoint.y + y);
            }
            if ([currentVector objectForKey:@"color"]) {
                NSDictionary *colorStuff = [currentVector objectForKey:@"color"];
                CGFloat r = [[colorStuff objectForKey:@"r"] floatValue];
                CGFloat g = [[colorStuff objectForKey:@"g"] floatValue];
                CGFloat b = [[colorStuff objectForKey:@"b"] floatValue];
                CGFloat alpha = [[colorStuff objectForKey:@"alpha"] floatValue];
                CGContextSetRGBStrokeColor(context, r, g, b, alpha);
            }
            if ([currentVector objectForKey:@"line"]) {
                if ([currentVector objectForKey:@"line"]) {
                    NSDictionary *lineStuff = [currentVector objectForKey:@"line"];
                    if ([lineStuff objectForKey:@"width"]) {
                        CGFloat width = [[lineStuff objectForKey:@"width"] floatValue];
                        CGContextSetLineWidth(context, width);
                    }
                }
            }
            if ([currentVector objectForKey:@"x"]) {
                CGFloat x = [[currentVector objectForKey:@"x"] floatValue];
                CGFloat y = [[currentVector objectForKey:@"y"] floatValue];
                CGContextAddLineToPoint(context, midPoint.x + x, midPoint.y + y);
            }
        }
    }
    CGContextStrokePath(context);
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

#if 0
#pragma mark Touch tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Beginning tracking: %@", event);
    //[self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Continue tracking: %@", event);
    // Send value changed alert
    //[self sendActionsForControlEvents:UIControlEventValueChanged];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)movePlayer:(id)sender
{
    NSLog(@"movePlayer: %@", sender);
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Ending tracking: %@", event);
}

- (void)touchesBegan:(NSSet*)touches  withEvent:(UIEvent*)event
{
    NSLog(@"touchesBegan: %@", event);
    self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(movePlayer:) userInfo:nil repeats:YES];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"touchesEnded: %@", event);
    if (self.repeatTimer != nil) 
        [self.repeatTimer invalidate];
    self.repeatTimer = nil;
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"touchesMoved: %@", event);
    if (self.repeatTimer != nil) {
        [self.repeatTimer invalidate];
        self.repeatTimer = nil;
    }
}
#endif

@end
