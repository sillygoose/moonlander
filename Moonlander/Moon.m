//
//  Moon.m
//  Moonlander
//
//  Created by Rick on 5/26/11.
//  Copyright 2011, 2012 Paradigm Systems. All rights reserved.
//

#import "Moon.h"


@implementation Moon

@synthesize moonArray=_moonArray;
@synthesize dirtySurface=_dirtySurface;

@synthesize MACX=_MACX;
@synthesize MACY=_MACY;
@synthesize displayHasMcDonalds=_displayHasMcDonalds;
@synthesize mcdExists=_mcdExists;

@synthesize currentView=_currentView;
@synthesize LEFTEDGE=_LEFTEDGE;


- (id)initWithFrame:(CGRect)moonRect
{
    self = [super initWithFrame:moonRect];
    if (self) {
        // Basic initializations
        self.LEFTEDGE = -1;
        self.mcdExists = YES;
        
        // Hide the view for now
        self.hidden = YES;

        // No events for the moon surface
        self.userInteractionEnabled = NO;

        // Read the moon drawing dictionary
        NSString *moonPath = [[NSBundle mainBundle] pathForResource:@"Moon" ofType:@"plist"];
        NSMutableDictionary *moonDict = [NSMutableDictionary dictionaryWithContentsOfFile:moonPath];
        self.vectorName = @"[Moon init]";

        // Cache the lunar terrain data
        self.moonArray = [[[NSMutableArray arrayWithObject:[moonDict objectForKey:@"paths"]] objectAtIndex:0] objectAtIndex:0];
    }
    return self;
}

- (short)terrainHeight:(short)index
{
    short terrainHeight = 0;
    short ti = index + 10;
    if (ti >= 0 && ti < self.moonArray.count) {
        terrainHeight = [[[self.moonArray objectAtIndex:ti] objectForKey:@"y"] intValue];
    }
    return terrainHeight;
}

- (short)averageTerrainHeight:(short)index
{
    short leftHeight = [self terrainHeight:index];
    short rightHeight = [self terrainHeight:index+1];
    short averageHeight = (leftHeight + rightHeight) / 2;
    return averageHeight;
}

- (void)setTerrainHeight:(short)height atIndex:(short)index
{
    short ti = index + 10;
    if (ti >= 0 && ti < self.moonArray.count) {
        NSMutableDictionary *item = [self.moonArray objectAtIndex:ti];
        if (item) {
            NSNumber *newHeight = [NSNumber numberWithInt:height];
            [item setObject:newHeight forKey:@"y"];
            [self.moonArray replaceObjectAtIndex:ti withObject:item];
        }
    }
}

- (void)modifyTerrainHeight:(short)deltaHeight atIndex:(short)index
{
    short oldHeight = [self terrainHeight:index];
    oldHeight -= deltaHeight;
    [self setTerrainHeight:oldHeight atIndex:index];
    self.dirtySurface = YES;
}

- (TerrainFeature)featureAtIndex:(short)index
{
    TerrainFeature tf = TF_Nothing;
    index += 10;
    NSNumber *feature = [[self.moonArray objectAtIndex:index] objectForKey:@"feature"];
    if (feature) {
        tf = [feature intValue];
    }
    return tf;
}

- (BOOL)hasFeature:(TerrainFeature)feature atIndex:(short)index
{
    BOOL hasFeature = NO;
    index += 10;
    if (index >= 0 && index < self.moonArray.count) {
        hasFeature = ([[self.moonArray objectAtIndex:index] objectForKey:@"feature"
                       ] != nil);
    }
    return hasFeature;
}

- (void)addFeature:(TerrainFeature)feature atIndex:(short)index
{
    index = index + 10;
    if (index >= 0 && index < self.moonArray.count) {
        NSMutableDictionary *item = [self.moonArray objectAtIndex:index];
        if (item) {
            // Add the feature to the feature database
            NSNumber *newFeature = [NSNumber numberWithInt:feature];
            [item setObject:newFeature forKey:@"feature"];
            [self.moonArray replaceObjectAtIndex:index withObject:item];
            self.dirtySurface = YES;
        }
    }
}

- (void)addFeature:(TerrainFeature)feature atIndex:(short)index refresh:(BOOL)action
{
    [self addFeature:feature atIndex:index];
    if (action) {
        [self refreshCloseUpView];
    }
}

- (void)removeFeature:(TerrainFeature)feature atIndex:(short)index
{
    index += 10;
    if (index >= 0 && index < self.moonArray.count) {
        NSMutableDictionary *terrainFeature = [self.moonArray objectAtIndex:index];
        TerrainFeature tf = [[terrainFeature objectForKey:@"feature"] intValue];
        if (tf != TF_Nothing) {
            if (tf == TF_McDonalds || tf == TF_McDonaldsEdge) {
                self.mcdExists = NO;
            }
            else {
                [terrainFeature removeObjectForKey:@"feature"];
            }
            self.dirtySurface = YES;
        }
    }
}

- (void)alterMoon:(short)alterChange atIndex:(short)terrainIndex
{
    //ALTER
    TerrainFeature oldShip = TF_OldLanderTippedLeft;
    short leftIndex = terrainIndex;
    short rightIndex = terrainIndex + 1;
    short leftElevation = [self terrainHeight:leftIndex];
    short rightElevation = [self terrainHeight:rightIndex];
    if ((rightElevation - leftElevation) < 0) {
        oldShip = TF_OldLanderTippedRight;
    }
    
    //ALTERP
    [self addFeature:oldShip atIndex:leftIndex];
    
    //ALTERL
    while (alterChange) {
        [self modifyTerrainHeight:alterChange atIndex:leftIndex];
        [self modifyTerrainHeight:alterChange atIndex:rightIndex];
        leftIndex--;
        rightIndex++;
        
        // Alter out till done
        alterChange /= 2;
        alterChange = -alterChange;
    }
    
    [self setNeedsDisplay];
}

- (short)DFAKE:(short)yValue
{
    short y = yValue;
    y = (y * 3) / 8 + 23;
    return y;
}

- (void)addFeatureToView:(TerrainFeature)tf atTerrainIndex:(short)ti atX:(short)xPos
{
    const float CrashedLanderSizeWidth = 72;
    const float CrashedLanderSizeHeight = 64;
    const float CrashedLanderVertAdj = 64;
    const float LeftCrashedLanderHorizAdj = -44;
    const float RightCrashedLanderHorizAdj = -30;
    const float CrashedLanderVertClip = 20;
    
    const float FlagHorizAdj = 0;
    
    const float LanderVertAdj = 48;
    const float LanderHorizAdj = -32;
    
    const char *FeatureFiles[] = { NULL, "OldLander", "Flag", "OldLander", "OldLander", "Rock", NULL, "McDonalds" };
    const CGSize FeatureSizes[] = { CGSizeMake(0, 0), CGSizeMake(72, 64), CGSizeMake(22, 22), CGSizeMake(CrashedLanderSizeWidth, CrashedLanderSizeHeight), CGSizeMake(CrashedLanderSizeWidth, CrashedLanderSizeHeight), CGSizeMake(42, 42), CGSizeMake(0, 0), CGSizeMake(160, 72) };
    CGFloat verticalAdjust[] = { 0, LanderVertAdj, FeatureSizes[TF_OldFlag].height, CrashedLanderVertAdj, CrashedLanderVertAdj, 33, 0, FeatureSizes[TF_McDonalds].height - 10 };
    CGFloat horizontalAdjust[] = { 0, LanderHorizAdj, FlagHorizAdj, LeftCrashedLanderHorizAdj, RightCrashedLanderHorizAdj, -20, -24, -76 };
    CGFloat verticalClip[] = { 0, 0, 0, CrashedLanderVertClip, -CrashedLanderVertClip, 0, 0, 0 };

    // Check if we can draw the feature
    if (!(tf == TF_Nothing || tf == TF_McDonaldsEdge)) {
        if (tf != TF_McDonalds || (self.mcdExists && xPos > 25 && xPos < 880)) {
            short leftHeight = [self DFAKE:[self terrainHeight:(ti)]];
            short rightHeight = [self DFAKE:[self terrainHeight:(ti+1)]];
            short averageHeight = (leftHeight + rightHeight) / 2;
            
            // Angle of old landers depends on the terrain and the feature type
            float angleAdjust = 0;
            if (tf == TF_OldLander || tf == TF_OldLanderTippedLeft || tf == TF_OldLanderTippedRight) {
                // Adjust sitting position for elevation
                if (leftHeight - rightHeight) {
                    const float TwentyTwoDegrees = 0.383972f;
                    angleAdjust += (leftHeight - rightHeight > 0) ? -TwentyTwoDegrees : TwentyTwoDegrees;
                }
                
                // Adjust for tipped landers
                if (tf == TF_OldLanderTippedLeft || tf == TF_OldLanderTippedRight) {
                    angleAdjust += (tf == TF_OldLanderTippedLeft) ? M_PI_2 : -M_PI_2;
                }
            }
            else if (tf == TF_McDonalds) {
                // We are displaying MCD
                self.displayHasMcDonalds = YES;
                
                // MACB1 Use the smaller of the two
                self.MACY = (leftHeight < rightHeight) ? leftHeight : rightHeight;
                self.MACX = xPos;
                
                // Fudge values to McD door
                self.MACX -= horizontalAdjust[TF_McDonaldsEdge];
            }

            CGRect frameRect;
            frameRect.origin = CGPointMake(xPos, averageHeight);
            frameRect.size = FeatureSizes[tf];
            frameRect.origin.x += horizontalAdjust[tf];
            frameRect.origin.y += verticalAdjust[tf];
            frameRect.origin.y = frameRect.origin.y - frameRect.size.height;

            // Load the feature drawing paths
            NSString *featureFile = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:FeatureFiles[tf]] ofType:@"plist"];
            VGView *featureView = [[VGView alloc] initWithFrame:frameRect withPaths:featureFile];
            //featureView.backgroundColor = [UIColor grayColor];
            
            // Add the rotation to the subview if requested
            if (angleAdjust) {
                CGAffineTransform t = featureView.transform;
                t = CGAffineTransformRotate(t, angleAdjust);
                featureView.transform = t;
            }

            // Apply any clipping
            featureView.clipsToBounds = YES;
            CGRect clipped = featureView.bounds;
            clipped.origin.x += verticalClip[tf];
            featureView.bounds = clipped;
            
            // Add the feature to view
            [self addSubview:featureView];
        }
    }
}

- (NSArray *)buildDetailedLunarSurface
{
    // Assume we have no McDonalds
    self.displayHasMcDonalds = NO;
    
    // This is the display index
    short x = 0;
    
    // Start building the draw path now
    NSMutableArray *path = [[NSMutableArray alloc] init];
    NSArray *paths = [NSArray arrayWithObject:path];
    
    // Intensity and line type variables
    int DRAWTY = 0;
    int DRAWTZ = 0;
    unsigned DTYPE = 0;
    unsigned DINT = 0;
    
    //DRAWM2  Index increment and index in the terrain map
    const int nextIndex = 1;
    const int terrainIndex = self.LEFTEDGE;
    
    //DRW2L5  Squeeze vertical into the screen dimension
    short TEMP = [self terrainHeight:terrainIndex];
    TEMP = [self DFAKE:TEMP];
    if (TEMP < 0)
        TEMP = 0;
    else if (TEMP > self.frame.size.height)
        TEMP = self.frame.size.height;
    short LASTY = TEMP;

    NSNumber *xCoordinate = [NSNumber numberWithInt:x];
    NSNumber *yCoordinate = [NSNumber numberWithInt:TEMP];
    NSDictionary *startItem = [NSDictionary dictionaryWithObjectsAndKeys:xCoordinate, @"x", yCoordinate, @"y", nil];
    NSDictionary *moveToStartItem = [NSDictionary dictionaryWithObjectsAndKeys:startItem, @"moveto", nil];
    [path addObject:moveToStartItem];
    
    NSString *viewName = @"detailedMoon";
    NSDictionary *name = [NSDictionary dictionaryWithObjectsAndKeys:viewName, @"name", nil];
    [path addObject:name];
    
    int DFUDGE = 0;
    int DFUDGE_INC = 1;
    unsigned lineSegments = 0;
    for (short i = terrainIndex; lineSegments < 225; i += nextIndex) {
        // DRW2L:
        short IN2 = [self terrainHeight:i];
        IN2 = [self DFAKE:IN2];
        IN2 = IN2 - TEMP;
        if (IN2 < 0) {
            IN2 -= 6;
            IN2 = -IN2;
            IN2 /= 12;
            IN2 = -IN2;
        }
        else {
            // DRAW2G:
            IN2 += 6;
            IN2 /= 12;
        }
        
        int k = 12;
        while (k-- > 0) {
            DFUDGE += DFUDGE_INC;
            // DRAW2V:	
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
            
            // DRAW2W:
            TEMP = TEMP + DFUDGE;
            TEMP = TEMP + IN2;
            
            float S_TEMP = TEMP;
            TEMP = TEMP - LASTY;
            LASTY += TEMP;
            
            x += 4;
            
            //NSLog(@"TEMP: %d", TEMP);
            xCoordinate = [NSNumber numberWithInt:4];
            yCoordinate = [NSNumber numberWithInt:TEMP];
            NSMutableDictionary *drawItem = [NSDictionary dictionaryWithObjectsAndKeys:xCoordinate, @"x", yCoordinate, @"y", nil];
            [path addObject:drawItem];
            
            TEMP = S_TEMP;
            lineSegments++;
        }
    }
    
    //DRAW2X
    short RET1 = self.LEFTEDGE;
    short SP = 19;
    short IN1 = 24;
    //short RET2 = RET1;          // Index into terrain elevation table
    while (SP) {
        //DRAW2Y
        TerrainFeature tf = [self featureAtIndex:RET1];
        if (tf > TF_Nothing && tf != TF_McDonaldsEdge) {
            [self addFeatureToView:tf atTerrainIndex:RET1 atX:IN1];
        }
        
        // Bump the terrain index and the X position
        RET1 += 1;
        IN1 += 48;
        SP -= 1;
    }
    
    return paths;
}

- (NSArray *)buildLunarSurface
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
    
    short x = [[item objectForKey:@"x"] intValue];
    short y = [[item objectForKey:@"y"] intValue];
    y = y / 32 + 23;

    previousPoint.x = x;
    previousPoint.y = y;
    
    NSNumber *xCoordinate = [NSNumber numberWithFloat:x];
    NSNumber *yCoordinate = [NSNumber numberWithFloat:y];
    NSDictionary *startItem = [NSDictionary dictionaryWithObjectsAndKeys:xCoordinate, @"x", yCoordinate, @"y", nil];
    NSDictionary *moveToStartItem = [NSDictionary dictionaryWithObjectsAndKeys:startItem, @"moveto", nil];
    [path addObject:moveToStartItem];
    
    for (int i = secondIndex; i < self.moonArray.count; i += nextIndex) {
        x = [[[self.moonArray objectAtIndex:i] objectForKey:@"x"] intValue];
        y = [[[self.moonArray objectAtIndex:i] objectForKey:@"y"] intValue];
        short scaledY = y / 32 + 23;
        
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

- (void)refreshCloseUpView
{
    if (self.currentView == TV_Detailed) {
        self.drawPaths = [self buildDetailedLunarSurface];
        self.dirtySurface = NO;
        [self setNeedsDisplay];
    }
}

- (void)useCloseUpView:(short)xCoordinate
{
    if ((self.currentView == TV_Normal) || (self.currentView == TV_Detailed && self.LEFTEDGE != xCoordinate) || self.dirtySurface) {
        // Remove the subviews whenever we change
        for (UIView *subView in [self subviews]) {
            [subView removeFromSuperview];
        }
        
        self.currentView = TV_Detailed;
        self.LEFTEDGE = xCoordinate;
        self.drawPaths = [self buildDetailedLunarSurface];
        self.dirtySurface = NO;
        [self setNeedsDisplay];
    }
}

- (void)useNormalView
{
    if (self.currentView != TV_Normal) {
        // Remove the subviews whenever we change
        for (UIView *subView in [self subviews]) {
            [subView removeFromSuperview];
        }

        self.currentView = TV_Normal;
        self.drawPaths = [self buildLunarSurface];
        [self setNeedsDisplay];
    }
}

- (BOOL)viewIsDetailed
{
    return (self.currentView == TV_Detailed);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
