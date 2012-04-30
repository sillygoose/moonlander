//
//  L0AppDelegate.h
//  Moonlander
//
//  Created by Rick Naro on 4/30/12.
//  Copyright (c) 2012 Paradigm Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface L0AppDelegate : NSObject <UIAccelerometerDelegate>
{
	BOOL                _hysteresisExcited;
	UIAcceleration*     _lastAcceleration;
}


@property (nonatomic) BOOL hysteresisExcited;
@property (nonatomic) UIAcceleration* lastAcceleration;

@end

