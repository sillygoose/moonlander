//
//  LanderMessage.m
//  Moonlander
//
//  Created by Rick on 5/23/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "LanderMessage.h"
#import "VGLabel.h"


@implementation LanderMessages

@synthesize landerMessages=_landerMessages;
@synthesize displayedMessages=_displayedMessages;

@synthesize fuelWarningOn=_fuelWarningOn;

@synthesize delegate=_delegate;


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
    NSDictionary *frameItem = [message objectForKey:@"frame"];
    NSDictionary *originItem = [frameItem objectForKey:@"origin"];
    NSDictionary *sizeItem = [frameItem objectForKey:@"size"];
    rect.origin.x = [[originItem objectForKey:@"x"] floatValue];
    rect.origin.y = [[originItem objectForKey:@"y"] floatValue];
    rect.size.width = [[sizeItem objectForKey:@"width"] floatValue];
    rect.size.height = [[sizeItem objectForKey:@"height"] floatValue];
    return rect;
}

- (BOOL)hasSystemMessage
{
    BOOL hasSystemMessage = NO;
    if ([self currentSystemMessage]) {
        hasSystemMessage = YES;
    }
    return hasSystemMessage;
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
        fuelLabel.fontSize = self.delegate.gameFontSize;
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
        sysLabel.fontSize = self.delegate.gameFontSize;
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
    flameLabel.fontSize = self.delegate.gameFontSize;
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

- (void)test
{
    __block float delayTime = 5.0;
    const float showNextMessage = 4.0;
    const float clearNextMessage = 3.0;
    __block NSMutableArray *messageItems = [NSMutableArray array];
    __block NSMutableArray *removeItems = [NSMutableArray array];
    dispatch_queue_t messageQueue = dispatch_queue_create("com.devtools.moonlander.messages", NULL);
    dispatch_queue_t removeQueue = dispatch_queue_create("com.devtools.moonlander.remove", NULL);

    void (^createMessage)(void) = ^{
        void (^removeMessage)(void) = ^{
            if ([removeItems count]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    VGLabel *label = [removeItems objectAtIndex:0];
                    [removeItems removeObject:0];
                    if (label) {
                        [self removeAllLanderMessages];
                    }
                });
            }
        };
        
        VGLabel *sysLabel  = [messageItems lastObject];
        [messageItems removeLastObject];
        [removeItems addObject:sysLabel];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            sysLabel.hidden = NO;
            [self addSubview:sysLabel];
        });
        [self.displayedMessages setObject:sysLabel forKey:@"SYSMES"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, clearNextMessage * NSEC_PER_SEC);
        dispatch_after(popTime, removeQueue, removeMessage);
    };

    NSEnumerator *messageEnumerator = [self.landerMessages objectEnumerator];
    NSDictionary *currentMessage;
    while ((currentMessage = [messageEnumerator nextObject])) {
        CGRect frameRect = [self getRect:currentMessage];
        VGLabel *sysLabel = [[VGLabel alloc] initWithFrame:frameRect];
        sysLabel.fontSize = self.delegate.gameFontSize;
        sysLabel.drawPaths = [currentMessage objectForKey:@"text"];
        sysLabel.vectorName = @"test";
        sysLabel.hidden = YES;

        [messageItems addObject:sysLabel];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayTime);
        dispatch_after(popTime, messageQueue, createMessage);
        delayTime += showNextMessage * NSEC_PER_SEC;
    }
}

@end
