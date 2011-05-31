//
//  Moon.m
//  Moonlander
//
//  Created by Rick on 5/26/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "Moon.h"


@implementation Moon

@synthesize moonDict=_moonDict;
@synthesize moonArray=_moonArray;
@synthesize dataSource=_dataSource;


- (id)initWithFrame:(CGRect)moonRect
{
    self = [super initWithFrame:moonRect];
    if (self) {
        // No events for the moon
        self.userInteractionEnabled = NO;
        
        NSString *moonPath = [[NSBundle mainBundle] pathForResource:@"Moon" ofType:@"plist"];
        self.moonDict = [NSDictionary dictionaryWithContentsOfFile:moonPath];
        self.vectorName = @"[Moon init]";
        
        // Cache the terrain data
        self.moonArray = [[[NSArray arrayWithObject:[self.moonDict objectForKey:@"paths"]] objectAtIndex:0] objectAtIndex:0];
    }
    return self;
}

- (float)terrainHeight:(int)xCoordinate
{
    unsigned averageHeight = 0;
    if (xCoordinate >= 0 && xCoordinate < self.moonArray.count) {
        if (xCoordinate == (self.moonArray.count - 1)) {
            float elevation1 = [[[self.moonArray objectAtIndex:(xCoordinate)] objectForKey:@"x"] floatValue];
            averageHeight = (int)elevation1;
        }
        else {
            float elevation1 = [[[self.moonArray objectAtIndex:(xCoordinate)] objectForKey:@"x"] floatValue];
            float elevation2 = [[[self.moonArray objectAtIndex:(xCoordinate+1)] objectForKey:@"x"] floatValue];
            averageHeight = (int)((elevation1 + elevation2) / 2);
        }
    }
    return averageHeight;
}

- (NSArray *)buildDetailedLunarSurface
{
    return nil;
}

- (NSArray *)buildInitialLunarSurface
{
    // Start building the draw path now
    NSMutableArray *path = [[NSMutableArray alloc] init];
    NSArray *paths = [NSArray arrayWithObject:path];
    
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
    NSDictionary *item = [self.moonArray objectAtIndex:firstIndex];
    
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
    
    for (int i = secondIndex; i < self.moonArray.count; i += nextIndex) {
        x = [[[self.moonArray objectAtIndex:i] objectForKey:@"x"] floatValue];
        y = [[[self.moonArray objectAtIndex:i] objectForKey:@"y"] floatValue];
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
    return paths;
}

- (NSArray *)buildMoonSurface
{
    return [self buildInitialLunarSurface];
}

- (void)drawRect:(CGRect)rect
{
    // Build the lunar surface (detailed or not)
    self.drawPaths = [self buildMoonSurface];
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0 );
    [super drawRect:rect];
    CGContextRestoreGState(context);
}

- (void)dealloc
{
    [_moonDict release];
    
    [super dealloc];
}

@end
