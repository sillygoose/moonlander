//
//  Moon.m
//  Moonlander
//
//  Created by Rick on 5/26/11.
//  Copyright 2011 Silly Goose Software. All rights reserved.
//

#import "Moon.h"


@implementation Moon

@synthesize moonArray=_moonArray;
@synthesize LEFTEDGE=_LEFTEDGE;
@synthesize dataSource=_dataSource;


- (id)initWithFrame:(CGRect)moonRect
{
    self = [super initWithFrame:moonRect];
    if (self) {
        self.LEFTEDGE = -1.0;
        
        // No events for the moon surface
        self.userInteractionEnabled = NO;
        
        NSString *moonPath = [[NSBundle mainBundle] pathForResource:@"Moon" ofType:@"plist"];
        NSMutableDictionary *moonDict = [NSMutableDictionary dictionaryWithContentsOfFile:moonPath];
        self.vectorName = @"[Moon init]";
        
        // Cache the lunar terrain data
        self.moonArray = [[[NSMutableArray arrayWithObject:[moonDict objectForKey:@"paths"]] objectAtIndex:0] objectAtIndex:0];
    }
    return self;
}

- (void)addFeature:(int)feature atPosition:(int)index
{
    index = index + 10;
    if (index >= 0 && index < self.moonArray.count) {
        NSDictionary *item = [self.moonArray objectAtIndex:index];
        if (item) {
            NSMutableDictionary *modifiedItem = [NSMutableDictionary dictionaryWithDictionary:item];
            NSNumber *yes = [NSNumber numberWithBool:YES];
            switch (feature) {
                case 1:
                    [modifiedItem setObject:yes forKey:@"lander"];
                    break;
                case 2:
                    [modifiedItem setObject:yes forKey:@"flag"];
                    break;
                case 3:
                    [modifiedItem setObject:yes forKey:@"tipped_left"];
                    break;
                case 4:
                    [modifiedItem setObject:yes forKey:@"tipped_right"];
                    break;
            }
            [self.moonArray replaceObjectAtIndex:index withObject:modifiedItem];
        }
    }
}

- (float)terrainHeight:(short)xCoordinate
{
    float averageHeight = 0.0f;
    short x = xCoordinate + 10;
    if (x >= 0 && x < self.moonArray.count) {
        if (x == (self.moonArray.count - 1)) {
            float elevation1 = [[[self.moonArray objectAtIndex:(x)] objectForKey:@"y"] floatValue];
            averageHeight = elevation1;
        }
        else {
            float elevation1 = [[[self.moonArray objectAtIndex:(x)] objectForKey:@"y"] floatValue];
            float elevation2 = [[[self.moonArray objectAtIndex:(x+1)] objectForKey:@"y"] floatValue];
            averageHeight = (elevation1 + elevation2) / 2;
        }
    }
    //NSLog(@"X:%d  avgHeight:%5.0f", xCoordinate, averageHeight);
    return averageHeight;
}

- (BOOL)hasFeature:(NSString *)feature atIndex:(short)index
{
    BOOL hasFeature = NO;
    index += 10;
    if (index >= 0 && index < self.moonArray.count) {
        hasFeature = ([[self.moonArray objectAtIndex:index] objectForKey:feature] != nil);
    }
    return hasFeature;
}

- (void)DRAWIC
{
}

- (float)DFAKE:(float)yValue
{
    unsigned short y = (unsigned short)yValue;
    y = (y * 3) / 8 + 23;
    return (float)y;
}

- (NSArray *)buildDetailedLunarSurface
{
    // This is the display index
    float x = 0;
    
    // Start building the draw path now
    NSMutableArray *path = [[[NSMutableArray alloc] init] autorelease];
    NSArray *paths = [NSArray arrayWithObject:path];
    
    // Intensity and line type variables
    int DRAWTY = 0;
    int DRAWTZ = 0;
    unsigned DTYPE = 0;
    unsigned DINT = 0;
    const int nextIndex = 1;
    const int terrainIndex = self.LEFTEDGE;
    //NSLog(@"Initial X is %d", terrainIndex);
    
    float TEMP = [self terrainHeight:terrainIndex];//[[item objectForKey:@"y"] floatValue];
    TEMP = [self DFAKE:TEMP];
    if (TEMP < 0)
        TEMP = 0;
    else if (TEMP >= 768)
        TEMP = 768;
    
    float LASTY = TEMP;

    NSNumber *xCoordinate = [NSNumber numberWithFloat:x];
    NSNumber *yCoordinate = [NSNumber numberWithFloat:TEMP];
    NSDictionary *startItem = [NSDictionary dictionaryWithObjectsAndKeys:xCoordinate, @"x", yCoordinate, @"y", nil];
    NSDictionary *moveToStartItem = [NSDictionary dictionaryWithObjectsAndKeys:startItem, @"moveto", nil];
    [path addObject:moveToStartItem];
    
    int DFUDGE = 0;
    int DFUDGE_INC = 1;
    unsigned lineSegments = 0;
    for (int i = terrainIndex; lineSegments < 225; i += nextIndex) {
        BOOL processedRock = NO;
        //BOOL processedFlag = NO;
        //BOOL processedLander = NO;
        BOOL processedMcDonalds = NO;
        
        float IN2 = [self terrainHeight:i];//[[[self.moonArray objectAtIndex:i] objectForKey:@"y"] floatValue];
        IN2 = [self DFAKE:IN2];
        IN2 = IN2 - TEMP;
        if (IN2 < 0) {
            IN2 -= 6;
            IN2 = -IN2;
            IN2 /= 12;
            IN2 = -IN2;
        }
        else {
            IN2 += 6;
            IN2 /= 12;
        }
        
        int k = 12;
        while (k-- > 0) {
            DFUDGE += DFUDGE_INC;
            if (DFUDGE == 3) {
                DFUDGE_INC = -1;
            }
            else if (DFUDGE == -3) {
                DFUDGE_INC = 1;
            }
            
            // Intensity/line type update
            if (--DRAWTY < 0) {
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
            }
            
            TEMP = TEMP + DFUDGE;
            TEMP = TEMP + IN2;
            
            float S_TEMP = TEMP;
            TEMP = TEMP - LASTY;
            LASTY += TEMP;
            
            xCoordinate = [NSNumber numberWithInt:4];
            yCoordinate = [NSNumber numberWithInt:TEMP];
            NSMutableDictionary *drawItem = [NSDictionary dictionaryWithObjectsAndKeys:xCoordinate, @"x", yCoordinate, @"y", nil];
            [path addObject:drawItem];
            
            TEMP = S_TEMP;
            lineSegments++;
            
            //NSLog(@"i: %d  lineSeg: %d  TEMP: %3.0f  IN2: %3.0f  LASTY: %3.0f  drawTo: %@", i, lineSegments, TEMP, IN2, LASTY, NSStringFromCGPoint(drawToPoint));
            
            // Now add the rocks
            NSDictionary *rockDict = nil;
            NSArray *rockArray = nil;
            if (!processedRock && [self hasFeature:@"rock" atIndex:i]) {
                //NSLog(@"has rock at X=%d", i);
                if (!rockDict) {
                    NSString *rockPath = [[NSBundle mainBundle] pathForResource:@"Rock" ofType:@"plist"];
                    rockDict = [NSDictionary dictionaryWithContentsOfFile:rockPath];
                    rockArray = [rockDict objectForKey:@"paths"];
                }
                
                // Add the rock to the draw path
                NSEnumerator *pathEnumerator = [rockArray objectEnumerator];
                NSArray *currentEntry;
                while ((currentEntry = [pathEnumerator nextObject])) {
                    [path addObject:currentEntry];
                }
                
                // Processed this rock
                processedRock = YES;
            }

#if 0
            // Now add the flags
            NSDictionary *flagDict = nil;
            NSArray *flagArray = nil;
            if (!processedFlag && [self hasFeature:@"flag" atIndex:i]) {
                if (!flagDict) {
                    NSString *flagPath = [[NSBundle mainBundle] pathForResource:@"Flag" ofType:@"plist"];
                    flagDict = [NSDictionary dictionaryWithContentsOfFile:flagPath];
                    flagArray = [rockDict objectForKey:@"paths"];
                }
                
                // Add the flag to the draw path
                NSEnumerator *pathEnumerator = [flagArray objectEnumerator];
                NSArray *currentEntry;
                while ((currentEntry = [pathEnumerator nextObject])) {
                    [path addObject:currentEntry];
                }
                
                // Processed this flag
                processedFlag = YES;
            }
            
            // Now add the landers
            NSDictionary *landerDict = nil;
            NSArray *landerArray = nil;
            if (!processedLander && [self hasFeature:@"lander" atIndex:i]) {
                if (!landerDict) {
                    NSString *landerPath = [[NSBundle mainBundle] pathForResource:@"Lander" ofType:@"plist"];
                    landerDict = [NSDictionary dictionaryWithContentsOfFile:landerPath];
                    landerArray = [landerDict objectForKey:@"paths"];
                }
                
                // Add the lander to the draw path
                NSEnumerator *pathEnumerator = [landerArray objectEnumerator];
                NSArray *outerEntry;
                while ((outerEntry = [pathEnumerator nextObject])) {
                    NSEnumerator *vectorEnumerator = [outerEntry objectEnumerator];
                    NSArray *innerEntry;
                    while ((innerEntry = [vectorEnumerator nextObject])) {
                        [path addObject:innerEntry];
                    }
                }
                
                // Processed this lander
                processedLander = YES;
            }
#endif
            
            // And maybe a McDonalds
            NSDictionary *macDict = nil;
            NSArray *macArray = nil;
            if (!processedMcDonalds && [self hasFeature:@"mcdonalds" atIndex:i]) {
                //NSLog(@"has macdonalds at X=%d", i);
                if (!macDict) {
                    NSString *macPath = [[NSBundle mainBundle] pathForResource:@"McDonalds" ofType:@"plist"];
                    macDict = [NSDictionary dictionaryWithContentsOfFile:macPath];
                    macArray = [macDict objectForKey:@"paths"];
                }
                
                // Add McDonalds to the draw path
                NSEnumerator *pathEnumerator = [macArray objectEnumerator];
                NSArray *currentEntry;
                while ((currentEntry = [pathEnumerator nextObject])) {
                    [path addObject:currentEntry];
                }
                
                // And McDondald's is drawn
                processedMcDonalds = YES;
            }
        }
    }
    return paths;
}

- (NSArray *)buildLunarSurface
{
    // Start building the draw path now
    NSMutableArray *path = [[[NSMutableArray alloc] init] autorelease];
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

- (void)viewCloseUp:(float)xCoordinate
{
    if (self.LEFTEDGE < 0 || (self.LEFTEDGE >= 0 && self.LEFTEDGE != xCoordinate)) {
        self.LEFTEDGE = xCoordinate;
        [self setNeedsDisplay];
    }
}

- (void)viewNormal
{
    if (self.LEFTEDGE >= 0) {
        self.LEFTEDGE = -1.0;
        [self setNeedsDisplay];
    }
}

- (BOOL)viewIsCloseup
{
    return (self.LEFTEDGE > 0);
}

- (void)buildMoonSurface
{
    if (self.LEFTEDGE > 0)
        self.drawPaths = [self buildDetailedLunarSurface];
    else
        self.drawPaths = [self buildLunarSurface];
}

- (void)drawRect:(CGRect)rect
{
    // Decide which view to show
    [self buildMoonSurface];
    
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0 );
    [super drawRect:rect];
    CGContextRestoreGState(context);
}

- (void)dealloc
{
    [_moonArray release];
    
    [super dealloc];
}

@end
