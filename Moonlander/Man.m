//
//  Man.m
//  Moonlander
//
//  Created by Rick Naro on 9/7/11.
///  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "Man.h"

@implementation Man

- (id)initWithOrigin:(CGPoint)origin
{
    CGRect manRect = CGRectMake(origin.x, origin.y, 15, 15);
    self = [super initWithFrame:manRect];
    if (self) {
        // No events for the man
        self.userInteractionEnabled = NO;
        
        NSString *manPath = [[NSBundle mainBundle] pathForResource:@"Man" ofType:@"plist"];
        NSDictionary *manDict = [NSDictionary dictionaryWithContentsOfFile:manPath];
        self.drawPaths = [manDict objectForKey:@"paths"];
        self.vectorName = @"[Man init]";
        
        // Adjust the center for the width of the man
        self.center = CGPointMake(self.center.x - (self.frame.size.width / 2), self.center.y);
    }
    return self;
}

@end
