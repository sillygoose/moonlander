//
//  LanderMessage.m
//  Moonlander
//
//  Created by Rick on 5/23/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderMessage.h"
#import "VGLabel.h"


@implementation LanderMessages

@synthesize landerMessages=_landerMessages;
@synthesize displayedMessages=_displayedMessages;


- (id)init
{
    self = [super init];
    if (self) {
        NSString *msgsFile = [[NSBundle mainBundle] pathForResource:@"LanderMessages" ofType:@"plist"];
        NSDictionary *messages = [NSDictionary dictionaryWithContentsOfFile:msgsFile];
        self.landerMessages = [messages objectForKey:@"messages"];
        self.displayedMessages = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addLanderMessage:(NSString *)message
{
    if (![self.displayedMessages objectForKey:message]) {
        NSDictionary *landerMessage = [self.landerMessages objectForKey:message];

        CGRect frameRect ;
        NSDictionary *frame = [landerMessage objectForKey:@"frame"];
        NSDictionary *origin = [frame objectForKey:@"origin"];
        NSDictionary *size = [frame objectForKey:@"size"];
        frameRect.origin.x = [[origin objectForKey:@"x"] floatValue];
        frameRect.origin.y = [[origin objectForKey:@"y"] floatValue];
        frameRect.size.width = [[size objectForKey:@"width"] floatValue];
        frameRect.size.height = [[size objectForKey:@"height"] floatValue];
        
        // Create a label and add it as a subview and to the dictionary
        VGLabel *messageLabel = [[[VGLabel alloc] initWithFrame:frameRect] retain];
        messageLabel.drawPaths = [landerMessage objectForKey:@"text"];
        messageLabel.vectorName = message;
        [self addSubview:messageLabel];
        [self.displayedMessages setObject:messageLabel forKey:message];
        [messageLabel release];

        // Request an update
        [self setNeedsDisplay];
    }
}

- (void)removeLanderMessage:(NSString *)message
{
    VGLabel *label = [self.displayedMessages objectForKey:message];
    if (label) {
        [self.displayedMessages removeObjectForKey:message];
        [label removeFromSuperview];
        [self setNeedsDisplay];
    }
}

- (void)removeAllLanderMessages
{
    NSArray *allMessageKeys = [self.displayedMessages allKeys];
    NSEnumerator *keyEnumerator = [allMessageKeys objectEnumerator];
    NSString *key;
    while ((key = [keyEnumerator nextObject])) {
        [self removeLanderMessage:key];
    }    
}

- (void)dealloc
{
    [self removeAllLanderMessages];
    
    [_landerMessages release];
    [_displayedMessages release];
    
    [super dealloc];
}

@end
