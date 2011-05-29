//
//  Moon.m
//  Moonlander
//
//  Created by Rick on 5/26/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "Moon.h"


@implementation Moon

//@synthesize lander=_lander;
@synthesize moonDict=_moonDict;
@synthesize positionData=_positionData;

- (float)scaleY
{
    return 0;
}

- (id)initWithFrame:(CGRect)moonRect
{
    self = [super initWithFrame:moonRect];
    if (self) {
        NSString *moonPath = [[NSBundle mainBundle] pathForResource:@"Moon" ofType:@"plist"];
        self.moonDict = [NSDictionary dictionaryWithContentsOfFile:moonPath];
        //###self.drawPaths = [self.moonDict objectForKey:@"paths"];
        self.vectorName = @"[Moon init]";
        
        // Create the lander view with data sources
//        self.lander = [[Lander alloc] init];
//        self.lander.thrustData = Block_copy(^{ return [self.landerModel.dataSource thrustPercent];});
//        self.lander.angleData = Block_copy(^{ return [self.landerModel.dataSource angle];});
//        self.lander.positionData = Block_copy(^{ return [self.landerModel.dataSource landerPosition];});
//        [self addSubview:self.lander];
        
        // Start building the draw path now
        NSMutableArray *path = [[NSMutableArray alloc] init];
        NSArray *paths = [NSArray arrayWithObject:path];

        // Find the draw payh on the moon file
        NSArray *drawPaths = [NSArray arrayWithObject:[self.moonDict objectForKey:@"paths"]];        
        NSArray *moonDataArray = [[drawPaths objectAtIndex:0] objectAtIndex:0];
        
        // Intensity and line type variables
        int DRAWTY = 0;
        int DRAWTZ = 0;
        unsigned DTYPE = 0;
        unsigned DINT = 0;
        const int nextIndex = 4;
        const int firstIndex = 10;
        const int secondIndex = firstIndex + nextIndex;

        // Should be X = 0 in the array
        CGPoint previousPoint = CGPointMake(0, 0);
        NSDictionary *item = [moonDataArray objectAtIndex:firstIndex];
        
        float x = [[item objectForKey:@"x"] floatValue];
        float y = [[item objectForKey:@"y"] floatValue];
        y = y / 32 + 23;
        previousPoint.x = x;
        previousPoint.y = y;
                   
        NSNumber *xCoordinate = [NSNumber numberWithFloat:x];
        NSNumber *yCoordinate = [NSNumber numberWithFloat:y];
        NSDictionary *startItem = [NSDictionary dictionaryWithObjectsAndKeys:xCoordinate, @"x", yCoordinate, @"y", nil];
        NSDictionary *moveToStartItem = [NSDictionary dictionaryWithObjectsAndKeys:startItem, @"moveto", nil];
        [path addObject:moveToStartItem];
        
        for (int i = secondIndex; i < moonDataArray.count; i += nextIndex) {
            x = [[[moonDataArray objectAtIndex:i] objectForKey:@"x"] floatValue];
            y = [[[moonDataArray objectAtIndex:i] objectForKey:@"y"] floatValue];
            float scaledY = y / 32 + 23;
            
            // Intensity/line type update
            DRAWTY--;
            if (DRAWTY < 0) {
                DRAWTZ++;
                DRAWTZ &= 3;
                DRAWTZ++;
                DRAWTY = DRAWTZ;
                DINT = (DINT + 5) % 8;
                DTYPE = (DTYPE + 1) % 4;
                
                // Add line type and intensity
                NSDictionary *lineType = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:DTYPE], @"type", [NSNumber numberWithFloat:2.0f], @"width", nil];
                NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys:lineType, @"line", nil];
                NSDictionary *intensity = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:DINT], @"intensity", nil];
                [path addObject:line];
                [path addObject:intensity];
                //NSLog(@"X: %f   Intensity: %d    Line type: %d", x, DINT, DTYPE);
            }
            
            CGPoint drawToPoint = CGPointMake(x - previousPoint.x, scaledY - previousPoint.y);
            xCoordinate = [NSNumber numberWithInt:drawToPoint.x];
            yCoordinate = [NSNumber numberWithInt:drawToPoint.y];
            NSMutableDictionary *drawItem = [NSDictionary dictionaryWithObjectsAndKeys:xCoordinate, @"x", yCoordinate, @"y", nil];
            [path addObject:drawItem];
            
            //NSLog(@"%d  %3.0f  %3.0f  %3.0f %@", i, x, y, scaledY, NSStringFromCGPoint(drawToPoint));
            previousPoint.x = x;
            previousPoint.y = scaledY;
        }
        self.drawPaths = paths;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0 );
    [super drawRect:rect];
    CGContextRestoreGState(context);
}

- (void)dealloc
{
//    [_lander release];
    [_moonDict release];
    
    [super dealloc];
}

@end
