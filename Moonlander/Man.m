//
//  Man.m
//  Moonlander
//
//  Created by Rick Naro on 9/7/11.
//  Copyright (c) 2011 Silly Goose Software. All rights reserved.
//

#import "Man.h"

@implementation Man

- (id)initWithOrigin:(CGPoint)origin
{
    CGRect manRect = CGRectMake(origin.x, origin.y, 20, 20);
    self = [super initWithFrame:manRect];
    if (self) {
        // No events for the man
        self.userInteractionEnabled = NO;
        
        NSString *manPath = [[NSBundle mainBundle] pathForResource:@"Man" ofType:@"plist"];
        NSDictionary *manDict = [NSDictionary dictionaryWithContentsOfFile:manPath];
        self.drawPaths = [manDict objectForKey:@"paths"];
        self.vectorName = @"[Man init]";
        
    }
    return self;
}

@end
