//
//  Lander.m
//  Moonlander
//
//  Created by Rick on 5/24/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "Lander.h"


@implementation Lander

@synthesize thrust=_thrust;


- (id)init
{
    CGRect landerRect = CGRectMake(200, 200, 96, 96);
    self = [super initWithFrame:landerRect];
    if (self) {
        NSString *landerPath = [[NSBundle mainBundle] pathForResource:@"Lander" ofType:@"plist"];
        NSDictionary *landerDict = [NSDictionary dictionaryWithContentsOfFile:landerPath];
        self.drawPaths = [landerDict objectForKey:@"paths"];
        self.vectorName = @"[Lander initWithFrame]";
        
        CGRect thrustRect = CGRectMake(32, 72, 32, 32);
        self.thrust = [[VGView alloc] initWithFrame:thrustRect];
        //##
        NSString *thrustValue = [NSString stringWithFormat:@"AAAAAAA"];
        NSDictionary *currentThrustPath = [NSDictionary dictionaryWithObjectsAndKeys:thrustValue, @"text", nil];
        NSArray *path = [NSArray arrayWithObject:currentThrustPath];
        NSArray *paths = [NSArray arrayWithObject:path];
        self.thrust.drawPaths = paths;
        //##
        [self addSubview:self.thrust];
    }
    return self;
}

-(void)updateDrawingDictonary
{
    [self setNeedsDisplay];
}


@end
