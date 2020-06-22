//
//  GameCenterManager.m
//  Moonlander Classic
//
//  Created by Rick Naro on 5/10/12.
//  Copyright (c) 2012 Rick Naro. All rights reserved.
//

#import "GameCenterManager.h"
#import <GameKit/GameKit.h>


@implementation GameCenterManager
    
@synthesize earnedAchievementCache;
@synthesize delegate;
    
    
#pragma mark -
#pragma mark Initialization
    
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
    
- (void)dealloc
{
    self.earnedAchievementCache = nil;
}
    
    
    
#pragma mark -
#pragma mark Game Center interface
    
+ (BOOL)isGameCenterAvailable
{
    // Check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // Check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}
    
    
#pragma mark -
#pragma mark Property setters
    
-(void) setLastError:(NSError*)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameCenterManager ERROR: %@", [[_lastError userInfo] description]);
    }
}
    
    
#pragma mark -
#pragma mark UIViewController stuff
    
- (UIViewController*)getRootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}
    
- (void)presentViewController:(UIViewController*)vc
{
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES completion:nil];
}

- (void)authenticateLocalPlayer
{
    __weak GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        [self setLastError:error];
        if (localPlayer.authenticated) {
        }
        else if (viewController) {
            [self presentViewController:viewController];
        }
        [self.delegate processedAuthorization:[GKLocalPlayer localPlayer] error:error];
    };
}
    
    
#pragma mark -
#pragma mark Achievements

- (void)loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        // Create the local cache of achievements
        NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity:[achievements count]];
        for (GKAchievement *achievement in achievements) {
            [tempCache setObject:achievement forKey:achievement.identifier];
        }
        self.earnedAchievementCache = tempCache;
        
        // Update the delegate on the action
        [self.delegate achievementsLoaded:achievements error:error];
    }];
}

- (GKAchievement *)getAchievement:(NSString *)identifier
{
    GKAchievement *achievement = nil;
    if (self.earnedAchievementCache != nil) {
        achievement = [self.earnedAchievementCache objectForKey:identifier];
    }
    return achievement;
}

- (void)submitAchievement:(NSString *)identifier percentComplete:(double)percentComplete
{
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [NSString stringWithFormat:@"submitAchievement: %f", percentComplete]]];
#endif
    
    // GameCenter check for duplicate achievements when the achievement is submitted, but if you only want to report
    // new achievements to the user, then you need to check if it's been earned
    // before you submit.  Otherwise you'll end up with a race condition between loadAchievementsWithCompletionHandler
    // and reportAchievementWithCompletionHandler.  To avoid this, we fetch the current achievement list once,
    // then cache it and keep it updated with any new achievements.
    if (self.earnedAchievementCache == nil) {
        [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
            if (error == nil) {
                NSMutableDictionary *tempCache = [NSMutableDictionary dictionaryWithCapacity:[achievements count]];
                for (GKAchievement *achievement in achievements) {
                    [tempCache setObject:achievement forKey:achievement.identifier];
                }
                self.earnedAchievementCache = tempCache;
                
                // Cache initialized so call recursively to process
                [self submitAchievement:identifier percentComplete:percentComplete];
            }
            else {
                // Something broke loading the achievement list.  Error out, and we'll try again the next time achievement submit
                [self.delegate achievementSubmitted:nil error:error];
            }
        }];
    }
    else {
        // Search the list for the ID we're using...
        GKAchievement* achievement = [self.earnedAchievementCache objectForKey:identifier];
        if (achievement != nil) {
            if ((achievement.percentComplete >= 100.0) || (achievement.percentComplete >= percentComplete)) {
                // Achievement has already been earned so we're done
                achievement = nil;
            }
            achievement.percentComplete = percentComplete;
        }
        else {
            achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
            achievement.percentComplete = percentComplete;
            
            // Add achievement to achievement cache...
            [self.earnedAchievementCache setObject:achievement forKey:achievement.identifier];
        }
        
        // Update the achievement on Game Center
        if (achievement != nil) {
            achievement.showsCompletionBanner = YES;
            if (achievement.percentComplete > 100.0) achievement.percentComplete = 100.0;
            NSArray *achievements = [NSArray arrayWithObjects:achievement, nil];
            [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"Error in reporting achievements: %@", error);
                }
            }];
        }
    }
}

- (void)resetAchievements
{
#if defined(TESTFLIGHT_SDK_VERSION) && defined(USE_TESTFLIGHT)
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), @"resetAchievements"]];
#endif
    self.earnedAchievementCache = nil;
    [GKAchievement resetAchievementsWithCompletionHandler: ^(NSError *error) {
        assert([NSThread isMainThread]);
        [self.delegate achievementResetResult:error];
    }];
}

@end
