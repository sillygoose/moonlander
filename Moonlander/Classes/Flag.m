//
//  Flag.m
//  Moonlander
//
//  Created by Rick Naro on 9/7/11.
//  Copyright 2011, 2012 Rick Naro. All rights reserved.
//

#import "Flag.h"

@implementation Flag

- (id)initWithOrigin:(CGPoint)origin
{
    CGRect flagRect = CGRectMake(origin.x, origin.y, 24, 24);
    self = [super initWithFrame:flagRect];
    if (self) {
        // No events for the man
        self.userInteractionEnabled = NO;
        
        NSString *flagPath = [[NSBundle mainBundle] pathForResource:@"Flag" ofType:@"plist"];
        NSDictionary *flagDict = [NSDictionary dictionaryWithContentsOfFile:flagPath];
        self.drawPaths = [flagDict objectForKey:@"paths"];
#ifdef DEBUG
        self.vectorName = @"[Man init]";
#endif
    }
    return self;
}

@end
