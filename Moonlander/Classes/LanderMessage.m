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
@synthesize fuelWarningOn=_fuelWarningOn;

- (id)init
{
    self = [super init];
    if (self) {
        // Populate the message database
        NSString *msgsFile = [[NSBundle mainBundle] pathForResource:@"LanderMessages" ofType:@"plist"];
        NSDictionary *messages = [NSDictionary dictionaryWithContentsOfFile:msgsFile];
        self.landerMessages = [messages objectForKey:@"messages"];
        self.displayedMessages = [NSMutableDictionary dictionaryWithCapacity:4];
        
        // Leave hidden until something to display
        self.hidden = YES;
    }
    return self;
}

- (CGRect)getRect:(NSDictionary *)message
{
    CGRect rect ;
    NSDictionary *frame = [message objectForKey:@"frame"];
    NSDictionary *origin = [frame objectForKey:@"origin"];
    NSDictionary *size = [frame objectForKey:@"size"];
    rect.origin.x = [[origin objectForKey:@"x"] floatValue];
    rect.origin.y = [[origin objectForKey:@"y"] floatValue];
    rect.size.width = [[size objectForKey:@"width"] floatValue];
    rect.size.height = [[size objectForKey:@"height"] floatValue];
    return rect;
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

- (void)addFuelMessage
{
    if (!self.fuelWarningOn) {
        NSDictionary *fuelMessage = [self.landerMessages objectForKey:@"FuelLow"];
        CGRect frameRect = [self getRect:fuelMessage];
        
        // Create a label and add it as a subview and to the dictionary
        VGLabel *fuelLabel = [[VGLabel alloc] initWithFrame:frameRect];
        fuelLabel.drawPaths = [fuelMessage objectForKey:@"text"];
        fuelLabel.vectorName = @"FuelLow";
        [self addSubview:fuelLabel];
        [self.displayedMessages setObject:fuelLabel forKey:@"FuelLow"];
        self.fuelWarningOn = YES;
        
        // Request an update
        [self setNeedsDisplay];        
    }
}

- (void)removeFuelMessage
{
    if (self.fuelWarningOn) {
        [self removeLanderMessage:@"FuelLow"];
        self.fuelWarningOn = NO;
    }
}

- (NSString *)currentSystemMessage
{
    VGLabel *msg = [self.displayedMessages objectForKey:@"SYSMES"];
    return msg.vectorName;
}

- (void)addSystemMessage:(NSString *)message
{
    if (([self currentSystemMessage] != message)) {
        VGLabel *prevMsg = [self.displayedMessages objectForKey:@"SYSMES"];
        if (prevMsg) {
            [prevMsg removeFromSuperview];
        }

        NSDictionary *sysMessage = [self.landerMessages objectForKey:message];
        CGRect frameRect = [self getRect:sysMessage];
        
        // Create a label and add it as a subview and to the dictionary
        VGLabel *sysLabel = [[VGLabel alloc] initWithFrame:frameRect];
        sysLabel.drawPaths = [sysMessage objectForKey:@"text"];
        sysLabel.vectorName = message;
        [self addSubview:sysLabel];
        [self.displayedMessages setObject:sysLabel forKey:@"SYSMES"];
        
        // Request an update
        [self setNeedsDisplay];     
    }
}

- (void)removeSystemMessage:(NSString *)message
{
    VGLabel *msg = [self.displayedMessages objectForKey:@"SYSMES"];
    if (msg) {
        if (message == nil || msg.vectorName == message) {
            [self removeLanderMessage:@"SYSMES"];
        }
    }
}

- (void)addFlameMessage:(NSString *)message
{
    VGLabel *prevMsg = [self.displayedMessages objectForKey:@"FSUBC"];
    if (prevMsg) {
        [prevMsg removeFromSuperview];
    }
    
    NSDictionary *flameMessage = [self.landerMessages objectForKey:message];
    CGRect frameRect = [self getRect:flameMessage];
    
    // Create a label and add it as a subview and to the dictionary
    VGLabel *flameLabel = [[VGLabel alloc] initWithFrame:frameRect];
    flameLabel.drawPaths = [flameMessage objectForKey:@"text"];
    flameLabel.vectorName = message;
    [self addSubview:flameLabel];
    [self.displayedMessages setObject:flameLabel forKey:@"FSUBC"];
    
    // Request an update
    [self setNeedsDisplay];        
}

- (void)removeFlameMessage:(NSString *)message
{
    VGLabel *msg = [self.displayedMessages objectForKey:@"FSUBC"];
    if (msg) {
        if (message == nil || msg.vectorName == message) {
            [self removeLanderMessage:@"FSUBC"];
        }
    }
}

@end
