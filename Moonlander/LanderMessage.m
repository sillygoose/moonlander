//
//  LanderMessage.m
//  Moonlander
//
//  Created by Rick on 5/23/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "LanderMessage.h"

@implementation LanderMessage

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
    if (self) {
        // Initialize the draw path from the plist
        self.drawPaths = [msg objectForKey:@"text"];
        self.vectorName = msgName;
    }
    return self;
}

@end
