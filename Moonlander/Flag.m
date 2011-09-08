//
//  Flag.m
//  Moonlander
//
//  Created by Rick Naro on 9/7/11.
//  Copyright (c) 2011 Silly Goose Software. All rights reserved.
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
        self.vectorName = @"[Man init]";
        
        // We need to change the coordinate space to (0,0) in the lower left
        self.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
    }
    return self;
}

@end
